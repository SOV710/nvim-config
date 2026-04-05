return {
  -- NOTE: `m` overrides native mark — intentional (use ' for marks via which-key)
  {
    'm',
    function()
      require('grapple').toggle()
      vim.api.nvim_exec_autocmds('User', { pattern = 'GrappleToggled' })
    end,
    desc = 'Grapple toggle tag',
  },
  {
    "'",
    function()
      require('grapple').toggle_tags()
    end,
    desc = 'Grapple tags menu',
  },
  {
    '<leader>1',
    function()
      require('grapple').select { index = 1 }
    end,
    desc = 'Grapple tag 1',
  },
  {
    '<leader>2',
    function()
      require('grapple').select { index = 2 }
    end,
    desc = 'Grapple tag 2',
  },
  {
    '<leader>3',
    function()
      require('grapple').select { index = 3 }
    end,
    desc = 'Grapple tag 3',
  },
  {
    '<leader>4',
    function()
      require('grapple').select { index = 4 }
    end,
    desc = 'Grapple tag 4',
  },
}
