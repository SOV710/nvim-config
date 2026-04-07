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
      add = 'gaa', -- add surrounding in normal/visual mode
      delete = 'gad', -- delete surrounding
      replace = 'gar', -- replace surrounding
      find = 'gaf', -- find surrounding to the right
      find_left = 'gaF', -- find surrounding to the left
      highlight = 'gah', -- highlight surrounding
      update_n_lines = 'gan', -- update `n_lines` option
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
