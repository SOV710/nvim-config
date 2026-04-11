-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>nS',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Toggle workspace level trouble.nvim',
    },
    {
      '<leader>ns',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Toggle buffer level trouble.nvim',
    },
  },
}
