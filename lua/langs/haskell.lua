--- Haskell — LSP + DAP via GHCup toolchain.
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     ghc, cabal          Haskell compiler and package manager
---       install:          curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
---                         ghcup install ghc recommended
---                         ghcup install cabal recommended
---       verify:           ghc --version && cabal --version
---
---     haskell-language-server  HLS — must match GHC version exactly
---       install:          ghcup install hls recommended
---       verify:           haskell-language-server-wrapper --version
---
---   Optional:
---     haskell-debug-adapter    DAP adapter (enables :DapContinue for Haskell)
---       install:          cabal install haskell-debug-adapter haskell-dap ghci-dap
---       verify:           haskell-debug-adapter --version
---
---     stack               Alternative build tool (if you prefer stack over cabal)
---       install:          ghcup install stack recommended
---       verify:           stack --version
---
--- Notes:
---   - HLS versions are tightly coupled to GHC versions; `ghcup install hls`
---     will auto-pick a compatible one. If you upgrade GHC, re-run ghcup to
---     install the matching HLS.
---   - Mason cannot manage the Haskell toolchain because HLS/GHC version
---     coupling requires a real package manager (GHCup).
---   - This lang has no `lsp` field — `haskell-tools.nvim` handles HLS
---     startup internally; see the plugin spec below.

return {
  filetypes = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  treesitter = { 'haskell' },

  external_deps = {
    {
      cmd = 'ghc',
      required = true,
      install = 'ghcup install ghc recommended',
      note = 'install GHCup first: curl --proto =https --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh',
    },
    {
      cmd = 'cabal',
      required = true,
      install = 'ghcup install cabal recommended',
    },
    {
      cmd = 'haskell-language-server-wrapper',
      required = true,
      install = 'ghcup install hls recommended',
      note = 'HLS version must match GHC version exactly',
    },
    {
      cmd = 'haskell-debug-adapter',
      required = false,
      install = 'cabal install haskell-debug-adapter haskell-dap ghci-dap',
      note = 'enables :DapContinue for Haskell',
    },
    {
      cmd = 'stack',
      required = false,
      install = 'ghcup install stack recommended',
      note = 'alternative build tool',
    },
  },

  -- NO lsp field: haskell-tools.nvim handles HLS startup internally
  -- (see top-of-file external deps block for installation)

  -- formatter: not set — HLS integrates ormolu/fourmolu
  -- linter: not set — HLS integrates hlint via plugin

  dap = {
    adapter = {
      ['haskell-debug-adapter'] = {
        type = 'executable',
        command = 'haskell-debug-adapter',
        -- Assumes haskell-debug-adapter is in PATH (see top-of-file external deps block)
      },
    },
    configurations = {
      haskell = {
        {
          name = 'Launch',
          type = 'haskell-debug-adapter',
          request = 'launch',
          workspace = '${workspaceFolder}',
          startup = '${file}',
          stopOnEntry = true,
          logFile = vim.fn.stdpath 'data' .. '/haskell-dap.log',
          logLevel = 'WARNING',
          ghciEnv = vim.empty_dict(),
          ghciPrompt = 'λ> ',
          ghciInitialPrompt = 'ghci> ',
          ghciCmd = 'stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show',
        },
      },
    },
  },

  -- mason: empty — HLS and haskell-debug-adapter are NOT managed by mason
  -- (see top-of-file external deps block for installation)

  plugins = {
    {
      'mrcjkb/haskell-tools.nvim',
      version = '^4',
      ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
      init = function()
        vim.g.haskell_tools = {
          hls = {
            settings = {
              haskell = {
                formattingProvider = 'ormolu',
                checkProject = true,
                plugin = {
                  hlint = { globalOn = true },
                },
              },
            },
          },
          tools = {
            repl = {
              handler = 'toggleterm',
              auto_focus = true,
            },
            hover = {
              enable = true,
            },
          },
          dap = {
            cmd = { 'haskell-debug-adapter' },
          },
        }
      end,
    },
  },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
