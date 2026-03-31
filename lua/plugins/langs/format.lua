-- Conform consumes: language.formatters → table<filetype, string[]>
-- e.g. { rust = {"rustfmt"}, python = {"black"}, lua = {"stylua"}, c = {"clang-format"}, ... }

return {
  "stevearc/conform.nvim",
  event = "LazyFile",
  opts = {
    formatters_by_ft = require("core.language").formatters,
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  },
  keys = {
    { "<leader>cf", function() require("conform").format() end, desc = "Format buffer" },
  },
}
