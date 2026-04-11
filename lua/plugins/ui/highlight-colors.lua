-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'brenoprata10/nvim-highlight-colors',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    render = 'virtual', -- render as virtual text (not background)
    virtual_symbol = '', -- colored circle
    virtual_symbol_position = 'eow', -- end of word
    virtual_symbol_prefix = ' ', -- space before symbol
    virtual_symbol_suffix = '', -- space after symbol
    enable_named_colors = true, -- recognize CSS named colors
    enable_tailwind = true, -- enable tailwind class detection
  },
}
