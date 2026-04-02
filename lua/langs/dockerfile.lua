return {
  treesitter = { "dockerfile" },

  lsp = {
    dockerls = {
      cmd = { "docker-langserver", "--stdio" },
      root_markers = { "Dockerfile", ".git" },
    },
  },

  -- linter: hadolint — comprehensive Dockerfile linter
  -- nvim-lint name: "hadolint"
  linter = "hadolint",

  -- formatter: not set — no standard Dockerfile formatter

  mason = { "dockerfile-language-server", "hadolint" },
}
