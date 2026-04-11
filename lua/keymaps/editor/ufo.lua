-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  {
    'zR',
    function()
      require('ufo').openAllFolds()
    end,
    desc = 'Open all folds',
  },
  {
    'zM',
    function()
      require('ufo').closeAllFolds()
    end,
    desc = 'Close all folds',
  },
  {
    'zr',
    function()
      require('ufo').openFoldsExceptKinds()
    end,
    desc = 'Fold less',
  },
  {
    'zm',
    function()
      require('ufo').closeFoldsWith()
    end,
    desc = 'Fold more',
  },
  -- NOTE: using `zp` instead of `K` to avoid conflict with LSP hover
  {
    'zp',
    function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end,
    desc = 'Peek fold / hover',
  },
}
