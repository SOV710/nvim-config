return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'v',
          ['@class.outer'] = 'V',
        },
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'
    local swap = require 'nvim-treesitter-textobjects.swap'
    local ts_repeat = require 'nvim-treesitter-textobjects.repeatable_move'

    -- ── select textobjects ──────────────────────────────────────────
    local select_maps = {
      { 'af', '@function.outer', 'outer function' },
      { 'if', '@function.inner', 'inner function' },
      { 'ac', '@class.outer', 'outer class' },
      { 'ic', '@class.inner', 'inner class' },
      { 'aa', '@parameter.outer', 'outer parameter' },
      { 'ia', '@parameter.inner', 'inner parameter' },
      { 'ai', '@conditional.outer', 'outer conditional' },
      { 'ii', '@conditional.inner', 'inner conditional' },
      { 'al', '@loop.outer', 'outer loop' },
      { 'il', '@loop.inner', 'inner loop' },
      { 'ab', '@block.outer', 'outer block' },
      { 'ib', '@block.inner', 'inner block' },
      { 'aN', '@comment.outer', 'outer comment' },
      { 'iN', '@comment.inner', 'inner comment' },
    }
    for _, m in ipairs(select_maps) do
      vim.keymap.set({ 'x', 'o' }, m[1], function()
        select.select_textobject(m[2])
      end, { desc = m[3] })
    end

    -- ── move (goto) textobjects ─────────────────────────────────────
    local move_maps = {
      { ']f', 'goto_next_start', '@function.outer', 'Next function start' },
      { ']F', 'goto_next_end', '@function.outer', 'Next function end' },
      { ']c', 'goto_next_start', '@class.outer', 'Next class start' },
      { ']C', 'goto_next_end', '@class.outer', 'Next class end' },
      { '[f', 'goto_previous_start', '@function.outer', 'Prev function start' },
      { '[F', 'goto_previous_end', '@function.outer', 'Prev function end' },
      { '[c', 'goto_previous_start', '@class.outer', 'Prev class start' },
      { '[C', 'goto_previous_end', '@class.outer', 'Prev class end' },
      { ']a', 'goto_next_start', '@parameter.inner', 'Next parameter' },
      { '[a', 'goto_previous_start', '@parameter.inner', 'Prev parameter' },
    }
    for _, m in ipairs(move_maps) do
      vim.keymap.set({ 'n', 'x', 'o' }, m[1], function()
        move[m[2]](m[3])
      end, { desc = m[4] })
    end

    -- ── swap textobjects ────────────────────────────────────────────
    vim.keymap.set('n', '<leader>a', function()
      swap.swap_next '@parameter.inner'
    end, { desc = 'Swap next parameter' })
    vim.keymap.set('n', '<leader>A', function()
      swap.swap_previous '@parameter.inner'
    end, { desc = 'Swap prev parameter' })

    -- ── repeatable move (;/,) ───────────────────────────────────────
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat.repeat_last_move_next, { desc = 'Repeat last move' })
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat.repeat_last_move_previous, { desc = 'Repeat last move (reverse)' })
  end,
}
