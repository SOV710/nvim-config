return {
  'cbochs/grapple.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = require 'keymaps.editor.grapple',
  opts = {
    scope = 'git', -- tag scope: "git"|"git_branch"|"cwd"|"global"|"static"|"lsp"
    icons = true, -- show icons in the tags menu
    quick_select = '1234567890', -- keys for quick-selecting tags in the menu
    status = true, -- show grapple statusline component
    style = 'relative', -- path display style: "relative"|"basename"|"unique"
    prune = 'cwd', -- prune missing files: "cwd"|false

    win_opts = {
      width = 80, -- tags menu window width
      height = 12, -- tags menu window height
      border = 'rounded', -- border style: "none"|"single"|"double"|"rounded"
      footer = '', -- footer text
      title_pos = 'center', -- title position: "left"|"center"|"right"
    },
  },

  config = function(_, opts)
    require('grapple').setup(opts)

    -- Redraw tabline when tags change so heirline grapple indicator updates
    vim.api.nvim_create_autocmd('User', {
      pattern = 'GrappleToggled',
      callback = function()
        vim.cmd.redrawtabline()
      end,
    })
  end,
}
