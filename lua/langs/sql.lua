return {
  filetypes = { 'sql', 'mysql', 'plsql' },
  treesitter = { 'sql' },

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
  -- NOTE: sleek is NOT in mason — install via: cargo install sleek
}
