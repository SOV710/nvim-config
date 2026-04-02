local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

return {
  filetypes = { "vue" },
  treesitter = { "vue" },

  lsp = {
    vue_ls = {},

    vtsls = {
      filetypes = {
        "typescript", "javascript",
        "javascriptreact", "typescriptreact",
        "vue",
      },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript",
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

  mason = { "vue-language-server", "vtsls", "biome" },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
