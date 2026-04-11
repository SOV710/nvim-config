-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  -- NOTE: changed from `<leader>u` to `<leader>U` to avoid conflict with UI Toggle group
  {
    '<leader>us',
    function()
      require('undotree').toggle()
    end,
    desc = 'Toggle undotree',
  },
}
