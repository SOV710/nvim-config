return {
  treesitter = { 'commonlisp' },

  lsp = {
    -- cl-lsp: NOT in mason
    -- Install via quicklisp: (ql:quickload "cl-lsp")
    -- Or from source: https://github.com/cxxxr/cl-lsp
    cl_lsp = {
      cmd = { 'cl-lsp' },
      root_markers = { '.git' },
    },
  },

  -- no mason packages — cl-lsp installed externally
}
