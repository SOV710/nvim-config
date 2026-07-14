-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'elisp' },

  filetype = {
    extension = {
      el = 'elisp',
    },
  },

  treesitter = {
    languages = {
      elisp = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/Wilfred/tree-sitter-elisp',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'elisp' },
          },
        },
      },
    },
  },
}
