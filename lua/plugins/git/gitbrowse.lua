-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

-- Snacks.gitbrowse — open current file/line/selection in browser.
-- Merges into the main folke/snacks.nvim spec via lazy.nvim spec merging.
return {
  'folke/snacks.nvim',
  keys = require 'keymaps.git.gitbrowse',
  opts = {
    gitbrowse = {
      notify = true, -- show notification when opening URL
      -- what to open: 'repo'|'branch'|'file'|'commit'|'permalink'
      -- defaults to 'permalink' for visual selections, 'file' otherwise
      what = 'file',
    },
  },
}
