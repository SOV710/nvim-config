-- Treesitter consumes: language.treesitter → string[]
-- e.g. { "rust", "toml", "c", "cpp", "javascript", "typescript", "tsx", "lua", "python" }

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "LazyFile",
  opts = {
    ensure_installed = require("core.language").treesitter,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
