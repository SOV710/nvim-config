-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- LaTeX — LSP via mason (texlab), formatter/linter via TeX Live bundle.
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     TeX Live            Full TeX distribution (provides latex, latexmk, etc.)
---       install:          emerge app-text/texlive
---       verify:           latex --version && latexmk --version
---
---     latexindent         LaTeX formatter (bundled with TeX Live)
---       install:          emerge app-text/texlive-latexextra
---       verify:           which latexindent
---
---     chktex              LaTeX linter (bundled with TeX Live)
---       install:          emerge app-text/texlive    # bundled
---       verify:           which chktex
---
--- Notes:
---   - texlab (mason) delegates formatting to latexindent and linting to
---     chktex; both live inside the TeX distribution, not mason.
---   - latexmk is the build driver texlab invokes; comes with TeX Live.

return {
  treesitter = { 'latex', 'bibtex' },

  external_deps = {
    {
      cmd = 'latex',
      required = true,
      install = 'emerge app-text/texlive',
    },
    {
      cmd = 'latexmk',
      required = true,
      install = 'emerge app-text/texlive',
      note = 'bundled with TeX Live; build driver texlab invokes',
    },
    {
      cmd = 'latexindent',
      required = true,
      install = 'emerge app-text/texlive-latexextra',
      note = 'bundled with TeX Live; texlab delegates formatting to it',
    },
    {
      cmd = 'chktex',
      required = true,
      install = 'emerge app-text/texlive',
      note = 'bundled with TeX Live; texlab delegates linting to it',
    },
    {
      cmd = 'zathura',
      required = false,
      install = 'emerge app-text/zathura app-text/zathura-pdf-mupdf',
      note = 'PDF viewer for vimtex forward-search',
    },
  },

  lsp = {
    texlab = {
      cmd = { 'texlab' },
      filetypes = { 'tex', 'plaintex', 'bib' },
      root_markers = { '.latexmkrc', 'latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml', '.git' },
      settings = {
        texlab = {
          build = {
            executable = 'latexmk',
            args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
            onSave = false,
            forwardSearchAfter = false,
          },
          forwardSearch = {
            executable = 'zathura',
            args = { '--synctex-forward', '%l:1:%f', '%p' },
          },
          -- chktex integration for linting
          chktex = {
            onOpenAndSave = true,
            onEdit = false,
          },
          -- latexindent integration for formatting
          latexFormatter = 'latexindent',
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

  mason = { 'texlab' },
  -- NOTE: latexindent and chktex come with TeX Live, not mason
  -- (see top-of-file external deps block)

  plugins = {
    {
      'lervag/vimtex',
      ft = { 'tex', 'latex', 'bib' },
      init = function()
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_compiler_method = 'latexmk'
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
