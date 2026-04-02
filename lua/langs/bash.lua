return {
  filetypes = { "sh", "bash", "zsh" },
  treesitter = { "bash" },

  lsp = {
    bashls = {
      settings = {
        bashIde = {
          globPattern = "*@(.sh|.inc|.bash|.command)",
        },
      },
    },
  },

  formatter = "shfmt",

  mason = { "bash-language-server", "shfmt" },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
