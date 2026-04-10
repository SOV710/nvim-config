--- Python — LSP via mason (ruff) + ty (external uv tool).
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     ty                  Python type checker LSP (uv-managed)
---       install:          uv tool install ty
---       verify:           ty --version
---
--- Notes:
---   - ty is a new static type checker LSP distributed via uv, not mason.
---     Requires `uv` (`pip install uv` or `emerge dev-python/uv`).
---   - ruff (LSP for linting/formatting) IS in mason and managed automatically.
---   - debugpy (DAP) IS in mason and managed automatically.

return {
  treesitter = { 'python' },

  external_deps = {
    {
      cmd = 'ty',
      required = true,
      install = 'uv tool install ty',
      note = 'requires uv (pip install uv or emerge dev-python/uv)',
    },
  },

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
  -- NOTE: ty is NOT in mason (see top-of-file external deps block)

  options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
  },
}
