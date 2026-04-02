return {
  filetypes = { "sh", "bash", "zsh" },
  treesitter = { "bash" },

  lsp = {
    bashls = {
      cmd = { "bash-language-server", "start" },
      root_markers = { ".git" },
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
