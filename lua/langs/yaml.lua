-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  treesitter = { 'yaml' },

  lsp = {
    yamlls = {
      cmd = { 'yaml-language-server', '--stdio' },
      root_markers = { '.git' },
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = '',
          },
          schemas = (function()
            local ok, schemastore = pcall(require, 'schemastore')
            return ok and schemastore.yaml.schemas() or {}
          end)(),
          keyOrdering = false,
        },
      },
    },
  },

  -- formatter: not set — yamlls can format via LSP
  -- linter: not set — yamlls provides validation

  mason = { 'yaml-language-server' },

  plugins = {
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
  },
}
