-- Extends Neovim's native gc/gcc comment engine with
-- treesitter-aware comment strings for embedded languages (JSX/TSX, Vue, etc.)
return {
  'folke/ts-comments.nvim',
  event = 'VeryLazy',
  opts = {},                               -- zero-config: automatically augments native gc/gcc
}
