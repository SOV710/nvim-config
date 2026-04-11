-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'json', 'jsonc' },
  treesitter = { 'json', 'jsonc', 'json5' },

  lsp = {
    jsonls = {
      cmd = { 'vscode-json-language-server', '--stdio' },
      root_markers = { '.git' },
      settings = {
        json = {
          schemas = (function()
            local ok, schemastore = pcall(require, 'schemastore')
            return ok and schemastore.json.schemas() or {}
          end)(),
          validate = { enable = true },
        },
      },
    },

    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      root_markers = { 'biome.json', 'biome.jsonc' },
    },
  },

  formatter = 'biome',

  mason = { 'json-lsp', 'biome' },

  plugins = {
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
  },
}
