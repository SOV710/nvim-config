-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- SQL — LSP + linter via mason, formatter via cargo (sleek).
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     sleek               Fast Rust-based SQL formatter
---       install:          cargo install sleek
---       verify:           sleek --version
---
---   Optional:
---     sqlfluff            SQL linter (mason fallback)
---       install:          pip install sqlfluff
---       verify:           sqlfluff --version
---
--- Notes:
---   - sleek is NOT in mason (no Rust binary distribution) — cargo install is
---     the only path. Requires Rust toolchain.
---   - sqlfluff is normally managed by mason but may fail to install on some
---     systems; the pip fallback is the recovery path.
---   - sql-language-server IS in mason and managed automatically.

return {
  filetypes = { 'sql', 'mysql', 'plsql' },
  treesitter = { 'sql' },

  external_deps = {
    {
      cmd = 'sleek',
      required = true,
      install = 'cargo install sleek',
      note = 'requires Rust toolchain; no mason distribution',
    },
    {
      cmd = 'sqlfluff',
      required = false,
      install = 'pip install sqlfluff',
      note = 'mason fallback only — normally managed by mason',
    },
  },

  lsp = {
    sqlls = {
      cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
      root_markers = { '.sqllsrc.json', '.git' },
    },
  },

  -- sleek: fast Rust-based SQL formatter
  -- conform.nvim name: "sleek"
  formatter = 'sleek',

  -- sqlfluff: comprehensive SQL linter
  -- nvim-lint name: "sqlfluff"
  linter = 'sqlfluff',

  mason = { 'sqlls', 'sqlfluff' },
  -- NOTE: sleek is NOT in mason (see top-of-file external deps block)
}
