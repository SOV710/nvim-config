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
