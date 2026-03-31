local map = vim.keymap.set

-- ── Buffer operations ────────────────────────────────────────────────

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to alternate" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>", { desc = "Delete other buffers" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })

-- ── Window operations ────────────────────────────────────────────────

map("n", "<leader>wh", "<C-W>s", { desc = "Split horizontal" })
map("n", "<leader>wv", "<C-W>v", { desc = "Split vertical" })
map("n", "<leader>wd", "<C-W>c", { desc = "Close window" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-S-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-S-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
map("n", "<C-S-k>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-S-j>", "<cmd>resize -2<cr>", { desc = "Decrease height" })

-- ── Tab operations ───────────────────────────────────────────────────

map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader><tab>H", "<cmd>-tabm<cr>", { desc = "Move tab left" })
map("n", "<leader><tab>L", "<cmd>+tabm<cr>", { desc = "Move tab right" })
map("n", "<S-l>", "<cmd>tabn<cr>", { desc = "Next tab" })
map("n", "<S-h>", "<cmd>tabp<cr>", { desc = "Prev tab" })
