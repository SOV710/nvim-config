-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- Fish shell — LSP via npm (fish-lsp), formatter via bundled `fish_indent`.
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     fish-lsp            Fish shell language server
---       install:          npm install -g fish-lsp
---       verify:           fish-lsp --version
---
---     fish_indent         Fish's built-in formatter (bundled with fish shell)
---       install:          emerge app-shells/fish    # comes bundled
---       verify:           which fish_indent
---
--- Notes:
---   - fish-lsp is not in mason — requires Node.js/npm as runtime.
---   - fish_indent requires nothing beyond fish itself; if fish is on $PATH,
---     so is fish_indent.
---   - No mason packages for this lang.

return {
  treesitter = {
    languages = {
      fish = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/ram02z/tree-sitter-fish',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'fish' },
          },
        },
      },
    },
  },

  external_deps = {
    {
      cmd = 'fish-lsp',
      required = true,
      install = 'npm install -g fish-lsp',
      note = 'requires Node.js/npm runtime',
    },
    {
      cmd = 'fish_indent',
      required = true,
      install = 'emerge app-shells/fish',
      note = 'bundled with fish shell; on $PATH whenever fish is',
    },
  },

  lsp = {
    fish_lsp = {
      -- (see top-of-file external deps block for installation)
      cmd = { 'fish-lsp', 'start' },
      root_markers = { 'config.fish', '.git' },
    },
  },

  -- fish_indent is Fish's built-in formatter
  formatter = 'fish_indent',
}
