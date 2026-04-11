-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  -- ── claudecode ───────────────────────────────────────────────────────

  { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code terminal' },
  { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude Code terminal' },
  { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume last Claude session' },
  { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue last Claude session' },
  { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
  { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer to Claude' },
  { '<leader>as', '<cmd>ClaudeCodeSend<cr>', desc = 'Send selection to Claude', mode = 'v' },
  { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Claude diff' },
  { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny Claude diff' },
  { '<leader>aT', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add tree file to Claude' },
}
