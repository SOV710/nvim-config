return {
  -- NOTE: changed from `<leader>sr` to `<leader>S` to avoid conflict with Resume picker
  {
    '<leader>S',
    function()
      require('grug-far').open()
    end,
    desc = 'Search and replace',
  },
  {
    '<leader>S',
    function()
      require('grug-far').with_visual_selection()
    end,
    desc = 'Search selection',
    mode = 'v',
  },
}
