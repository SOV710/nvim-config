-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = {
    languages = {
      html = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-html',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'html' },
          },
        },
      },
    },
  },

  lsp = {
    html = {
      cmd = { 'vscode-html-language-server', '--stdio' },
      root_markers = { 'package.json', '.git' },
      init_options = {
        provideFormatter = false,
      },
    },

    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
    },
  },

  formatter = 'biome',

  mason = { 'html-lsp', 'biome' },
}
