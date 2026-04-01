return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    local colors = require("plugins.ui.heirline.colors")
    local statusline = require("plugins.ui.heirline.statusline")
    local tabline_mod = require("plugins.ui.heirline.tabline")

    -- Always show tabline (even with 1 tab, we show the window list)
    vim.o.showtabline = 2

    require("heirline").setup({
      statusline = statusline,
      tabline = tabline_mod.tabline,
      opts = { colors = colors.get() },
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("heirline-colors", { clear = true }),
      callback = function()
        require("heirline.utils").on_colorscheme(colors.get)
      end,
    })
  end,
}
