-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  -- ── Navigation ────────────────────────────────────────────────────

  {
    ']h',
    function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        require('gitsigns').nav_hunk 'next'
      end
    end,
    desc = 'Jump to next git hunk',
  },
  {
    '[h',
    function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        require('gitsigns').nav_hunk 'prev'
      end
    end,
    desc = 'Jump to previous git hunk',
  },

  -- ── Stage / Reset ─────────────────────────────────────────────────

  {
    '<leader>hs',
    function()
      require('gitsigns').stage_hunk()
    end,
    desc = 'Stage hunk',
  },
  {
    '<leader>hs',
    function()
      require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end,
    desc = 'Stage hunk (visual)',
    mode = 'v',
  },
  {
    '<leader>hr',
    function()
      require('gitsigns').reset_hunk()
    end,
    desc = 'Reset hunk',
  },
  {
    '<leader>hr',
    function()
      require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end,
    desc = 'Reset hunk (visual)',
    mode = 'v',
  },
  {
    '<leader>hS',
    function()
      require('gitsigns').stage_buffer()
    end,
    desc = 'Stage buffer',
  },
  {
    '<leader>hR',
    function()
      require('gitsigns').reset_buffer()
    end,
    desc = 'Reset buffer',
  },
  {
    '<leader>hu',
    function()
      require('gitsigns').undo_stage_hunk()
    end,
    desc = 'Undo stage hunk',
  },

  -- ── Inspect ───────────────────────────────────────────────────────

  {
    '<leader>hp',
    function()
      require('gitsigns').preview_hunk()
    end,
    desc = 'Preview hunk',
  },
  {
    '<leader>hb',
    function()
      require('gitsigns').blame_line()
    end,
    desc = 'Blame line',
  },
  {
    '<leader>hB',
    function()
      require('gitsigns').blame_line { full = true }
    end,
    desc = 'Blame line (full)',
  },
  {
    '<leader>hd',
    function()
      require('gitsigns').diffthis()
    end,
    desc = 'Diff against index',
  },
  {
    '<leader>hD',
    function()
      require('gitsigns').diffthis '@'
    end,
    desc = 'Diff against last commit',
  },

  -- ── Toggles ───────────────────────────────────────────────────────

  {
    '<leader>tb',
    function()
      require('gitsigns').toggle_current_line_blame()
    end,
    desc = 'Toggle git line blame',
  },
  {
    '<leader>td',
    function()
      require('gitsigns').toggle_deleted()
    end,
    desc = 'Toggle git show deleted',
  },

  -- ── Text object ───────────────────────────────────────────────────

  {
    'ih',
    function()
      require('gitsigns').select_hunk()
    end,
    desc = 'Inner hunk',
    mode = { 'o', 'x' },
  },
}
