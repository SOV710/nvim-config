return {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  treesitter = { 'javascript', 'typescript', 'tsx', 'jsdoc' },

  lsp = {
    -- tsgo: type checking, completions, go-to-definition, refactoring
    -- NOT in mason — install from source: https://github.com/microsoft/typescript-go
    tsgo = {
      cmd = { 'tsgo', 'lsp' },
      root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
      settings = {
        typescript = {
          inlayHints = {
            parameterNames = { enabled = 'all' },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
          suggest = {
            autoImports = true,
            includeCompletionsForImportStatements = true,
            classMemberSnippets = { enabled = true },
            objectLiteralMethodSnippets = { enabled = true },
          },
          preferences = {
            importModuleSpecifierPreference = 'shortest',
            quoteStyle = 'auto',
          },
        },
      },
    },

    -- biome: linting diagnostics + formatting
    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
    },
  },

  formatter = 'biome',

  dap = {
    adapter = {
      ['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      },
    },
    configurations = {
      javascript = {
        {
          name = 'Launch file (Node)',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          name = 'Attach (Node)',
          type = 'pwa-node',
          request = 'attach',
          processId = function()
            return require('dap.utils').pick_process()
          end,
          cwd = '${workspaceFolder}',
        },
      },
      typescript = {
        {
          name = 'Launch file (Node)',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
          runtimeExecutable = 'tsx',
        },
      },
    },
  },

  mason = { 'biome', 'js-debug-adapter' },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
