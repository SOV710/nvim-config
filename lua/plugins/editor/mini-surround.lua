-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local code_fence = '```'

local function code_fence_output()
  local is_linewise = vim.fn.visualmode() == 'V'
  if vim.v.operator == 'g@' then
    local first_mark = vim.fn.getpos "'["
    local second_mark = vim.fn.getpos "']"
    is_linewise = first_mark[3] == 1 and second_mark[3] == 1
  end

  if is_linewise then
    return { left = code_fence, right = code_fence }
  end

  return { left = code_fence .. '\n', right = '\n' .. code_fence }
end

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
      q = {
        input = { '```()\n.-\n()```' },
        output = code_fence_output,
      },
    },
    highlight_duration = 1000, -- highlight duration in ms after add/delete/replace

    mappings = {
      add = 'gaa', -- add surrounding in normal/visual mode
      delete = 'gad', -- delete surrounding
      replace = 'gar', -- replace surrounding
      find = 'gaf', -- find surrounding to the right
      find_left = 'gaF', -- find surrounding to the left
      highlight = 'gah', -- highlight surrounding
      suffix_last = 'l', -- suffix for "prev" search (e.g. sdl, srl)
      suffix_next = 'n', -- suffix for "next" search (e.g. sdn, srn)
    },
    n_lines = 100, -- number of lines within which surrounding is searched
    respect_selection_type = true, -- respect visual mode type (char/line/block)
    search_method = 'cover_or_next', -- search method: "cover"|"cover_or_next"|"cover_or_prev"|"cover_or_nearest"|"next"|"prev"|"nearest"
    silent = false, -- suppress "no surrounding found" messages
  },
}
