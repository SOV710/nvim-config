-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'csv', 'tsv' },
  treesitter = {
    languages = {
      csv = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/amaanq/tree-sitter-csv',
            location = 'csv',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'csv' },
          },
        },
      },
    },
  },

  -- no LSP, no formatter, no linter

  plugins = {
    -- {
    --   'cameron-wags/rainbow_csv.nvim',
    --   ft = { 'csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon' },
    --   cmd = {
    --     'RainbowDelim',
    --     'RainbowDelimSimple',
    --     'RainbowDelimQuoted',
    --     'RainbowMultiDelim',
    --   },
    --   opts = {},
    -- },
    {
      'hat0uma/csvview.nvim',
      opts = {
        parser = { comments = { '#', '//' } },
        keymaps = {
          -- Text objects for selecting fields
          textobject_field_inner = { 'if', mode = { 'o', 'x' } },
          textobject_field_outer = { 'af', mode = { 'o', 'x' } },
          -- Excel-like navigation:
          -- Use <Tab> and <S-Tab> to move horizontally between fields.
          -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
          -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
          jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
          jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
          jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
          jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
        },
      },
      cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    },
  },
}
