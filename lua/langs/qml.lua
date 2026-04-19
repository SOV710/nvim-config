-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'qml' },
  treesitter = {
    languages = {
      qmljs = {
        filetypes = { 'qml' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/yuja/tree-sitter-qmljs',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'qmljs' },
          },
        },
      },
      qmldir = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/Decodetalkers/tree-sitter-qmldir',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'qmldir' },
          },
        },
      },
    },
  },
}
