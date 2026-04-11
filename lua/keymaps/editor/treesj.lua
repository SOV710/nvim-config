-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  {
    '<leader>jf',
    function()
      require('treesj').toggle()
    end,
    desc = 'TreeSJ toggle',
  },
  {
    '<leader>jj',
    function()
      require('treesj').join()
    end,
    desc = 'TreeSJ join',
  },
  {
    '<leader>js',
    function()
      require('treesj').split()
    end,
    desc = 'TreeSJ split',
  },
}
