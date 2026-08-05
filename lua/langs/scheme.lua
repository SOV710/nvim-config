-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'scheme' },

  treesitter = {
    languages = {
      scheme = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/6cdh/tree-sitter-scheme',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'scheme' },
          },
        },
      },
    },
  },
}
