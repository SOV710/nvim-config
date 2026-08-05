-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      r = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/r-lib/tree-sitter-r',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'r' },
          },
        },
      },
    },
  },
}
