-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'kdl' },
  treesitter = {
    languages = {
      kdl = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/amaanq/tree-sitter-kdl',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'kdl' },
          },
        },
      },
    },
  },

  formatter = 'kdlfmt',
  mason = { 'kdlfmt' },
}
