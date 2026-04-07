return {
  'andymass/vim-matchup',
  init = function()
    -- modify your configuration vars here
    vim.g.matchup_treesitter_stopline = 1000

    -- Don't block heirline plz
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }

    -- or call the setup function provided as a helper. It defines the
    -- configuration vars for you
    require('match-up').setup {
      treesitter = {
        stopline = 1000,
      },
    }
  end,
  -- or use the `opts` mechanism built into `lazy.nvim`. It calls
  -- `require('match-up').setup` under the hood
  opts = {
    treesitter = {
      stopline = 1000,
    },
  },
}
