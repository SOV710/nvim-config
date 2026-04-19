-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- TypeScript/JavaScript — LSP via tsgo (built from source) + biome via mason.
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     tsgo                TypeScript native LSP (Go port, replaces tsserver)
---       install:          git clone --recurse-submodules https://github.com/microsoft/typescript-go
---                         cd typescript-go && go build ./cmd/tsgo
---                         # place resulting `tsgo` binary in $PATH
---       verify:           tsgo --version
---
--- Notes:
---   - tsgo is the native-Go TypeScript compiler/LSP under active development.
---     It is not yet published to mason/npm; source build is the only path.
---   - Requires Go toolchain (`emerge dev-lang/go`) to build.
---   - biome (linting + formatting) IS in mason and managed automatically.
---   - js-debug-adapter (DAP) IS in mason and managed automatically.

return {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  treesitter = {
    languages = {
      javascript = {
        filetypes = { 'javascript', 'javascriptreact', 'ecma', 'jsx' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-javascript',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'javascript' },
          },
        },
      },
      typescript = {
        filetypes = { 'typescript', 'ts' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-typescript',
            location = 'typescript',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'typescript' },
          },
        },
      },
      tsx = {
        filetypes = { 'typescriptreact', 'typescript.tsx' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-typescript',
            location = 'tsx',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'tsx' },
          },
        },
      },
      jsdoc = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-jsdoc',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'jsdoc' },
          },
        },
      },
    },
  },

  external_deps = {
    {
      cmd = 'tsgo',
      required = true,
      install = 'git clone --recurse-submodules https://github.com/microsoft/typescript-go && cd typescript-go && go build ./cmd/tsgo',
      note = 'place built binary in $PATH; requires Go toolchain',
    },
  },

  lsp = {
    -- tsgo: type checking, completions, go-to-definition, refactoring
    -- (see top-of-file external deps block for installation)
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
