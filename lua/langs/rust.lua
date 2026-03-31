return {
  filetypes  = { "rust" }, -- optional, default = { "filename" }
  treesitter = { "rust", "toml" },
  lsp        = {           -- string | table
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            buildScripts = { enable = true },
          },
          checkOnSave = true,
          diagnostics = { enable = true },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
          files = {
            excludeDirs = { ".git", "target", "node_modules" },
          },
        },
      },
    },
  },
  formatter  = "rustfmt",                       -- string | string[]
  dap        = "codelldb",                      -- string | string[]
  mason      = { "rust-analyzer", "codelldb" }, -- explicitly specify the mason package name
  plugins    = {
    {
      "mrcjkb/rustaceanvim",
      ft = "rust",
    },
    {
      "Saecki/crates.nvim",
      event = "BufRead Cargo.toml",
      opts = {
        lsp = { enabled = true, actions = true, completion = true, hover = true },
      },
    },
  },
}
