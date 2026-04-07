local _search = { icon = '󰍉 ', color = 'blue' }
local _lsp = { icon = '󰆍 ', color = 'cyan' }
local _debug = { icon = '󰃤', color = 'red' }

return {
  -- Buffer-local Cheatsheet
  {
    '<leader>?',
    function()
      require('which-key').show { global = false }
    end,
    desc = 'Buffer Local Keymaps',
  },

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
  { '<leader>a', group = 'AI' },
  { '<leader>q', group = 'Quit' },
  { '<leader>t', group = 'Terminal' },
  { '<leader>u', group = 'UI Toggle' },
  { '<leader>w', group = 'Window' },
  { '<leader><tab>', group = 'Tab' },
}
