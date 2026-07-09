-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local function open_native_undotree()
  vim.cmd.packadd 'nvim.undotree'
  require('undotree').open {
    command = 'topleft 30vnew',
  }
end

return {
  -- NOTE: changed from `<leader>u` to `<leader>U` to avoid conflict with UI Toggle group
  {
    '<leader>us',
    open_native_undotree,
    desc = 'Toggle undotree',
  },
}
