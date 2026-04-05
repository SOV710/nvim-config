return {
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  treesitter = { 'go', 'gomod', 'gosum', 'gowork', 'gotmpl' },

  lsp = {
    gopls = {
      cmd = { 'gopls' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      settings = {
        gopls = {
          gofumpt = true,
          staticcheck = true,
          completeUnimported = true,
          usePlaceholders = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          directoryFilters = {
            '-.git',
            '-.vscode',
            '-.idea',
            '-node_modules',
          },
          semanticTokens = true,
        },
      },
    },
  },

  -- formatter: not set — gopls integrates gofumpt via the gofumpt = true setting
  -- linter: golangci-lint as external linter (aggregates dozens of linters)
  -- IMPORTANT: the nvim-lint linter name is "golangcilint" (no hyphens, no underscores)
  linter = 'golangcilint',

  dap = {
    adapter = {
      delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
      },
    },
    configurations = {
      go = {
        {
          name = 'Launch file',
          type = 'delve',
          request = 'launch',
          program = '${file}',
        },
        {
          name = 'Launch package',
          type = 'delve',
          request = 'launch',
          program = './${relativeFileDirname}',
        },
        {
          name = 'Launch test',
          type = 'delve',
          request = 'test',
          program = './${relativeFileDirname}',
        },
        {
          name = 'Attach',
          type = 'delve',
          request = 'attach',
          mode = 'local',
          processId = function()
            return require('dap.utils').pick_process()
          end,
        },
      },
    },
  },

  mason = { 'gopls', 'golangci-lint', 'delve' },

  options = {
    tabstop = 4,
    shiftwidth = 4,
    expandtab = false, -- Go uses tabs, not spaces
  },
}
