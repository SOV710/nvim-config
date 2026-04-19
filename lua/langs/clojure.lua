-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

return {
  filetypes = { 'clojure', 'edn' },
  treesitter = {
    languages = {
      clojure = {
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/sogaiu/tree-sitter-clojure',
          },
          build = {
            files = { 'src/parser.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'clojure' },
          },
        },
      },
    },
  },

  lsp = {
    clojure_lsp = {
      cmd = { 'clojure-lsp' },
      root_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', 'bb.edn', '.git' },
    },
  },

  -- formatter: not set — clojure-lsp integrates cljfmt, formats via LSP
  -- linter: not set — clojure-lsp integrates clj-kondo

  mason = { 'clojure-lsp' },

  plugins = {
    -- Conjure: interactive Clojure REPL inside Neovim
    {
      'Olical/conjure',
      ft = { 'clojure' },
      init = function()
        -- Disable Conjure for non-Clojure filetypes
        vim.g['conjure#filetypes'] = { 'clojure' }
      end,
    },
  },
}
