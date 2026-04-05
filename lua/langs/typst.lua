return {
  treesitter = { 'typst' },

  lsp = {
    tinymist = {
      cmd = { 'tinymist' },
      root_markers = { '.git' },
      settings = {
        formatterMode = 'typstyle',
        exportPdf = 'onSave',
        semanticTokens = 'enable',
      },
    },
  },

  -- formatter: not set — tinymist formats via LSP (typstyle bundled)
  -- linter: not set — tinymist provides diagnostics

  mason = { 'tinymist' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    wrap = true,
    linebreak = true,
    spell = true,
  },
}
