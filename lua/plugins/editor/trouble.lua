return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>nS',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Toggle workspace level trouble.nvim',
    },
    {
      '<leader>ns',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Toggle buffer level trouble.nvim',
    },
  },
}
