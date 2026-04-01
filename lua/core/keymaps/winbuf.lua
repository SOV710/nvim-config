return {
  -- ── Buffer operations ────────────────────────────────────────────────

  { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to alternate" },

  -- ── Window operations ────────────────────────────────────────────────

  { "<leader>wh", "<C-W>s", desc = "Split horizontal" },
  { "<leader>wv", "<C-W>v", desc = "Split vertical" },
  { "<leader>wd", "<C-W>c", desc = "Close window" },
  { "<C-h>", "<C-w>h", desc = "Go to left window" },
  { "<C-j>", "<C-w>j", desc = "Go to lower window" },
  { "<C-k>", "<C-w>k", desc = "Go to upper window" },
  { "<C-l>", "<C-w>l", desc = "Go to right window" },
  { "<C-S-h>", "<cmd>vertical resize -2<cr>", desc = "Decrease width" },
  { "<C-S-l>", "<cmd>vertical resize +2<cr>", desc = "Increase width" },
  { "<C-S-k>", "<cmd>resize +2<cr>", desc = "Increase height" },
  { "<C-S-j>", "<cmd>resize -2<cr>", desc = "Decrease height" },

  -- ── Tab operations ───────────────────────────────────────────────────

  { "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First tab" },
  { "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last tab" },
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close tab" },
  { "<leader><tab>o", "<cmd>tabonly<cr>", desc = "Close other tabs" },
  { "<leader><tab>H", "<cmd>-tabm<cr>", desc = "Move tab left" },
  { "<leader><tab>L", "<cmd>+tabm<cr>", desc = "Move tab right" },
  { "<S-l>", "<cmd>tabn<cr>", desc = "Next tab" },
  { "<S-h>", "<cmd>tabp<cr>", desc = "Prev tab" },
}
