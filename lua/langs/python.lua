return {
  lsp = "pyright",
  formatter = "black",
  linter = "ruff",
  mason = { "pyright", "black", "ruff" },
  options = {
    tabstop = 4,
    shiftwidth = 4,
  },
}
