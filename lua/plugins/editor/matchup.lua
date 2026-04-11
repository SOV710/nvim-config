-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'andymass/vim-matchup',
  event = 'LazyFile',
  opts = {
    enabled = 1,
    matchparen = {
      enabled = 1,
      offscreen = { method = 'popup' },
      deferred = 1,
      deferred_show_delay = 50,
      deferred_hide_delay = 700,
      timeout = 300,
      insert_timeout = 60,

      hi_surround_always = 0,
      singleton = 0,
    },
    motion = { enabled = 1 },
    text_obj = { enabled = 0 },
    treesitter = {
      matchparen = {
        stopline = 400,
      },
      stopline = 1000,
    },
  },
}
