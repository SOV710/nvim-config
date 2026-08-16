-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local filetypes = { 'tf', 'terraform', 'terraform-vars', 'hcl' }

return {
  filetypes = filetypes,

  treesitter = {
    languages = {
      terraform = {
        filetypes = filetypes,
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/MichaHoffmann/tree-sitter-hcl',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'terraform' },
          },
        },
      },
    },
  },

  lsp = {
    terraformls = {
      cmd = { 'terraform-ls', 'serve' },
      filetypes = filetypes,
      root_markers = {
        '.terraform',
        '.git',
      },
    },
  },

  -- formatter/linter intentionally not set; terraform-ls + terraform fmt handled externally.
  mason = { 'terraform-ls' },
}
