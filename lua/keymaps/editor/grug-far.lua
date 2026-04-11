-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  -- NOTE: changed from `<leader>sr` to `<leader>S` to avoid conflict with Resume picker
  {
    '<leader>r',
    function()
      require('grug-far').open()
    end,
    desc = 'Search and replace',
  },
  {
    '<leader>r',
    function()
      require('grug-far').with_visual_selection()
    end,
    desc = 'Search selection',
    mode = 'v',
  },
}
