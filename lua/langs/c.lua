return {
  filetypes = { "c", "cpp" },
  treesitter = { "c", "cpp" },
  lsp = "clangd",
  formatter = "clang-format",
  dap = "codelldb",
  mason = { "clangd", "clang-format", "codelldb" },
  plugins = {
    { "p00f/clangd_extensions.nvim", lazy = true },
  },
}
