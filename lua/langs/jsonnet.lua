-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'jsonnet' },

  treesitter = {
    languages = {
      jsonnet = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/sourcegraph/tree-sitter-jsonnet',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'jsonnet' },
          },
        },
      },
    },
  },
}
