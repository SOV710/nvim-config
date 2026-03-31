require 'core.options'
require 'core.keymaps'

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- custom "OpenFile" events
require('lazy.core.handler.event').mappings.LazyFile = {
  id = 'LazyFile',
  event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
}

-- The language system self-initializes on require:
-- it scans lua/langs/*.lua and aggregates everything.
local language = require 'core.language'

-- Lazy setup
require('lazy').setup {
  spec = {
    { import = 'plugins.ui' },
    { import = 'plugins.editor' },
    { import = 'plugins.langs' },
    { import = 'plugins.git' },
    { import = 'plugins.ai' },

    -- Inject language-specific plugins (rustaceanvim, crates.nvim, etc.)
    language.plugins,
  },

  install = { colorscheme = { 'tokyonight', 'habamax' } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  rocks = { enabled = false },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

vim.cmd.colorscheme 'tokyonight'

-- Enable LSP & per-language options (after lazy.nvim has set up rtp)
language.enable()

require 'core.autocmds'

-- require('lazy').setup({
--   'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
--   -- NOTE: Appearance
--   require 'plugins.dashboard',
--   require 'plugins.lualine',
--   require 'plugins.indent-line',
--   require 'plugins.todo-comments',
--   require 'plugins.themes.tokyonight',
--
--   -- NOTE: Editing Flow
--   require 'plugins.neo-tree',
--   require 'plugins.telescope',
--   require 'plugins.which-key',
--   require 'plugins.bufferline',
--   require 'plugins.toggleterm',
--
--   -- NOTE: Development Tools
--   require 'plugins.treesitter',
--   require 'plugins.lint',
--   require 'plugins.lsp',
--   require 'plugins.cmp',
--   require 'plugins.diagnostic',
--   require 'plugins.dap',
--   require 'plugins.conform',
--
--
--   -- NOTE: AI Tools
--   require 'plugins.avante',
--
--   -- NOTE: Version Control
--   require 'plugins.gitsigns',
--
--   -- NOTE: Utils
--   require 'plugins.mini',
-- }, {
--   ui = {
--     icons = vim.g.have_nerd_font and {} or {
--       cmd = '⌘',
--       config = '🛠',
--       event = '📅',
--       ft = '📂',
--       init = '⚙',
--       keys = '🗝',
--       plugin = '🔌',
--       runtime = '💻',
--       require = '🌙',
--       source = '📄',
--       start = '🚀',
--       task = '📌',
--       lazy = '💤 ',
--     },
--   },
-- })

-- NOTE: Language Config
require('nvim-treesitter.install').prefer_git = true
require 'lang.task'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
