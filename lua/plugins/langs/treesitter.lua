return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local language = require("core.language")

    -- Register custom parsers BEFORE calling setup
    language.register_treesitter_parsers()
    require("nvim-treesitter.install").prefer_git = true

    require("nvim-treesitter.configs").setup({
      ensure_installed = language.treesitter,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = false, -- we use flash.nvim treesitter for this
      },
    })
  end,
}
