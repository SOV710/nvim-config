-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'csv', 'tsv' },
  treesitter = { 'csv' },

  -- no LSP, no formatter, no linter

  plugins = {
    {
      'cameron-wags/rainbow_csv.nvim',
      ft = { 'csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon' },
      cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim',
      },
      opts = {},
    },
  },
}
