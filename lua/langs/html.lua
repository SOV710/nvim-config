return {
  treesitter = { 'html' },

  lsp = {
    html = {
      cmd = { 'vscode-html-language-server', '--stdio' },
      root_markers = { 'package.json', '.git' },
      init_options = {
        provideFormatter = false,
      },
    },

    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
    },
  },

  formatter = 'biome',

  mason = { 'html-lsp', 'biome' },
}
