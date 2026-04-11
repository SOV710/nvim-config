-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    style = 'night',
    transparent = true,
    styles = {
      sidebars = 'transparent',
      floats = 'transparent',
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
