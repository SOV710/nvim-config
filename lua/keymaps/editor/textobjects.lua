local keys = {}

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
  { 'ao', '@loop.outer', 'outer loop' },
  { 'io', '@loop.inner', 'inner loop' },
  { 'ab', '@block.outer', 'outer block' },
  { 'ib', '@block.inner', 'inner block' },
  { 'aN', '@comment.outer', 'outer comment' },
  { 'iN', '@comment.inner', 'inner comment' },
}
for _, m in ipairs(select_maps) do
  local lhs, capture, desc = m[1], m[2], m[3]
  keys[#keys + 1] = {
    lhs,
    function()
      require('nvim-treesitter-textobjects.select').select_textobject(capture)
    end,
    mode = { 'x', 'o' },
    desc = desc,
  }
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
  local lhs, method, capture, desc = m[1], m[2], m[3], m[4]
  keys[#keys + 1] = {
    lhs,
    function()
      require('nvim-treesitter-textobjects.move')[method](capture)
    end,
    mode = { 'n', 'x', 'o' },
    desc = desc,
  }
end

-- ── swap textobjects ────────────────────────────────────────────
keys[#keys + 1] = {
  '<leader>a',
  function()
    require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
  end,
  desc = 'Swap next parameter',
}
keys[#keys + 1] = {
  '<leader>A',
  function()
    require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
  end,
  desc = 'Swap prev parameter',
}

-- ── repeatable move (;/,) ───────────────────────────────────────
keys[#keys + 1] = {
  ';',
  function()
    require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_next()
  end,
  mode = { 'n', 'x', 'o' },
  desc = 'Repeat last move',
}
keys[#keys + 1] = {
  ',',
  function()
    require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_previous()
  end,
  mode = { 'n', 'x', 'o' },
  desc = 'Repeat last move (reverse)',
}

return keys
