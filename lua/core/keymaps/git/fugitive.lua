-- NOTE: <leader>gs and <leader>gl are taken by Snacks.picker (git_status, git_log).
-- Fugitive gets <leader>gg for the status window and <leader>gP for pull.
return {
  -- ── Status window ─────────────────────────────────────────────────

  { '<leader>gg', '<cmd>Git<cr>',              desc = 'Git status (fugitive)' },

  -- ── Commit / Push / Pull ──────────────────────────────────────────

  { '<leader>gc', '<cmd>Git commit<cr>',       desc = 'Git commit' },
  { '<leader>gp', '<cmd>Git push<cr>',         desc = 'Git push' },
  { '<leader>gP', '<cmd>Git pull<cr>',         desc = 'Git pull' },
  { '<leader>gL', '<cmd>Git log --oneline<cr>', desc = 'Git log (oneline)' },

  -- ── Blame / Diff ──────────────────────────────────────────────────

  { '<leader>gb', '<cmd>Git blame<cr>',        desc = 'Git blame' },

  -- ── File operations ───────────────────────────────────────────────

  { '<leader>gw', '<cmd>Gwrite<cr>',           desc = 'Git write (stage file)' },
  { '<leader>gr', '<cmd>Gread<cr>',            desc = 'Git read (checkout file)' },
}
