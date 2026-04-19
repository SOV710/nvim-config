-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'json', 'jsonc' },
  treesitter = {
    languages = {
      json = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/tree-sitter/tree-sitter-json',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'json' },
          },
        },
      },
      jsonc = {
        parser = {
          source = {
            type = 'git',
            url = 'https://gitlab.com/WhyNotHugo/tree-sitter-jsonc.git',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'jsonc' },
          },
        },
      },
      json5 = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/Joakker/tree-sitter-json5',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'json5' },
          },
        },
      },
    },
  },

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
