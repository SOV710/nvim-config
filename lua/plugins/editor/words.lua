return {
  'folke/snacks.nvim',
  opts = {
    words = {
      enabled = true,
      debounce = 100, -- ms to wait before highlighting
      notify_jump = false, -- don't show notification when jumping
      notify_end = true, -- notify when reaching last/first reference
    },
  },
  keys = {
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev reference',
      mode = { 'n', 't' },
    },
  },
}
