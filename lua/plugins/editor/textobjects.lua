-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  event = { 'BufReadPost', 'BufNewFile' },
  keys = require 'keymaps.editor.textobjects',
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'v',
          ['@class.outer'] = 'V',
        },
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    }
  end,
}
