return {
  { 'y', '<Plug>(YankyYank)', desc = 'Yank', mode = { 'n', 'x' } },
  { 'p', '<Plug>(YankyPutAfter)', desc = 'Put after', mode = { 'n', 'x' } },
  { 'P', '<Plug>(YankyPutBefore)', desc = 'Put before', mode = { 'n', 'x' } },
  { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Yank ring prev' },
  { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Yank ring next' },
  { '<leader>y', function() Snacks.picker.yanky() end, desc = 'Yank history' },
}
