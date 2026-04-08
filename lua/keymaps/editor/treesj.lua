return {
  {
    'gS',
    function()
      require('treesj').toggle()
    end,
    desc = 'Toggle split/join',
  },
  {
    'gJ',
    function()
      require('treesj').join()
    end,
    desc = 'Join block',
  },
}
