return {
  treesitter = { 'fish' },

  lsp = {
    fish_lsp = {
      -- NOT in mason — install via: npm install -g fish-lsp
      cmd = { 'fish-lsp', 'start' },
      root_markers = { 'config.fish', '.git' },
    },
  },

  -- fish_indent is Fish's built-in formatter, available if fish is installed
  formatter = 'fish_indent',

  -- no mason packages — fish-lsp installed externally, fish_indent comes with fish
}
