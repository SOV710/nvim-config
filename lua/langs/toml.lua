-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      toml = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter-grammars/tree-sitter-toml',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'toml' },
          },
        },
      },
    },
  },

  lsp = {
    taplo = {
      cmd = { 'taplo', 'lsp', 'stdio' },
      root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
    },
  },

  -- formatter: not set — taplo formats via LSP
  -- linter: not set — taplo validates via LSP

  mason = { 'taplo' },
}
