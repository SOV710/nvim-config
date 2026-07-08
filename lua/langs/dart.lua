-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'dart' },
  treesitter = {
    languages = {
      dart = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/UserNobody14/tree-sitter-dart',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'dart' },
          },
        },
      },
    },
  },

  external_deps = {
    {
      cmd = 'dart',
      required = true,
      install = 'install Dart SDK or Flutter SDK and make sure `dart` is in $PATH',
      note = 'Dart SDK provides `dart language-server --protocol=lsp`',
    },
  },

  lsp = {
    dartls = {
      cmd = { 'dart', 'language-server', '--protocol=lsp' },
      root_markers = { 'pubspec.yaml', 'analysis_options.yaml', '.git' },
    },
  },

  -- formatter: not set - dartls / Dart SDK can format through LSP or dart format
  -- linter: not set - analyzer diagnostics come from dartls

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
