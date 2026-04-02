return {
  treesitter = { "html" },

  lsp = {
    html = {
      init_options = {
        provideFormatter = false,
      },
    },

    biome = {},
  },

  formatter = "biome",

  mason = { "html-lsp", "biome" },
}
