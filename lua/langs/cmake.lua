return {
  treesitter = { "cmake" },

  lsp = {
    neocmakelsp = {
      cmd = { "neocmakelsp", "--stdio" },
      -- Disable LSP formatting capability — we use gersemi through conform instead
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },
  },

  -- gersemi: Python-based CMake formatter
  -- conform.nvim name: "gersemi"
  formatter = "gersemi",

  -- cmakelint: CMake linter
  -- nvim-lint name: "cmakelint"
  linter = "cmakelint",

  mason = { "neocmakelsp", "gersemi", "cmakelint" },
  -- NOTE: if gersemi or cmakelint are not in mason, install via:
  --   pip install gersemi cmakelint
}
