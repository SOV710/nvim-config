return {
  filetypes = { 'c', 'cpp' },
  treesitter = { 'c', 'cpp' },

  lsp = {
    clangd = {
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
      },
      root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
    },
  },

  -- formatter: not set — clangd provides formatting via LSP
  -- linter: not set — clang-tidy runs through clangd's --clang-tidy flag

  dap = {
    adapter = {
      codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      },
    },
    configurations = {
      c = {
        {
          name = 'Launch (C)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      },
      cpp = {
        {
          name = 'Launch (C++)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      },
    },
  },

  mason = { 'clangd', 'codelldb' },

  plugins = {
    { 'p00f/clangd_extensions.nvim', lazy = true },
  },
}
