return {
  filetypes = { "css", "scss", "sass" },
  treesitter = { "css", "scss" },

  lsp = {
    cssls = {
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    },

    biome = {},
  },

  formatter = "biome",
  linter = "stylelint",

  mason = { "css-lsp", "biome", "stylelint" },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
