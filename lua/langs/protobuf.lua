-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      proto = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/treywood/tree-sitter-proto',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            {
              type = 'git',
              url = 'https://github.com/nvim-treesitter/nvim-treesitter',
              branch = 'master',
              path = 'queries/proto',
              lang = 'proto',
            },
          },
        },
      },
    },
  },
}
