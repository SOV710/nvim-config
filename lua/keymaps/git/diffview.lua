-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

-- NOTE: <leader>gf is taken by Snacks.picker (git_files).
-- File history uses <leader>gh/<leader>gH instead.
return {
  -- ── Open / Close ──────────────────────────────────────────────────

  { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview open' },
  { '<leader>gD', '<cmd>DiffviewOpen HEAD~1<cr>', desc = 'Diffview diff HEAD~1' },
  { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview close' },

  -- ── File history ──────────────────────────────────────────────────

  { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history (current file)' },
  { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'File history (repo)' },
}
