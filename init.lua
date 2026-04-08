require 'core.options'
require 'keymaps'

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

-- if you have nerd fonts
local have_nerd_font = true

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

  dev = {
    path = '~/proj',
    patterns = {},
    fallback = false,
  },

  ui = {
    size = {
      width = 0.85,
      height = 0.8,
    },
    border = 'rounded',
    backdrop = 60,
    title = ' SOV710 is Lazy󰒲 ',

    icons = have_nerd_font and {
      cmd = '󰞷 ',
      event = ' ',
      ft = '󱔘 ',
      debug = '󰃤 ',
    } or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },

    browser = (function()
      for _, cmd in ipairs { 'vivaldi', 'firefox', 'chromium', 'xdg-open', 'open' } do
        if vim.fn.executable(cmd) == 1 then
          return cmd
        end
      end
    end)(),

    diff = {
      cmd = 'diffview.nvim',
    },
  },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'netrwPlugin',
        'tohtml',
        'tutor',
        'matchit',
      },
    },
  },

  profiling = {
    -- Useful when :Lazy debug
    loader = false,
    -- Useful when :Lazy profile
    require = false,
  },
}
-- In Lazy UI
-- "<localleader>l" is open lazygit log
-- "<localleader>i" is inspect plugins
-- "<localleader>t" is open terminal in plugin dir

-- Ensure mason bin is in PATH before enabling LSP servers
vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin:' .. vim.env.PATH

-- Enable LSP & per-language options (after lazy.nvim has set up rtp)
language.enable()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
