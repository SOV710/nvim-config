return {
  'folke/snacks.nvim',
  opts = {
    indent = {
      enabled = true,
      indent = {
        char = '│', -- character for indent guides
        only_scope = false, -- show guides for all levels, not just current scope
        only_current = false, -- show guides in all windows
      },
      scope = {
        enabled = true, -- highlight current scope
        priority = 200,
        char = '│',
        underline = false, -- no underline at scope boundaries
        only_current = false, -- show scope in all windows
      },
      animate = {
        enabled = true, -- animate scope changes
        easing = 'outQuad',
      },
      filter = function(buf)
        -- disable for specific filetypes/buftypes
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ''
      end,
    },
  },
}
