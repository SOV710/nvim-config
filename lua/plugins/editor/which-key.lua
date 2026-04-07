return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'classic',
    delay = function(ctx)
      return ctx.plugin and 0 or 150
    end,

    plugins = {
      marks = true, -- show marks on ' and `
      registers = true, -- show registers on " and <C-r>
      spelling = {
        enabled = true, -- show spelling suggestions on z=
        suggestions = 20, -- max suggestions to show
      },
    },

    win = {
      border = 'rounded', -- popup border style
      padding = { 1, 2 }, -- { top/bottom, left/right } padding
    },

    layout = {
      spacing = 3, -- gap between columns
    },

    icons = {
      breadcrumb = '', -- separator in command line
      separator = '', -- separator between key and description
      group = ' ', -- prepended to group labels
      keys = {
        Up = ' ',
        Down = ' ',
        Left = ' ',
        Right = ' ',
        C = '󰘴 ',
        M = '󰘵 ',
        D = '󰘳 ',
        S = '󰘶 ',
        CR = '󰌑 ',
        Esc = '󱊷 ',
        ScrollWheelDown = '󱕐 ',
        ScrollWheelUp = '󱕑 ',
        NL = '󰌑 ',
        BS = '󰁮',
        Space = '󱁐 ',
        Tab = '󰌒 ',
        F1 = '󱊫',
        F2 = '󱊬',
        F3 = '󱊭',
        F4 = '󱊮',
        F5 = '󱊯',
        F6 = '󱊰',
        F7 = '󱊱',
        F8 = '󱊲',
        F9 = '󱊳',
        F10 = '󱊴',
        F11 = '󱊵',
        F12 = '󱊶',
      },
    },
  },

  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)
    wk.add(require 'core.keymaps.which-key')
  end,
}
