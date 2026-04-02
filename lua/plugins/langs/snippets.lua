return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  lazy = true, -- loaded by blink.cmp when needed
  config = function()
    local luasnip = require("luasnip")

    luasnip.setup({
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    })

    -- Load custom Lua-based snippets from lua/snippets/
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
    })

    -- Load friendly-snippets if installed (optional dependency)
    local ok, _ = pcall(require, "luasnip.loaders.from_vscode")
    if ok then
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  end,
}
