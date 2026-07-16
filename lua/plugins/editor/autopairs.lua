-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local lisp_filetypes = {
  'carp',
  'clojure',
  'commonlisp',
  'edn',
  'elisp',
  'fennel',
  'hy',
  'janet',
  'lisp',
  'picolisp',
  'racket',
  'scheme',
}

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    enabled = function(bufnr)
      -- disabled in bigfiles (>1MB)
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > 1024 * 1024 then
        return false
      end
      return true
    end,
    disable_filetype = {
      'TelescopePrompt',
      'spectre_panel',
      'snacks_picker_input',
      'snacks_input',
      'grug-far',
    },
    disable_in_macro = true, -- disable when recording/executing macros
    disable_in_visualblock = false, -- disable in visual block mode
    disable_in_replace_mode = true, -- disable in replace mode
    enable_moveright = true, -- move right when closing pair exists
    enable_afterquote = true, -- add pair after a quote character
    enable_check_bracket_line = false, -- allow pairing before an existing closing bracket
    check_ts = true, -- use treesitter to check for pairs
    ts_config = {
      lua = { 'string' }, -- treesitter nodes where pairs are disabled
      javascript = { 'template_string' },
    },
    map_cr = true, -- map <CR> to auto-indent between pairs
    map_bs = true, -- map <BS> to delete pair
    map_c_h = false, -- map <C-h> to delete pair (like <BS>)
    map_c_w = false, -- map <C-w> to delete pair (like <BS>)
    fast_wrap = {
      map = '<M-e>', -- trigger fast wrap with Alt-e
      chars = { '{', '[', '(', '"', "'" }, -- characters that trigger fast wrap
      pattern = [=[[%'%"%>%]%)%}%,]]=], -- pattern to match wrap targets
      end_key = '$', -- key to jump to end of line
      before_key = 'h', -- key to insert before target
      after_key = 'l', -- key to insert after target
      cursor_pos_before = true, -- place cursor before target
      keys = 'qwertyuiopzxcvbnmasdfghjkl', -- keys for label-based wrapping
      highlight = 'PmenuSel', -- highlight group for labels
      highlight_grey = 'LineNr', -- highlight group for non-label chars
    },
  },
  config = function(_, opts)
    local autopairs = require 'nvim-autopairs'
    autopairs.setup(opts)

    local single_quote_rule = assert(autopairs.get_rules("'")[1], 'nvim-autopairs single quote rule is missing')
    single_quote_rule.not_filetypes = lisp_filetypes
    autopairs.force_attach()
  end,
}
