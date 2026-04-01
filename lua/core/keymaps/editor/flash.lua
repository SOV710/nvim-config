return {
  { 's', function() require('flash').jump() end, desc = 'Flash jump', mode = { 'n', 'x', 'o' } },
  { 'S', function() require('flash').treesitter() end, desc = 'Flash treesitter', mode = { 'n', 'x', 'o' } },
  { 'r', function() require('flash').remote() end, desc = 'Remote flash', mode = 'o' },
  { '<c-s>', function() require('flash').toggle() end, desc = 'Toggle flash search', mode = 'c' },
}
