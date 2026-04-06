return {
  'folke/snacks.nvim',
  opts = {
    statuscolumn = {
      enabled = true,
      left = { 'sign' }, -- left side: signs only
      right = { 'fold', 'git' }, -- right side: fold indicators, then git signs
      folds = {
        open = true, -- show icon for open folds too
        git_hl = false, -- don't colorize fold icons with git colors
      },
      git = {
        patterns = { 'GitSign', 'MiniDiffSign' }, -- sign name patterns to recognize as git
      },
      refresh = 50, -- refresh rate in ms
    },
  },
}
