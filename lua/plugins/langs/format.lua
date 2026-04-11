-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = function()
    return {
      notify_on_error = true,
      formatters_by_ft = require('core.language').formatters,
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      },
    }
  end,
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true }
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
}
