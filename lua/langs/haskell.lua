return {
  filetypes = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  treesitter = { 'haskell' },

  -- NO lsp field: haskell-tools.nvim handles HLS startup internally
  -- HLS is NOT in mason — install via: ghcup install hls

  -- formatter: not set — HLS integrates ormolu/fourmolu
  -- linter: not set — HLS integrates hlint via plugin

  dap = {
    adapter = {
      ['haskell-debug-adapter'] = {
        type = 'executable',
        command = 'haskell-debug-adapter',
        -- Assumes haskell-debug-adapter is in PATH
        -- Install via: cabal install haskell-debug-adapter haskell-dap ghci-dap
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
  -- Install HLS via:   ghcup install hls
  -- Install DAP via:   cabal install haskell-debug-adapter haskell-dap ghci-dap

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
