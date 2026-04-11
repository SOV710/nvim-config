-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

return {
  filetypes = { 'vue' },
  treesitter = { 'vue' },

  lsp = {
    vue_ls = {
      cmd = { 'vue-language-server', '--stdio' },
      root_markers = { 'package.json' },
    },

    vtsls = {
      cmd = { 'vtsls', '--stdio' },
      root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
      filetypes = {
        'typescript',
        'javascript',
        'javascriptreact',
        'typescriptreact',
        'vue',
      },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
                configNamespace = 'typescript',
              },
            },
          },
        },
      },
    },

    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
      settings = {
        biome = {
          html = {
            experimentalFullSupportEnabled = true,
          },
        },
      },
    },
  },

  formatter = 'biome',

  mason = { 'vue-language-server', 'vtsls', 'biome' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
