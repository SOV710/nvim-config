--- CMake — LSP/formatter/linter via mason, with pip fallbacks.
---
--- External dependencies (NOT managed by mason):
---
---   Optional:
---     gersemi             Python-based CMake formatter (mason fallback)
---       install:          pip install gersemi
---       verify:           gersemi --version
---
---     cmakelint           CMake linter (mason fallback)
---       install:          pip install cmakelint
---       verify:           cmakelint --version
---
--- Notes:
---   - Both gersemi and cmakelint are normally managed by mason. These pip
---     install commands are only needed as a recovery path when mason fails
---     to install them on some systems.
---   - neocmakelsp IS in mason and managed automatically.

return {
  treesitter = { 'cmake' },

  lsp = {
    neocmakelsp = {
      cmd = { 'neocmakelsp', 'stdio' },
      root_markers = { 'CMakeLists.txt', 'cmake', '.git' },
      -- Disable LSP formatting capability — we use gersemi through conform instead
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },
  },

  -- gersemi: Python-based CMake formatter
  -- conform.nvim name: "gersemi"
  formatter = 'gersemi',

  -- cmakelint: CMake linter
  -- nvim-lint name: "cmakelint"
  linter = 'cmakelint',

  mason = { 'neocmakelsp', 'gersemi', 'cmakelint' },
  -- NOTE: pip fallback for gersemi/cmakelint in top-of-file external deps block
}
