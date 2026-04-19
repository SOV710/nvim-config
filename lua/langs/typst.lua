-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      typst = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/uben0/tree-sitter-typst',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'typst' },
          },
        },
      },
    },
  },

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
