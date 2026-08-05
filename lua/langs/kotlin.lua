-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      kotlin = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/fwcd/tree-sitter-kotlin',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'kotlin' },
          },
        },
      },
    },
  },
}
