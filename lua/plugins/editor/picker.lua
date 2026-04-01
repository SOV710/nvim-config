return {
  'folke/snacks.nvim',
  opts = {
    picker = {
      -- ── General ─────────────────────────────────────────────────────
      prompt = ' ',                    -- prompt prefix icon
      ui_select = true,                 -- replace vim.ui.select with picker

      -- ── Sources (per-picker overrides) ──────────────────────────────
      sources = {
        files = {
          hidden = true,                -- include dotfiles in file search
          ignored = false,              -- exclude .gitignore'd files
        },
        grep = {
          hidden = true,                -- search inside dotfiles
          ignored = false,              -- exclude .gitignore'd files
        },
      },

      -- ── Window ──────────────────────────────────────────────────────
      win = {
        input = {
          keys = {
            ['<C-k>'] = { 'list_scroll_up', mode = { 'n', 'i' } },
            ['<C-j>'] = { 'list_scroll_down', mode = { 'n', 'i' } },
            ['<C-l>'] = { 'confirm', mode = { 'n', 'i' } },
          },
        },
      },

      -- ── Layout ──────────────────────────────────────────────────────
      layout = {
        preset = 'default',             -- layout preset: "default"|"dropdown"|"ivy"|"select"
        -- cycle = true,                -- allow cycling through results
      },
    },
  },
}
