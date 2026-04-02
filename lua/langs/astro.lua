return {
  filetypes = { "astro" },
  treesitter = { "astro" },

  lsp = {
    astro = {},

    vtsls = {
      filetypes = {
        "typescript", "javascript",
        "javascriptreact", "typescriptreact",
        "astro",
      },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@astrojs/ts-plugin",
                location = "",
                languages = { "astro" },
              },
            },
          },
        },
      },
    },

    biome = {
      settings = {
        biome = {
          html = {
            experimentalFullSupportEnabled = true,
          },
        },
      },
    },
  },

  formatter = "biome",

  mason = { "astro-language-server", "vtsls", "biome" },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
