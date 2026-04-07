return {
  'echasnovski/mini.surround',
  version = '*',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    custom_surroundings = {
      b = {
        input = { 'Box::new%(().-()%)' },
        output = { left = 'Box::new(', right = ')' },
      },
    },
    mappings = {
      add = 'sa', -- add surrounding in normal/visual mode
      delete = 'sd', -- delete surrounding
      replace = 'sr', -- replace surrounding
      find = 'sf', -- find surrounding to the right
      find_left = 'sF', -- find surrounding to the left
      highlight = 'sh', -- highlight surrounding
      update_n_lines = 'sn', -- update `n_lines` option
      suffix_last = 'l', -- suffix for "prev" search (e.g. sdl, srl)
      suffix_next = 'n', -- suffix for "next" search (e.g. sdn, srn)
    },
    n_lines = 20, -- number of lines within which surrounding is searched
    respect_selection_type = false, -- respect visual mode type (char/line/block)
    search_method = 'cover', -- search method: "cover"|"cover_or_next"|"cover_or_prev"|"cover_or_nearest"|"next"|"prev"|"nearest"
    highlight_duration = 500, -- highlight duration in ms after add/delete/replace
    silent = false, -- suppress "no surrounding found" messages
  },
}
