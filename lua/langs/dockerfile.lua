return {
  treesitter = { "dockerfile" },

  lsp = "dockerls",

  -- linter: hadolint — comprehensive Dockerfile linter
  -- nvim-lint name: "hadolint"
  linter = "hadolint",

  -- formatter: not set — no standard Dockerfile formatter

  mason = { "dockerfile-language-server", "hadolint" },
}
