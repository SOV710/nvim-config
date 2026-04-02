return {
  treesitter = { "lua", "luadoc", "luap" },

  lsp = {
    lua_ls = {
      cmd = { "lua-language-server" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          completion = { callSnippet = "Replace" },
          doc = { privateName = { "^_" } },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    },
  },
  formatter = "stylua",
  mason = { "lua-language-server", "stylua" },
}
