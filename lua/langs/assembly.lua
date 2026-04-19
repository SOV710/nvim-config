-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'asm', 'nasm', 'masm', 'vmasm' },
  treesitter = {
    languages = {
      asm = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/RubixDev/tree-sitter-asm',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'asm' },
          },
        },
      },
    },
  },

  lsp = {
    asm_lsp = {
      cmd = { 'asm-lsp' },
      root_markers = { '.asm-lsp.toml', '.git' },
    },
  },

  mason = { 'asm-lsp' },
}
