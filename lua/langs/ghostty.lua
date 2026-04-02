return {
  treesitter = 'ghostty',
  plugins = {
    { 'bezhermoso/tree-sitter-ghostty', ft = 'ghostty', build = 'make nvim_install' },
  },
}
