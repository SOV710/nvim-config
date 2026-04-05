return {
  'folke/flash.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  keys = require 'core.keymaps.editor.flash',
  ---@type Flash.Config
  opts = {
    labels = 'asdfghjklqwertyuiopzxcvbnm', -- characters used for jump labels
    search = {
      multi_window = true, -- search across all open windows
      forward = true, -- search direction: forward from cursor
      wrap = true, -- wrap around the buffer
      mode = 'exact', -- match mode: "exact"|"search"|"fuzzy"|"fuzzy_first"
      incremental = false, -- show results incrementally while typing
      exclude = { -- filetypes/buftypes excluded from flash
        'notify',
        'cmp_menu',
        'noice',
        'flash_prompt',
        function(win)
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
    },
    jump = {
      jumplist = true, -- save jump position to jumplist
      pos = 'start', -- position in match: "start"|"end"|"range"
      history = false, -- add pattern to search history
      register = false, -- add pattern to search register
      nohlsearch = true, -- clear highlight after jump
      autojump = false, -- auto-jump when there is only one match
    },
    label = {
      uppercase = true, -- allow uppercase labels
      exclude = '', -- characters to exclude from labels
      current = true, -- include current position as label
      after = true, -- show labels after match
      before = false, -- show labels before match
      style = 'overlay', -- label style: "overlay"|"right_align"|"inline"
      reuse = 'lowercase', -- reuse labels: "lowercase"|"all"|"none"
      rainbow = {
        enabled = false, -- rainbow-colored labels
        shade = 5, -- number of rainbow shades
      },
    },
    modes = {
      search = {
        enabled = true, -- integrate flash with / and ? search
      },
      char = {
        enabled = true, -- integrate flash with f, F, t, T
        autohide = false, -- auto-hide labels after jump in char mode
        jump_labels = true, -- show jump labels for char motions
        multi_line = true, -- allow char motions across lines
      },
      treesitter = {
        labels = 'asdfghjklqwertyuiopzxcvbnm',
        jump = { pos = 'range', autojump = true },
        label = { before = true, after = true, style = 'inline' },
        highlight = {
          backdrop = false, -- dim background for treesitter mode
          matches = false, -- highlight search matches in treesitter mode
        },
      },
    },
    prompt = {
      enabled = true, -- show input prompt for flash
      prefix = { { '⚡', 'FlashPromptIcon' } },
    },
  },
}
