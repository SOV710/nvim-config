return {
  'gbprod/yanky.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'kkharji/sqlite.lua' },
  keys = require 'core.keymaps.editor.yanky',
  opts = {
    ring = {
      history_length = 200,
      storage = 'sqlite', -- storage backend: "shada"|"sqlite"|"memory"
      storage_path = vim.fn.stdpath 'state' .. '/yanky/yanky.db',
      sync_with_numbered_registers = true, -- sync ring with vim numbered registers (1-9)
      cancel_event = 'update', -- event that cancels ring cycling: "update"|"move"
      ignore_registers = { '_' }, -- registers to ignore
    },
    system_clipboard = {
      sync_with_ring = true, -- sync system clipboard with yank ring
      clipboard_register = '+', -- clipboard register to use (nil = auto)
    },
    highlight = {
      on_put = true, -- highlight on put
      on_yank = true, -- highlight on yank
      timer = 500, -- highlight duration in ms
    },
    preserve_cursor_position = {
      enabled = true, -- preserve cursor position after yank
    },
  },
}
