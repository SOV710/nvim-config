return {
  treesitter = false, -- custom parser installed by plugin, not in nvim-treesitter registry
  plugins = {
    { 'bezhermoso/tree-sitter-ghostty', ft = 'ghostty', build = 'make nvim_install' },
  },
}
