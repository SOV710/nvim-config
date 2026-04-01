return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  config = function()
    local colors = require("plugins.ui.heirline.colors")
    local statusline = require("plugins.ui.heirline.statusline")
    local tabline = require("plugins.ui.heirline.tabline")

    require("heirline").setup({
      statusline = statusline,
      tabline = tabline,
      opts = { colors = colors.get() },
    })

    -- Re-extract colors when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("heirline-colors", { clear = true }),
      callback = function()
        require("heirline.utils").on_colorscheme(colors.get)
      end,
    })
  end,
}
