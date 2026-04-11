-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = false, -- custom parser installed by plugin, not in nvim-treesitter registry
  plugins = {
    { 'bezhermoso/tree-sitter-ghostty', ft = 'ghostty', build = 'make nvim_install' },
  },
}
