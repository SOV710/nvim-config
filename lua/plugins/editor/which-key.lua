return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 0,                          -- ms before popup shows (0 = instant)

    plugins = {
      marks = true,                     -- show marks on ' and `
      registers = true,                 -- show registers on " and <C-r>
      spelling = {
        enabled = true,                 -- show spelling suggestions on z=
        suggestions = 20,               -- max suggestions to show
      },
    },

    win = {
      border = 'rounded',              -- popup border style
      padding = { 1, 2 },              -- { top/bottom, left/right } padding
    },

    layout = {
      spacing = 3,                      -- gap between columns
      align = 'left',                   -- column alignment: "left"|"center"|"right"
    },

    icons = {
      breadcrumb = '»',               -- separator in command line
      separator = '➜',                -- separator between key and description
      group = '+ ',                     -- prepended to group labels
      keys = {
        Up = ' ',
        Down = ' ',
        Left = ' ',
        Right = ' ',
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
    local wk = require('which-key')
    wk.setup(opts)

    local _search = { icon = '', color = 'blue' }
    local _lsp = { icon = '', color = 'cyan' }
    local _debug = { icon = '󰃤', color = 'red' }

    wk.add({
      -- ── Search (Snacks.picker) ────────────────────────────────────
      { '<leader>s', group = 'Search', icon = _search },

      -- ── LSP ───────────────────────────────────────────────────────
      { '<leader>l', group = 'LSP', icon = _lsp },

      -- ── Debug ─────────────────────────────────────────────────────
      { '<leader>d', group = 'Debug', icon = _debug },

      -- ── Other groups ──────────────────────────────────────────────
      { '<leader>b', group = 'Buffer' },
      { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
      { '<leader>f', group = 'File' },
      { '<leader>g', group = 'Git' },
      { '<leader>h', group = 'Git Hunk', mode = { 'n', 'v' } },
      { '<leader>q', group = 'Quit' },
      { '<leader>t', group = 'Terminal' },
      { '<leader>u', group = 'UI Toggle' },
      { '<leader>w', group = 'Window' },
      { '<leader><tab>', group = 'Tab' },
    })
  end,
}
