return {
  'folke/snacks.nvim',
  opts = {
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 150 }, -- smooth but not slow
        easing = 'linear', -- linear interpolation
      },
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= 'terminal'
      end,
    },
  },
}
