--- Language configuration system.
--- Scans lua/langs/*.lua, aggregates LSP/treesitter/formatter/linter/DAP/plugins
--- into a single source of truth.
---
--- Usage:
---   local language = require("core.language")
---   language.plugins     → LazySpec[] for lazy.nvim
---   language.treesitter  → string[] for nvim-treesitter ensure_installed
---   language.formatters  → table<filetype, string[]> for conform.nvim
---   language.linters     → table<filetype, string[]> for nvim-lint
---   language.mason       → string[] for mason ensure_installed
---   language.enable_lsp()    → call after plugins loaded
---   language.enable_options() → call after plugins loaded

local M = {
  --- Aggregated results (available immediately after require)
  plugins = {}, ---@type LazySpec[]
  treesitter = {}, ---@type string[]
  formatters = {}, ---@type table<string, string[]>
  linters = {}, ---@type table<string, string[]>
  mason = {}, ---@type string[]

  --- Internal state
  _langs = {}, ---@type table<string, LangConfig>
  _seen_lsp = {}, ---@type table<string, boolean>
  _seen_ts = {}, ---@type table<string, boolean>
  _seen_mason = {}, ---@type table<string, boolean>
}

---@class LangConfig
---@field filetypes?  string[]
---@field treesitter? string[] | false
---@field lsp?        string | table<string, table>
---@field formatter?  string | string[]
---@field linter?     string | string[]
---@field dap?        string | string[]
---@field mason?      string[]
---@field plugins?    LazySpec[]
---@field options?    table<string, any>
---@field enabled?    boolean

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
    local fts = lang.filetypes

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
      collect_unique(M.treesitter, M._seen_ts, to_list(parsers))
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
  end
end

----------------------------------------------------------------------
-- Deferred actions (call after plugins are loaded)
----------------------------------------------------------------------

--- Enable all declared LSP servers via Neovim 0.11+ native API
function M.enable_lsp()
  for _, lang in pairs(M._langs) do
    local servers = normalize_lsp(lang.lsp)
    for server, config in pairs(servers) do
      if not M._seen_lsp[server] then
        M._seen_lsp[server] = true
        if next(config) then
          vim.lsp.config(server, config)
        end
        vim.lsp.enable(server)
      end
    end
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

--- Convenience: enable everything that needs deferred setup
function M.enable()
  M.enable_lsp()
  M.enable_options()
end

----------------------------------------------------------------------
-- Self-initialize on first require
----------------------------------------------------------------------
M._scan()
M._aggregate()

return M
