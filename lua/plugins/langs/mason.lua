return {
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    opts = {
      python = {
        venv = 'uv', -- "uv", "venv" or "virtualenv",
        installer = 'uv', -- "uv" (default if venv == "uv") or "pip" (default if venv == "venv" or "virtualenv")
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate' },
    event = 'VeryLazy',
    opts = function()
      return {
        ensure_installed = require('core.language').mason,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      }
    end,
    config = function(_, opts)
      require('mason-tool-installer').setup(opts)
      require('mason-tool-installer').run_on_start()
    end,
  },
}
