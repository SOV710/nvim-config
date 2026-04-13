-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'mvllow/modes.nvim',
  event = 'VeryLazy',
  opts = {
    colors = {
      bg = '',
      insert = '#c3e88d', -- green (Tokyo Night green)
      replace = '#ff757f', -- red
      visual = '#c099ff', -- purple
    },
    line_opacity = 0.30, -- subtle background tint
  },
}
