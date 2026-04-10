return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp',
  lazy = true, -- loaded by blink.cmp when needed
  config = function()
    local luasnip = require 'luasnip'

    luasnip.setup {
      history = true,
      delete_check_events = 'TextChanged',
      region_check_events = 'CursorMoved',
    }

    -- Load aggregated snippets from lang files (via core.language).
    -- Each snippets function is evaluated exactly once (memoized by fn identity),
    -- then its result is registered against every filetype that bound to it.
    -- This matters for multi-filetype langs (e.g. go → go/gomod/gowork/gotmpl):
    -- without memoization, the same closure would be invoked N times and produce
    -- N independent copies of every snippet node.
    local language = require 'core.language'
    local evaluated = {} ---@type table<function, { [1]: boolean, [2]: any }>
    local warned = {} ---@type table<function, true>
    for ft, fns in pairs(language.snippets) do
      for _, fn in ipairs(fns) do
        if not evaluated[fn] then
          evaluated[fn] = { pcall(fn) }
        end
        local ok, result = evaluated[fn][1], evaluated[fn][2]
        if ok and type(result) == 'table' then
          luasnip.add_snippets(ft, result)
        elseif not ok and not warned[fn] then
          warned[fn] = true
          vim.notify(
            ('lang snippets: failed to load: %s'):format(tostring(result)),
            vim.log.levels.WARN
          )
        end
      end
    end

    -- Load friendly-snippets if installed (optional dependency)
    local ok, _ = pcall(require, 'luasnip.loaders.from_vscode')
    if ok then
      require('luasnip.loaders.from_vscode').lazy_load()
    end
  end,
}
