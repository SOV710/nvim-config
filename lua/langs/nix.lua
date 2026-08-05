-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'nix' },

  treesitter = {
    languages = {
      nix = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/nix-community/tree-sitter-nix',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'nix' },
          },
        },
      },
    },
  },
}
