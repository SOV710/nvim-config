-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  {
    '<leader>ua',
    function()
      local rainbow = require 'rainbow-delimiters'
      rainbow.toggle(0)
      local state = rainbow.is_enabled(0) and 'enabled' or 'disabled'
      vim.notify('Rainbow delimiters ' .. state, vim.log.levels.INFO, { title = 'Rainbow Delimiters' })
    end,
    desc = 'Toggle rainbow delimiters',
  },
}
