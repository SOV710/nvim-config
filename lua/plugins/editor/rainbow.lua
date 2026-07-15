-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local highlight_sources = {
  RainbowDelimiterRed = 'DiagnosticError',
  RainbowDelimiterYellow = 'DiagnosticWarn',
  RainbowDelimiterBlue = 'Function',
  RainbowDelimiterOrange = 'Constant',
  RainbowDelimiterGreen = 'String',
  RainbowDelimiterViolet = 'Statement',
  RainbowDelimiterCyan = 'Type',
}

local highlight_order = {
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}

local function apply_highlights()
  for group, source in pairs(highlight_sources) do
    local highlight = vim.api.nvim_get_hl(0, { name = source, link = false })
    if highlight.fg then
      vim.api.nvim_set_hl(0, group, { fg = highlight.fg })
    end
  end
end

return {
  'HiPhish/rainbow-delimiters.nvim',
  lazy = false,
  keys = require 'keymaps.editor.rainbow',
  init = function()
    ---@type rainbow_delimiters.config
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
      },
      query = {
        [''] = 'rainbow-delimiters',
        javascript = 'rainbow-delimiters',
        tsx = 'rainbow-parens',
      },
      highlight = highlight_order,
      log = {
        level = vim.log.levels.WARN,
      },
    }
  end,
  config = function()
    apply_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('sov710.rainbow_delimiters', { clear = true }),
      callback = apply_highlights,
    })
  end,
}
