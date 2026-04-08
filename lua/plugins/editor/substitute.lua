return {
  'gbprod/substitute.nvim',
  keys = require 'keymaps.editor.substitute',
  opts = {
    on_substitute = nil, -- callback fired after substitution
    yank_substituted_text = false, -- yank the text that was substituted
    preserve_cursor_position = false, -- keep cursor position after substitute
    modifiers = nil, -- custom modifiers for substitute
    highlight_substituted_text = {
      enabled = true, -- highlight text after substitution
      timer = 200, -- highlight duration in ms
    },
    range = {
      prefix = 's', -- prefix for range substitute command
      prompt_current_text = false, -- pre-fill command line with current text
      confirm = false, -- confirm each substitution
      complete_word = false, -- use word boundary matching
      subject = nil, -- custom subject for range substitute
      range = nil, -- custom range for range substitute
      suffix = '', -- suffix for range substitute command
      auto_apply = false, -- auto-apply on TextChanged
      cursor_position = 'original', -- cursor position after: "original"|"start"|"end"
    },
    exchange = {
      motion = false, -- use motion for exchange (vs operator)
      use_esc_to_cancel = true, -- press Esc to cancel exchange
      preserve_cursor_position = false, -- keep cursor position after exchange
    },
  },
}
