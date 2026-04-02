return {
  treesitter = { "make" },

  -- no LSP, no formatter, no linter

  options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = false, -- Makefiles REQUIRE tabs
  },
}
