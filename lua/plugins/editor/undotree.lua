return {
  'jiaoshijie/undotree',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = require 'keymaps.editor.undotree',
  opts = {
    float_diff = true, -- show diff in floating window
    layout = 'left_bottom', -- layout: "left_bottom"|"left_left_bottom"
    position = 'left', -- window position: "left"|"right"
    ignore_filetype = { -- filetypes where undotree is disabled
      'undotree',
      'undotreeDiff',
      'qf',
      'TelescopePrompt',
      'spectre_panel',
      'tsplayground',
    },
    window = {
      winblend = 0, -- window transparency (0 = opaque)
    },
    keymaps = {
      ['j'] = 'move_next', -- move to next undo state
      ['k'] = 'move_prev', -- move to previous undo state
      ['gj'] = 'move2parent', -- move to parent node
      ['J'] = 'move_change_next', -- move to next change
      ['K'] = 'move_change_prev', -- move to previous change
      ['<cr>'] = 'action_enter', -- apply selected undo state
      ['p'] = 'enter_diffbuf', -- enter diff buffer
      ['q'] = 'quit', -- close undotree
    },
  },
}
