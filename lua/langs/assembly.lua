-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'asm', 'nasm', 'masm', 'vmasm' },
  treesitter = { 'asm' },

  lsp = {
    asm_lsp = {
      cmd = { 'asm-lsp' },
      root_markers = { '.asm-lsp.toml', '.git' },
    },
  },

  mason = { 'asm-lsp' },
}
