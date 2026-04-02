return {
  filetypes = { "asm", "nasm", "masm", "vmasm" },
  treesitter = { "asm" },

  lsp = {
    asm_lsp = {
      cmd = { "asm-lsp" },
      root_markers = { ".asm-lsp.toml", ".git" },
    },
  },

  mason = { "asm-lsp" },
}
