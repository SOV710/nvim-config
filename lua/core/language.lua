--- Language configuration system.
--- Scans lua/langs/*.lua, aggregates LSP/treesitter/formatter/linter/DAP/plugins
--- into a single source of truth.
---
--- Usage:
---   local language = require("core.language")
---   language.plugins              → LazySpec[] for lazy.nvim
---   language.treesitter           → string[] for nvim-treesitter ensure_installed
---   language.treesitter_parsers   → table<name, ParserConfig> custom parsers
---   language.formatters           → table<filetype, string[]> for conform.nvim
---   language.linters              → table<filetype, string[]> for nvim-lint
---   language.mason                → string[] for mason ensure_installed
---   language.dap_adapters         → table<name, AdapterConfig> for nvim-dap
---   language.dap_configurations   → table<filetype, table[]> for nvim-dap
---   language.filetypes            → list of tables for vim.filetype.add()
---   language.enable_lsp()         → call after plugins loaded
---   language.enable_options()     → call after plugins loaded
---   language.enable_filetypes()   → call after plugins loaded
---   language.register_treesitter_parsers() → call before treesitter setup

---@alias LazySpec table
---@alias DapAdapterConfig table

local M = {
  --- Aggregated results (available immediately after require)
  plugins = {}, ---@type LazySpec[]
  treesitter = {}, ---@type string[]
  treesitter_parsers = {}, ---@type table<string, TreesitterParserConfig>
  formatters = {}, ---@type table<string, string[]>
  linters = {}, ---@type table<string, string[]>
  mason = {}, ---@type string[]
  dap_adapters = {}, ---@type table<string, DapAdapterConfig>
  dap_configurations = {}, ---@type table<string, table[]>
  filetypes = {}, ---@type table[]

  --- Internal state
  _langs = {}, ---@type table<string, LangConfig>
  _lsp_configs = {}, ---@type table<string, table> aggregated LSP server configs
  _seen_lsp_ft = {}, ---@type table<string, table<string, boolean>> per-server filetype dedup
  _seen_ts = {}, ---@type table<string, boolean>
  _seen_mason = {}, ---@type table<string, boolean>
}

---@class LangConfig
---@field enabled?            boolean
---@field filetypes?          string[]
---@field treesitter?         string[]|false
---@field treesitter_parsers? table<string, TreesitterParserConfig>
---@field filetype?           table
---@field lsp?                string|table<string, table>
---@field formatter?          string|string[]
---@field linter?             string|string[]
---@field dap?                LangDapConfig
---@field mason?              string[]
---@field plugins?            LazySpec[]
---@field options?            table<string, any>

---@class TreesitterParserConfig
---@field url          string
---@field branch?      string
---@field revision?    string
---@field files        string[]
---@field filetype?    string
---@field generate?    boolean

---@class LangDapConfig
---@field adapter        table<string, DapAdapterConfig>
---@field configurations? table<string, table[]>

----------------------------------------------------------------------
-- Normalization helpers
----------------------------------------------------------------------

--- Normalize a value to a list: "foo" → {"foo"}, {"a","b"} → {"a","b"}, nil → {}
---@param val string|string[]|nil
---@return string[]
local function to_list(val)
  if val == nil then return {} end
  if type(val) == "string" then return { val } end
  return val
end

--- Normalize LSP config to table<server_name, server_config>
---@param lsp string|table|nil
---@return table<string, table>
local function normalize_lsp(lsp)
  if lsp == nil then return {} end
  if type(lsp) == "string" then return { [lsp] = {} } end

  local result = {}
  for k, v in pairs(lsp) do
    if type(k) == "number" then
      -- { "pyright", "ruff" } style
      result[v] = {}
    else
      -- { pyright = { settings = ... } } style
      result[k] = v
    end
  end
  return result
end

--- Deep merge two tables, concatenating list-like tables only at depth > 0
--- (nested inside dicts like `settings`). Top-level lists use replacement
--- semantics so that fields like `cmd` and `root_markers` aren't duplicated
--- when the same server appears in multiple lang files.
---@param base table
---@param override table
---@param depth? number
---@return table
local function deep_merge(base, override, depth)
  depth = depth or 0
  local result = vim.tbl_deep_extend("force", base, override)
  for k, v in pairs(override) do
    if type(v) == "table" and type(base[k]) == "table" then
      if vim.islist(v) and vim.islist(base[k]) then
        if depth > 0 then
          -- Concatenate nested lists (e.g. globalPlugins inside settings)
          local merged = {}
          for _, item in ipairs(base[k]) do merged[#merged + 1] = item end
          for _, item in ipairs(v) do merged[#merged + 1] = item end
          result[k] = merged
        end
        -- depth == 0: tbl_deep_extend already replaced, which is correct
      elseif not vim.islist(v) and not vim.islist(base[k]) then
        result[k] = deep_merge(base[k], v, depth + 1)
      end
    end
  end
  return result
end

----------------------------------------------------------------------
-- Scanning
----------------------------------------------------------------------

--- Scan lua/langs/ directory and load all language configs
function M._scan()
  local dir = vim.fn.stdpath("config") .. "/lua/langs"
  local handle = vim.uv.fs_scandir(dir)
  if not handle then return end

  while true do
    local file, ftype = vim.uv.fs_scandir_next(handle)
    if not file then break end
    if ftype == "file" and file:match("%.lua$") then
      local name = file:sub(1, -5) -- "rust.lua" → "rust"
      local ok, config = pcall(require, "langs." .. name)
      if ok and type(config) == "table" and config.enabled ~= false then
        config.filetypes = config.filetypes or { name }
        M._langs[name] = config
      end
    end
  end
end

----------------------------------------------------------------------
-- Aggregation
----------------------------------------------------------------------

--- Deduplicated insert into a list
---@param list string[]
---@param seen table<string, boolean>
---@param items string[]
local function collect_unique(list, seen, items)
  for _, item in ipairs(items) do
    if not seen[item] then
      seen[item] = true
      list[#list + 1] = item
    end
  end
end

--- Process all loaded language configs into aggregated tables
function M._aggregate()
  for _, lang in pairs(M._langs) do
    local fts = lang.filetypes --[[@as string[] ]]

    -- Plugins: just append, no dedup needed (lazy.nvim handles duplicate specs)
    if lang.plugins then
      for _, spec in ipairs(lang.plugins) do
        M.plugins[#M.plugins + 1] = spec
      end
    end

    -- Treesitter: deduplicate parser names
    if lang.treesitter ~= false then
      local parsers = lang.treesitter
      if parsers == nil then
        -- Default: use filetypes as parser names
        parsers = fts
      end
      collect_unique(M.treesitter, M._seen_ts, to_list(parsers --[[@as string[] ]]))
    end

    -- Formatters: map each filetype to its formatter list
    if lang.formatter then
      local fmts = to_list(lang.formatter)
      for _, ft in ipairs(fts) do
        M.formatters[ft] = fmts
      end
    end

    -- Linters: map each filetype to its linter list
    if lang.linter then
      local lints = to_list(lang.linter)
      for _, ft in ipairs(fts) do
        M.linters[ft] = lints
      end
    end

    -- Mason: explicit package names, deduplicated
    if lang.mason then
      collect_unique(M.mason, M._seen_mason, lang.mason)
    end

    -- Treesitter parsers: custom parser definitions
    if lang.treesitter_parsers then
      for name, config in pairs(lang.treesitter_parsers) do
        M.treesitter_parsers[name] = config
      end
    end

    -- DAP adapters and configurations
    if lang.dap then
      if lang.dap.adapter then
        for name, adapter_config in pairs(lang.dap.adapter) do
          M.dap_adapters[name] = adapter_config
        end
      end
      if lang.dap.configurations then
        for ft, configs in pairs(lang.dap.configurations) do
          M.dap_configurations[ft] = M.dap_configurations[ft] or {}
          for _, config in ipairs(configs) do
            table.insert(M.dap_configurations[ft], config)
          end
        end
      end
    end

    -- Filetypes: collect filetype.add() tables
    if lang.filetype then
      M.filetypes[#M.filetypes + 1] = lang.filetype
    end

    -- LSP: aggregate server configs, merging filetypes and settings
    local servers = normalize_lsp(lang.lsp)
    for server, config in pairs(servers) do
      -- Determine filetypes for this server entry
      local server_fts = config.filetypes or fts
      M._seen_lsp_ft[server] = M._seen_lsp_ft[server] or {}

      if not M._lsp_configs[server] then
        -- First occurrence: initialize
        config.filetypes = vim.list_extend({}, server_fts)
        M._lsp_configs[server] = config
        for _, ft in ipairs(server_fts) do
          M._seen_lsp_ft[server][ft] = true
        end
      else
        -- Subsequent occurrence: merge filetypes (union) and deep-merge settings
        local existing = M._lsp_configs[server]
        -- Union filetypes
        existing.filetypes = existing.filetypes or {}
        for _, ft in ipairs(server_fts) do
          if not M._seen_lsp_ft[server][ft] then
            M._seen_lsp_ft[server][ft] = true
            existing.filetypes[#existing.filetypes + 1] = ft
          end
        end
        -- Deep-merge the rest (settings, init_options, etc.)
        local fts_backup = existing.filetypes
        local merge_config = vim.tbl_extend("force", {}, config)
        merge_config.filetypes = nil -- filetypes already handled above
        if next(merge_config) then
          M._lsp_configs[server] = deep_merge(existing, merge_config)
          M._lsp_configs[server].filetypes = fts_backup
        end
      end
    end
  end
end

----------------------------------------------------------------------
-- Deferred actions (call after plugins are loaded)
----------------------------------------------------------------------

--- Enable all declared LSP servers via Neovim 0.11+ native API
function M.enable_lsp()
  for server, config in pairs(M._lsp_configs) do
    if next(config) then
      vim.lsp.config(server, config)
    end
    vim.lsp.enable(server)
  end
end

--- Set up FileType autocmds for language-specific options
function M.enable_options()
  for _, lang in pairs(M._langs) do
    if lang.options then
      for _, ft in ipairs(lang.filetypes) do
        vim.api.nvim_create_autocmd("FileType", {
          pattern = ft,
          desc = ("lang(%s): set options"):format(ft),
          callback = function()
            for opt, val in pairs(lang.options) do
              vim.opt_local[opt] = val
            end
          end,
        })
      end
    end
  end
end

--- Register custom filetypes via vim.filetype.add()
function M.enable_filetypes()
  for _, ft_config in ipairs(M.filetypes) do
    vim.filetype.add(ft_config)
  end
end

--- Register custom treesitter parsers (call before nvim-treesitter setup)
function M.register_treesitter_parsers()
  for name, config in pairs(M.treesitter_parsers) do
    local parsers = require("nvim-treesitter.parsers")
    parsers[name] = {
      install_info = {
        url = config.url,
        branch = config.branch,
        revision = config.revision,
        files = config.files,
        generate = config.generate or false,
      },
      filetype = config.filetype,
      tier = 3,
    }
    if config.filetype then
      vim.treesitter.language.register(name, config.filetype)
    end
  end
end

--- Convenience: enable everything that needs deferred setup
function M.enable()
  M.enable_lsp()
  M.enable_options()
  M.enable_filetypes()
end

----------------------------------------------------------------------
-- Self-initialize on first require
----------------------------------------------------------------------
M._scan()
M._aggregate()

return M
