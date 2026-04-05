return {
  filetypes = { 'astro' },
  treesitter = { 'astro' },

  lsp = {
    astro = {
      cmd = { 'astro-ls', '--stdio' },
      root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    },

    vtsls = {
      cmd = { 'vtsls', '--stdio' },
      root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
      filetypes = {
        'typescript',
        'javascript',
        'javascriptreact',
        'typescriptreact',
        'astro',
      },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = '@astrojs/ts-plugin',
                location = '',
                languages = { 'astro' },
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

  mason = { 'astro-language-server', 'vtsls', 'biome' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
