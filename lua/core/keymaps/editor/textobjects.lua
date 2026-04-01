-- Keymaps managed by treesitter-textobjects and mini.ai via their configs.
-- Listed here for which-key registration / documentation purposes.
return {
  -- ── Swap ───────────────────────────────────────────────────────────
  { '<leader>a', desc = 'Swap next parameter' },
  { '<leader>A', desc = 'Swap prev parameter' },

  -- ── Goto next ──────────────────────────────────────────────────────
  { ']f', desc = 'Next function start', mode = { 'n', 'x', 'o' } },
  { ']F', desc = 'Next function end', mode = { 'n', 'x', 'o' } },
  { ']c', desc = 'Next class start', mode = { 'n', 'x', 'o' } },
  { ']C', desc = 'Next class end', mode = { 'n', 'x', 'o' } },

  -- ── Goto prev ──────────────────────────────────────────────────────
  { '[f', desc = 'Prev function start', mode = { 'n', 'x', 'o' } },
  { '[F', desc = 'Prev function end', mode = { 'n', 'x', 'o' } },
  { '[c', desc = 'Prev class start', mode = { 'n', 'x', 'o' } },
  { '[C', desc = 'Prev class end', mode = { 'n', 'x', 'o' } },
}
