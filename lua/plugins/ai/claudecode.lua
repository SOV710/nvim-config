-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' }, -- Snacks terminal provider
  cmd = {
    'ClaudeCode',
    'ClaudeCodeFocus',
    'ClaudeCodeSelectModel',
    'ClaudeCodeSend',
    'ClaudeCodeAdd',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
    'ClaudeCodeTreeAdd',
    'ClaudeCodeStatus',
  },
  keys = require 'keymaps.ai.claudecode',
  opts = {
    -- ── Server ────────────────────────────────────────────────────────
    port_range = { min = 10000, max = 65535 }, -- WebSocket port range
    auto_start = true, -- start server on plugin load
    log_level = 'info', -- 'trace'|'debug'|'info'|'warn'|'error'
    terminal_cmd = nil, -- nil = use 'claude' from PATH

    -- ── Behavior ──────────────────────────────────────────────────────
    focus_after_send = false, -- focus terminal after ClaudeCodeSend
    track_selection = true, -- real-time selection tracking
    visual_demotion_delay_ms = 50, -- ms before selection update fires

    -- ── Working directory ─────────────────────────────────────────────
    git_repo_cwd = false, -- use git root as cwd (false = buffer dir)
    cwd = nil, -- static override path
    cwd_provider = nil, -- function returning cwd string

    -- ── Terminal ──────────────────────────────────────────────────────
    terminal = {
      split_side = 'right', -- 'left'|'right'
      split_width_percentage = 0.30, -- fraction of editor width for panel
      provider = 'snacks', -- 'auto'|'snacks'|'native'|'external'|'none'
      auto_close = true, -- close window when CLI exits
      snacks_win_opts = {}, -- extra opts forwarded to Snacks window
      provider_opts = {
        external_terminal_cmd = nil, -- command template when provider='external'
      },
    },

    -- ── Diff ──────────────────────────────────────────────────────────
    diff_opts = {
      layout = 'vertical', -- 'vertical'|'horizontal'
      open_in_new_tab = false, -- open diffs in a new tab
      keep_terminal_focus = false, -- refocus terminal after diff opens
      hide_terminal_in_new_tab = false, -- hide terminal when diff tab opens
    },
  },
}
