-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'awk' },

  treesitter = {
    languages = {
      awk = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/Beaglefoot/tree-sitter-awk',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'awk' },
          },
        },
      },
    },
  },
}
