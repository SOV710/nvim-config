return {
  treesitter = { "nix" },

  lsp = {
    nil_ls = {
      settings = {
        ["nil"] = {
          formatting = {
            command = { "nixfmt" },
          },
          nix = {
            flake = {
              autoArchive = true,
            },
          },
        },
      },
    },
  },

  -- nil_ls can format via its built-in nixfmt integration (configured above)
  -- but we also set it in conform for explicit control
  formatter = "nixfmt",

  mason = { "nil", "nixfmt" },
}
