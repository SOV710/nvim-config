-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  'cbochs/grapple.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = require 'keymaps.editor.grapple',
  opts = {
    scope = 'git', -- tag scope: "git"|"git_branch"|"cwd"|"global"|"static"|"lsp"
    icons = true, -- show icons in the tags menu
    quick_select = '1234567890', -- keys for quick-selecting tags in the menu
    status = true, -- show grapple statusline component
    style = 'relative', -- path display style: "relative"|"basename"|"unique"
    prune = '60d', -- prune missing files: "cwd"|false

    tag_title = function(scope)
      return ' ' .. vim.fn.fnamemodify(scope.id, ':t')
    end,

    win_opts = {
      width = 80, -- tags menu window width
      height = 12, -- tags menu window height
      border = 'rounded', -- border style: "none"|"single"|"double"|"rounded"
      footer = '', -- footer text
      style = 'minimal',
      title_pos = 'center', -- title position: "left"|"center"|"right"
    },
  },

  config = function(_, opts)
    require('grapple').setup(opts)

    -- Wrap all mutating entry points so any tag change emits a uniform User event,
    -- regardless of whether the change came from a keymap, :Grapple command, or menu action.
    local grapple = require 'grapple'
    local mutating = { 'tag', 'untag', 'toggle', 'reset', 'select', 'cycle_tags' }
    for _, name in ipairs(mutating) do
      local original = grapple[name]
      grapple[name] = function(...)
        local result = original(...)
        vim.api.nvim_exec_autocmds('User', { pattern = 'GrappleUpdate' })
        vim.cmd.redrawtabline() -- force vim rerender tabline
        return result
      end
    end
  end,
}
