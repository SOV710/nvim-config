return {
  'Wansmer/treesj',
  cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
  keys = require 'keymaps.editor.treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    use_default_keymaps = false, -- disable default keymaps (we manage our own)
    check_syntax_error = true, -- check for syntax errors before split/join
    max_join_length = 120, -- max line length after join (0 = no limit)
    cursor_behavior = 'hold', -- cursor behavior: "hold"|"start"|"end"
    notify = true, -- show notification on unsupported node
    dot_repeat = true, -- enable dot-repeat for split/join
    on_error = nil, -- custom error handler function
  },
}
