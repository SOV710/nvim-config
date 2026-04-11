-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = require('core.language').linters

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        if vim.bo.buftype == '' then
          local names = lint.linters_by_ft[vim.bo.filetype]
          if names then
            names = vim.tbl_filter(function(name)
              local linter = lint.linters[name]
              if not linter then
                return false
              end
              return vim.fn.executable(linter.cmd or name) == 1
            end, names)
            if #names > 0 then
              lint.try_lint(names)
            end
          end
        end
      end,
    })
  end,
}
