-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'sh', 'bash', 'zsh' },
  treesitter = {
    languages = {
      bash = {
        filetypes = { 'sh' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-bash',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'bash' },
          },
        },
      },
    },
  },

  lsp = {
    bashls = {
      cmd = { 'bash-language-server', 'start' },
      root_markers = { '.git' },
      settings = {
        bashIde = {
          globPattern = '*@(.sh|.inc|.bash|.command)',
        },
      },
    },
  },

  formatter = 'shfmt',

  mason = { 'bash-language-server', 'shfmt' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
