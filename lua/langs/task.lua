-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'taskrc' },
  treesitter = {
    languages = {
      taskwarrior = {
        filetypes = { 'taskrc' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/SOV710/tree-sitter-taskwarrior',
            branch = 'main',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'taskwarrior' },
          },
        },
      },
    },
  },
  filetype = {
    filename = {
      ['taskrc'] = 'taskrc',
      ['.taskrc'] = 'taskrc',
    },
  },
}
