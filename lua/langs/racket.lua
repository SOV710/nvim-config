-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- Racket - Tree-sitter + LSP + Conjure REPL.
---
--- External dependencies (NOT managed by mason):
---
---   Required:
---     racket              Racket runtime
---       install:          install Racket from https://download.racket-lang.org/
---                         or your system package manager
---
---     raco                Racket package manager, bundled with Racket
---       install:          bundled with Racket
---
---     racket-langserver   Racket language server package
---       install:          raco pkg install racket-langserver
---
--- Notes:
---   - The LSP command is `racket -l racket-langserver`; do not health-check
---     an executable named `racket-langserver`.
---   - Conjure's Racket client starts a stdio REPL with `racket`.
---   - This config intentionally does not manage Racket tools with mason.

local racket_langs = {
  ['racket'] = true,
  ['racket/base'] = true,
  ['typed/racket'] = true,
  ['typed/racket/base'] = true,
  ['lazy'] = true,
  ['frtime'] = true,
  ['htdp/bsl'] = true,
  ['htdp/bsl+'] = true,
  ['htdp/isl'] = true,
  ['htdp/isl+'] = true,
  ['htdp/asl'] = true,
  ['sicp'] = true,
  ['r5rs'] = true,
  ['r6rs'] = true,
}

local function detect_racket_scm(_, bufnr)
  local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
  local lang = line:match '^%s*#lang%s+([^%s]+)'
  if racket_langs[lang] then
    return 'racket'
  end
end

return {
  filetypes = { 'racket' },

  filetype = {
    pattern = {
      ['.*%.scm'] = { detect_racket_scm, { priority = 10 } },
    },
  },

  treesitter = {
    languages = {
      racket = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/6cdh/tree-sitter-racket',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'racket' },
          },
        },
      },
    },
  },

  external_deps = {
    {
      cmd = 'racket',
      required = true,
      install = 'install Racket from https://download.racket-lang.org/ or your system package manager',
      note = 'required by Conjure Racket REPL and racket-langserver',
    },
    {
      cmd = 'raco',
      required = true,
      install = 'bundled with Racket; then run `raco pkg install racket-langserver`',
      note = 'used to install Racket packages such as racket-langserver',
    },
  },

  lsp = {
    racket_langserver = {
      cmd = { 'racket', '-l', 'racket-langserver' },
      root_markers = { 'info.rkt', 'main.rkt', '.git' },
    },
  },

  -- formatter: not set - racket-langserver provides LSP formatting
  -- linter: not set - racket-langserver provides diagnostics
  -- mason: empty - Racket tooling is managed by Racket/raco

  options = {
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}
