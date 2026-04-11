-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local function apply(keymaps)
  for _, km in ipairs(keymaps) do
    vim.keymap.set(km.mode or 'n', km[1], km[2], {
      desc = km.desc,
      expr = km.expr,
      silent = km.silent ~= false,
      remap = km.remap,
    })
  end
end

-- Standalone keymaps (not tied to any plugin)
apply(require 'keymaps.editing')
apply(require 'keymaps.winbuf')

-- LSP keymaps (special: uses LspAttach autocmd)
require('keymaps.langs.lsp').setup()

-- diagnostic keymaps
apply(require 'keymaps.langs.diagnostic')
