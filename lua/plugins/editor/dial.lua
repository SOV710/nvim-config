return {
  'monaqa/dial.nvim',
  keys = require 'keymaps.editor.dial',
  config = function()
    local augend = require 'dial.augend'

    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal, -- decimal integers
        augend.integer.alias.hex, -- hex integers (0x...)
        augend.integer.alias.octal, -- octal integers (0o...)
        augend.integer.alias.binary, -- binary integers (0b...)

        augend.date.alias['%Y/%m/%d'], -- date: 2024/01/15
        augend.date.alias['%Y-%m-%d'], -- date: 2024-01-15
        augend.date.alias['%m/%d'], -- date: 01/15
        augend.date.alias['%H:%M'], -- time: 14:30

        augend.constant.alias.bool, -- true/false

        augend.constant.new { -- logical operators
          elements = { '&&', '||' },
          word = false,
          cyclic = true,
        },
        augend.constant.new { -- equality operators
          elements = { '===', '!==' },
          word = false,
          cyclic = true,
        },
        augend.constant.new { -- yes/no
          elements = { 'yes', 'no' },
          word = true,
          cyclic = true,
        },
        augend.constant.new { -- on/off
          elements = { 'on', 'off' },
          word = true,
          cyclic = true,
        },
        augend.constant.new { -- enable/disable
          elements = { 'enable', 'disable' },
          word = true,
          cyclic = true,
        },
        augend.semver.alias.semver, -- semantic versioning (1.2.3)
        augend.hexcolor.new { case = 'lower' }, -- hex colors (#ff0000)
      },

      typescript = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.constant.new {
          elements = { '===', '!==' },
          word = false,
          cyclic = true,
        },
        augend.constant.new {
          elements = { 'const', 'let' },
          word = true,
          cyclic = true,
        },
        augend.semver.alias.semver,
      },

      lua = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.constant.new {
          elements = { 'true', 'false', 'nil' },
          word = true,
          cyclic = true,
        },
      },
    }

    -- Apply filetype-specific groups
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      callback = function()
        vim.b.dials_augends = 'typescript'
      end,
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'lua',
      callback = function()
        vim.b.dials_augends = 'lua'
      end,
    })
  end,
}
