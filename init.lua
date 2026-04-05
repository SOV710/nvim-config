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
    require 'plugins.snacks',

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

-- Ensure mason bin is in PATH before enabling LSP servers
vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin:' .. vim.env.PATH

-- Enable LSP & per-language options (after lazy.nvim has set up rtp)
language.enable()

require 'core.autocmds'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
