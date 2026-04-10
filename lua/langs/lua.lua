return {
  treesitter = { 'lua', 'luadoc', 'luap' },

  lsp = {
    lua_ls = {
      cmd = { 'lua-language-server' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim', 'Snacks' } },
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          completion = { callSnippet = 'Replace' },
          doc = { privateName = { '^_' } },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = 'Disable',
            semicolon = 'Disable',
            arrayIndex = 'Disable',
          },
        },
      },
    },
  },
  formatter = 'stylua',
  mason = { 'lua-language-server', 'stylua' },

  snippets = function()
    local ls = require 'luasnip'
    local s, t, i = ls.snippet, ls.text_node, ls.insert_node
    return {
      -- `localm` → module scaffold: `local M = {}\n\n<cursor>\n\nreturn M`
      s('localm', {
        t { 'local M = {}', '', '' },
        i(0),
        t { '', '', 'return M' },
      }),
      -- `vpri` → `print(vim.inspect(<cursor>))`
      s('vpri', {
        t 'print(vim.inspect(',
        i(1),
        t '))',
      }),
    }
  end,
}
