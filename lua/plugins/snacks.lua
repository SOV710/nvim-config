return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile   = { enabled = true },
    quickfile = { enabled = true },
    scope     = { enabled = true },
  },

  keys = require("core.keymaps.snacks"),

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.option("conceallevel", {
          off = 0,
          on = vim.o.conceallevel,
          name = "Conceal",
        }):map("<leader>uc")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", {
          off = "light",
          on = "dark",
          name = "Dark Background",
        }):map("<leader>ub")
      end,
    })
  end,
}
