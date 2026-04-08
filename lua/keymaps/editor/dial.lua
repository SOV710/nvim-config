return {
  -- NOTE: `+`/`-` override native +/- (line movement) — intentional
  {
    '+',
    function()
      require('dial.map').manipulate('increment', 'normal')
    end,
    desc = 'Increment',
  },
  {
    '-',
    function()
      require('dial.map').manipulate('decrement', 'normal')
    end,
    desc = 'Decrement',
  },
  {
    '+',
    function()
      require('dial.map').manipulate('increment', 'visual')
    end,
    desc = 'Increment',
    mode = 'v',
  },
  {
    '-',
    function()
      require('dial.map').manipulate('decrement', 'visual')
    end,
    desc = 'Decrement',
    mode = 'v',
  },
  {
    'g+',
    function()
      require('dial.map').manipulate('increment', 'gvisual')
    end,
    desc = 'Increment sequential',
    mode = 'v',
  },
  {
    'g-',
    function()
      require('dial.map').manipulate('decrement', 'gvisual')
    end,
    desc = 'Decrement sequential',
    mode = 'v',
  },
}
