-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      dockerfile = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/camdencheek/tree-sitter-dockerfile',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'dockerfile' },
          },
        },
      },
    },
  },

  lsp = {
    dockerls = {
      cmd = { 'docker-langserver', '--stdio' },
      root_markers = { 'Dockerfile', '.git' },
    },
  },

  -- linter: hadolint — comprehensive Dockerfile linter
  -- nvim-lint name: "hadolint"
  linter = 'hadolint',

  -- formatter: not set — no standard Dockerfile formatter

  mason = { 'dockerfile-language-server', 'hadolint' },
}
