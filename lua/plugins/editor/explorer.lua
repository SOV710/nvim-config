return {
  'folke/snacks.nvim',
  opts = {
    explorer = {
      replace_netrw = false, -- oil handles netrw replacement
      trash = true,
    },
    picker = {
      sources = {
        explorer = {
          layout = {
            preset = 'sidebar',
            preview = false,
            layout = {
              width = function()
                -- 20% of columns, clamped to [36, 60]
                return math.max(25, math.min(50, math.floor(vim.o.columns * 0.2)))
              end,
              min_width = 40,
              max_width = 120,
            },
          },
        },
      },
    },
  },
}
