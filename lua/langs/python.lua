return {
  treesitter = { 'python' },

  lsp = {
    ruff = {
      cmd = { 'ruff', 'server' },
      root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
      init_options = {
        settings = {
          lineLength = 88,
          lint = {
            select = { 'E', 'F', 'W', 'I', 'N', 'UP' },
          },
        },
      },
    },
    ty = {
      cmd = { 'ty', 'server' },
      root_markers = { 'pyproject.toml', '.git' },
    },
  },

  -- formatter: not set — ruff LSP handles formatting
  -- linter: not set — ruff LSP handles linting

  dap = {
    adapter = {
      debugpy = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
        args = { '-m', 'debugpy.adapter' },
      },
    },
    configurations = {
      python = {
        {
          name = 'Launch file',
          type = 'debugpy',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
        },
        {
          name = 'Launch with arguments',
          type = 'debugpy',
          request = 'launch',
          program = '${file}',
          args = function()
            local input = vim.fn.input 'Arguments: '
            return vim.split(input, ' ', { trimempty = true })
          end,
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
        },
      },
    },
  },

  mason = { 'ruff', 'debugpy' },
  -- NOTE: ty is NOT in mason — install manually: uv tool install ty

  options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
  },
}
