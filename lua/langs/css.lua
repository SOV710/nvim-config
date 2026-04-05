return {
  filetypes = { 'css', 'scss', 'sass' },
  treesitter = { 'css', 'scss' },

  lsp = {
    cssls = {
      cmd = { 'vscode-css-language-server', '--stdio' },
      root_markers = { 'package.json', '.git' },
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
      },
    },

    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
    },
  },

  formatter = 'biome',
  linter = 'stylelint',

  mason = { 'css-lsp', 'biome', 'stylelint' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
