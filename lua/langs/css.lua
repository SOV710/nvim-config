-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'css', 'scss', 'sass' },
  treesitter = {
    languages = {
      css = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-css',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'css' },
          },
        },
      },
      scss = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/serenadeai/tree-sitter-scss',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'scss' },
          },
        },
      },
    },
  },

  lsp = {
    cssls = {
      cmd = { 'vscode-css-language-server', '--stdio' },
      root_markers = { 'package.json', '.git' },
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
      },
    },

    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
    },
  },

  formatter = 'biome',
  linter = 'stylelint',

  mason = { 'css-lsp', 'biome', 'stylelint' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
