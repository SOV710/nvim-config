return {
  treesitter = { "toml" },

  lsp = {
    taplo = {
      cmd = { "taplo", "lsp", "stdio" },
      root_markers = { ".taplo.toml", "taplo.toml", ".git" },
    },
  },

  -- formatter: not set — taplo formats via LSP
  -- linter: not set — taplo validates via LSP

  mason = { "taplo" },
}
