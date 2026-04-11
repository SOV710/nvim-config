-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'jiaoshijie/undotree',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = require 'keymaps.editor.undotree',
  opts = {
    float_diff = true, -- show diff in floating window
    position = 'left', -- window position: "left"|"right"
    ignore_filetype = { -- filetypes where undotree is disabled
      'oil',
      'snacks_dashboard',
      'snacks_picker_input',
      'gitcommit',
      'help',
      'undotree',
      'undotreeDiff',
      'qf',
      'TelescopePrompt',
      'spectre_panel',
      'tsplayground',
    },
    window = {
      width = 0.25,
      height = 0.25, -- this field dont's work when 'float_diff = false'
      border = 'rounded',
      winblend = 0, -- window transparency (0 = opaque)
    },
    parser = 'compact', --- @type 'compact' | 'legacy'
    keymaps = {
      ['j'] = 'move_next', -- move to next undo state
      ['k'] = 'move_prev', -- move to previous undo state
      ['gj'] = 'move2parent', -- move to parent node
      ['J'] = 'move_change_next', -- move to next change
      ['K'] = 'move_change_prev', -- move to previous change
      ['<cr>'] = 'action_enter', -- apply selected undo state
      ['p'] = 'enter_diffbuf', -- enter diff buffer
      ['q'] = 'quit', -- close undotree
      ['S'] = 'update_undotree_view',
    },
  },
}
