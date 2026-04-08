return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPost', -- attach to buffers as they open
  keys = require 'keymaps.git.gitsigns',
  opts = {
    signs = {
      add = { text = '+' }, -- sign for added lines
      change = { text = '~' }, -- sign for changed lines
      delete = { text = '_' }, -- sign for deleted lines
      topdelete = { text = '‾' }, -- sign for top-deleted lines
      changedelete = { text = '~' }, -- sign for changed+deleted lines
      untracked = { text = '┆' }, -- sign for untracked files
    },
    signs_staged = {
      add = { text = '+' }, -- staged add
      change = { text = '~' }, -- staged change
      delete = { text = '_' }, -- staged delete
      topdelete = { text = '‾' }, -- staged topdelete
      changedelete = { text = '~' }, -- staged changedelete
      untracked = { text = '┆' }, -- staged untracked
    },
    signs_staged_enable = true, -- show staged signs in sign column
    signcolumn = true, -- show signs in the sign column
    numhl = false, -- highlight line numbers
    linehl = false, -- highlight the whole line
    word_diff = false, -- intra-line word diff highlighting
    watch_gitdir = {
      follow_files = true, -- watch file renames
    },
    auto_attach = true, -- auto-attach to buffers
    attach_to_untracked = false, -- also attach to untracked files
    current_line_blame = false, -- virtual text blame on cursor line
    current_line_blame_opts = {
      virt_text = true, -- show blame as virtual text
      virt_text_pos = 'eol', -- position: 'eol'|'overlay'|'right_align'
      delay = 1000, -- ms before blame appears
      ignore_whitespace = false, -- ignore whitespace changes in blame
      virt_text_priority = 100, -- virtual text priority
      use_focus = true, -- only show on focused window
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6, -- sign column priority
    update_debounce = 100, -- ms debounce for updates
    max_file_length = 40000, -- disable for files longer than this
    preview_config = {
      style = 'minimal', -- float style
      relative = 'cursor', -- relative to cursor
      row = 0, -- float row offset
      col = 1, -- float col offset
    },
  },
}
