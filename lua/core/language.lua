-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- Language configuration system.
--- Scans lua/langs/*.lua and aggregates LSP/treesitter/formatter/linter/DAP/plugins
--- into a single source of truth.
---
--- Usage:
---   local language = require("core.language")
---   language.plugins              → LazySpec[] for lazy.nvim
---   language.treesitter           → table<lang, TreesitterLanguageConfig>
---   language.formatters           → table<filetype, string[]> for conform.nvim
---   language.linters              → table<filetype, string[]> for nvim-lint
---   language.mason                → string[] for mason ensure_installed
---   language.dap_adapters         → table<name, AdapterConfig> for nvim-dap
---   language.dap_configurations   → table<filetype, table[]> for nvim-dap
---   language.snippets             → table<filetype, (fun():table[])[]> for LuaSnip add_snippets
---   language.filetypes            → list of tables for vim.filetype.add()
---   language.enable_lsp()         → call after plugins loaded
---   language.enable_options()     → call after plugins loaded
---   language.enable_filetypes()   → call after plugins loaded

---@alias LazySpec table
---@alias DapAdapterConfig table

local M = {
  --- Aggregated results (available immediately after require)
  plugins = {}, ---@type LazySpec[]
  treesitter = {}, ---@type table<string, TreesitterLanguageConfig>
  formatters = {}, ---@type table<string, string[]>
  linters = {}, ---@type table<string, string[]>
  mason = {}, ---@type string[]
  dap_adapters = {}, ---@type table<string, DapAdapterConfig>
  dap_configurations = {}, ---@type table<string, table[]>
  snippets = {}, ---@type table<string, (fun(): table[])[]>
  filetypes = {}, ---@type table[]

  --- Internal state
  _langs = {}, ---@type table<string, LangConfig>
  _lsp_configs = {}, ---@type table<string, table> aggregated LSP server configs
  _seen_lsp_ft = {}, ---@type table<string, table<string, boolean>> per-server filetype dedup
  _seen_ts = {}, ---@type table<string, string>
  _seen_mason = {}, ---@type table<string, boolean>
  _disabled_mason = {}, ---@type table<string, string> pkg_name → disabled lang name
}

---@class LangConfig
---@field enabled?            boolean
---@field filetypes?          string[]
---@field treesitter?         LangTreesitterConfig|false
---@field filetype?           table
---@field lsp?                string|table<string, table>
---@field formatter?          string|string[]
---@field linter?             string|string[]
---@field dap?                LangDapConfig
---@field mason?              string[]
---@field plugins?            LazySpec[]
---@field options?            table<string, any>
---@field snippets?           fun(): table[]
---@field external_deps?      LangExternalDep[]

---@class LangExternalDep
---@field cmd      string   Bare binary name passed to vim.fn.executable()
---@field install  string   Human-readable install command (rendered as health advice)
---@field required boolean  true → health.error on missing; false → health.warn
---@field note?    string   Extra context rendered as a second advice line

---@class LangTreesitterConfig
---@field auto_start? boolean
---@field languages table<string, TreesitterLanguageConfig>

---@class TreesitterLanguageConfig
---@field auto_start? boolean
---@field filetypes? string[]
---@field parser TreesitterParserDefinition
---@field queries? TreesitterQueryDefinition

---@class TreesitterParserDefinition
---@field source TreesitterGitSource
---@field build TreesitterParserBuild

---@class TreesitterGitSource
---@field type '"git"'
---@field url string
---@field branch? string
---@field revision? string
---@field location? string

---@class TreesitterParserBuild
---@field files string[]
---@field generate? boolean

---@class TreesitterQueryDefinition
---@field sources? TreesitterQuerySource[]

---@alias TreesitterQuerySource TreesitterParserQuerySource|TreesitterGitQuerySource

---@class TreesitterParserQuerySource
---@field type '"parser_source"'
---@field lang? string Runtime query target language name; does not affect the source checkout path.

---@class TreesitterGitQuerySource
---@field type '"git"'
---@field url string
---@field branch? string
---@field revision? string
---@field location? string
---@field lang string Runtime query target language name.
---@field path? string Directory inside the checkout that contains `.scm` files. Defaults to `queries`.

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
  if val == nil then
    return {}
  end
  if type(val) == 'string' then
    return { val }
  end
  return val
end

--- Normalize LSP config to table<server_name, server_config>
---@param lsp string|table|nil
---@return table<string, table>
local function normalize_lsp(lsp)
  if lsp == nil then
    return {}
  end
  if type(lsp) == 'string' then
    return { [lsp] = {} }
  end

  local result = {}
  for k, v in pairs(lsp) do
    if type(k) == 'number' then
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
  local result = vim.tbl_deep_extend('force', base, override)
  for k, v in pairs(override) do
    if type(v) == 'table' and type(base[k]) == 'table' then
      if vim.islist(v) and vim.islist(base[k]) then
        if depth > 0 then
          -- Concatenate nested lists (e.g. globalPlugins inside settings)
          local merged = {}
          for _, item in ipairs(base[k]) do
            merged[#merged + 1] = item
          end
          for _, item in ipairs(v) do
            merged[#merged + 1] = item
          end
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

--- Files under lua/langs/ that are NOT lang configs and must be skipped
--- by _scan(). Currently just the :checkhealth langs entry point, which
--- lives at lua/langs/health.lua by nvim convention.
local SCAN_IGNORE = {
  ['health.lua'] = true,
}

--- Scan lua/langs/ directory and load all language configs
function M._scan()
  local dir = vim.fn.stdpath 'config' .. '/lua/langs'
  local handle = vim.uv.fs_scandir(dir)
  if not handle then
    return
  end

  while true do
    local file, ftype = vim.uv.fs_scandir_next(handle)
    if not file then
      break
    end
    if ftype == 'file' and file:match '%.lua$' and not SCAN_IGNORE[file] then
      local name = file:sub(1, -5) -- "rust.lua" → "rust"
      local ok, config = pcall(require, 'langs.' .. name)
      if ok and type(config) == 'table' then
        if config.enabled == false then
          if config.mason then
            for _, pkg in ipairs(config.mason) do
              M._disabled_mason[pkg] = name
            end
          end
        else
          config.filetypes = config.filetypes or { name }
          M._langs[name] = config
        end
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

---@param owner string
---@param config LangConfig
local function collect_treesitter(owner, config)
  if config.treesitter == nil or config.treesitter == false then
    return
  end

  local manifest = config.treesitter
  if type(manifest) ~= 'table' or type(manifest.languages) ~= 'table' then
    error(("lang '%s' has an invalid treesitter manifest"):format(owner))
  end

  local default_auto_start = manifest.auto_start ~= false
  for ts_lang, ts_config in pairs(manifest.languages) do
    if M._seen_ts[ts_lang] then
      error(("duplicate treesitter language '%s' declared in '%s' and '%s'"):format(ts_lang, M._seen_ts[ts_lang], owner))
    end

    if type(ts_config) ~= 'table' or type(ts_config.parser) ~= 'table' then
      error(("lang '%s' treesitter language '%s' is missing parser config"):format(owner, ts_lang))
    end

    local source = ts_config.parser.source
    local build = ts_config.parser.build
    if type(source) ~= 'table' or source.type ~= 'git' then
      error(("lang '%s' treesitter language '%s' must use parser.source.type = 'git'"):format(owner, ts_lang))
    end
    if type(source.url) ~= 'string' or source.url == '' then
      error(("lang '%s' treesitter language '%s' is missing parser.source.url"):format(owner, ts_lang))
    end
    if type(build) ~= 'table' or type(build.files) ~= 'table' or #build.files == 0 then
      error(("lang '%s' treesitter language '%s' must declare parser.build.files"):format(owner, ts_lang))
    end

    local normalized = vim.deepcopy(ts_config)
    normalized.auto_start = normalized.auto_start
    if normalized.auto_start == nil then
      normalized.auto_start = default_auto_start
    end

    if normalized.queries and normalized.queries.sources == nil then
      normalized.queries.sources = {}
    end

    M._seen_ts[ts_lang] = owner
    M.treesitter[ts_lang] = normalized
  end
end

--- Process all loaded language configs into aggregated tables
function M._aggregate()
  for owner, lang in pairs(M._langs) do
    local fts = lang.filetypes --[[@as string[] ]]

    -- Plugins: just append, no dedup needed (lazy.nvim handles duplicate specs)
    if lang.plugins then
      for _, spec in ipairs(lang.plugins) do
        M.plugins[#M.plugins + 1] = spec
      end
    end

    -- Treesitter: aggregate native parser/query manifests
    collect_treesitter(owner, lang)

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

    -- Snippets: store the function reference under every filetype of the lang.
    -- The function is evaluated once at consumption time (memoized by fn identity),
    -- with the result reused across every ft bound to it. See plugins/langs/snippets.lua.
    if lang.snippets then
      for _, ft in ipairs(fts) do
        M.snippets[ft] = M.snippets[ft] or {}
        M.snippets[ft][#M.snippets[ft] + 1] = lang.snippets
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
        local merge_config = vim.tbl_extend('force', {}, config)
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
        vim.api.nvim_create_autocmd('FileType', {
          pattern = ft,
          desc = ('lang(%s): set options'):format(ft),
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
