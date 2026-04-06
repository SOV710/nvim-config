return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    transparent = true,
    styles = {
      sidebars = 'transparent',
      floats = 'transparent',
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
