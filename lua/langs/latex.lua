return {
  treesitter = { "latex", "bibtex" },

  lsp = {
    texlab = {
      cmd = { "texlab" },
      filetypes = { "tex", "plaintex", "bib" },
      root_markers = { ".latexmkrc", "latexmkrc", ".texlabroot", "texlabroot", "Tectonic.toml", ".git" },
      settings = {
        texlab = {
          build = {
            executable = "latexmk",
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            onSave = false,
            forwardSearchAfter = false,
          },
          forwardSearch = {
            executable = "zathura",
            args = { "--synctex-forward", "%l:1:%f", "%p" },
          },
          -- chktex integration for linting
          chktex = {
            onOpenAndSave = true,
            onEdit = false,
          },
          -- latexindent integration for formatting
          latexFormatter = "latexindent",
          latexindent = {
            modifyLineBreaks = false,
          },
          diagnostics = {
            ignoredPatterns = {},
          },
        },
      },
    },
  },

  -- formatter: not set — texlab integrates latexindent, formats via LSP
  -- linter: not set — texlab integrates chktex

  mason = { "texlab" },
  -- NOTE: latexindent and chktex come with your TeX distribution (texlive),
  -- NOT installed via mason. texlab delegates to them.

  plugins = {
    {
      "lervag/vimtex",
      ft = { "tex", "latex", "bib" },
      init = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_quickfix_mode = 0
        -- Disable VimTeX's syntax — treesitter handles it
        vim.g.vimtex_syntax_enabled = 0
      end,
    },
  },

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    wrap = true,
    linebreak = true,
    spell = true,
  },
}
