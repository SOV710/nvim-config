-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      make = {
        filetypes = { 'make', 'automake' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/alemuller/tree-sitter-make',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'make' },
          },
        },
      },
    },
  },

  -- no LSP, no formatter, no linter

  options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = false, -- Makefiles REQUIRE tabs
  },
}
