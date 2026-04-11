-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = { 'toml' },

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
