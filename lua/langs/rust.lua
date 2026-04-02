return {
  treesitter = { "rust", "toml" },

  -- NO lsp field: rustaceanvim handles rust-analyzer startup internally

  -- formatter: not set — rust-analyzer integrates rustfmt
  -- linter: not set — clippy runs via rust-analyzer's checkOnSave

  dap = {
    adapter = {
      codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      },
    },
    configurations = {
      rust = {
        {
          name = "Launch (Rust)",
          type = "codelldb",
          request = "launch",
          program = function()
            local handle = io.popen("cargo metadata --format-version=1 --no-deps 2>/dev/null")
            if handle then
              local result = handle:read("*a")
              handle:close()
              local ok, metadata = pcall(vim.json.decode, result)
              if ok and metadata.target_directory then
                return vim.fn.input(
                  "Path to executable: ",
                  metadata.target_directory .. "/debug/",
                  "file"
                )
              end
            end
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      },
    },
  },

  mason = { "rust-analyzer", "codelldb" },

  plugins = {
    {
      "mrcjkb/rustaceanvim",
      version = "^5",
      ft = "rust",
      init = function()
        vim.g.rustaceanvim = {
          server = {
            default_settings = {
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                  buildScripts = { enable = true },
                },
                checkOnSave = true,
                check = {
                  command = "clippy",
                },
                diagnostics = { enable = true },
                procMacro = {
                  enable = true,
                  ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["async-recursion"] = { "async_recursion" },
                  },
                },
                files = {
                  excludeDirs = { ".git", "target", "node_modules", ".direnv" },
                },
              },
            },
            on_attach = function(_, bufnr)
              vim.keymap.set("n", "<leader>cR", function()
                vim.cmd.RustLsp("codeAction")
              end, { desc = "Rust code action", buffer = bufnr })
              vim.keymap.set("n", "<leader>dr", function()
                vim.cmd.RustLsp("debuggables")
              end, { desc = "Rust debuggables", buffer = bufnr })
            end,
          },
        }
      end,
    },
    {
      "Saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      opts = {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      },
    },
  },
}
