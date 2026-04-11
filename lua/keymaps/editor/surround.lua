-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

-- Keymaps managed by mini.surround via its `mappings` config.
-- Listed here for which-key registration / documentation purposes.
return {
  { 'gaa', desc = 'Add surrounding', mode = { 'n', 'v' }, remap = false },
  { 'gad', desc = 'Delete surrounding', remap = false },
  { 'gar', desc = 'Replace surrounding', remap = false },
  { 'gaf', desc = 'Find surrounding (right)', remap = false },
  { 'gaF', desc = 'Find surrounding (left)', remap = false },
  { 'gah', desc = 'Highlight surrounding', remap = false },
}
