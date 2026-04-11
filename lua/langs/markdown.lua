-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = { 'markdown', 'markdown_inline' },

  lsp = {}, -- remove marksman, I don't need an LSP to teach me how to write Markdown

  -- linter: markdownlint-cli2
  -- nvim-lint name: "markdownlint-cli2"
  linter = 'markdownlint-cli2',

  -- formatter: not set — markdown formatting is opinionated
  -- markdownlint --fix can handle basic formatting if needed

  mason = { 'markdownlint-cli2' },

  plugins = {
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      ft = { 'markdown', 'norg', 'org' },
      opts = {
        heading = {
          enabled = true,
          sign = true,
          icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        },
        code = {
          enabled = true,
          sign = true,
          style = 'full',
          left_pad = 1,
          right_pad = 1,
          language_pad = 1,
        },
        checkbox = {
          enabled = true,
          unchecked = { icon = '󰄱 ' },
          checked = { icon = '󰄵 ' },
        },
        bullet = {
          enabled = true,
          icons = { '●', '○', '◆', '◇' },
        },
      },
    },
  },
}
