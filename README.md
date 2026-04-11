<div align="center">

  ![logo](https://preview.github.sov710.org/nvim-config/logo.svg?theme=dark)

  # SOV710's Neovim Configuration

  [![Stand With Palestine](https://img.shields.io/badge/Stand_With-Palestine-007A3D?style=flat-square&labelColor=000000)](https://www.un.org/unispal/)
  [![License](https://img.shields.io/github/license/SOV710/nvim-config?style=flat-square&labelColor=1a1b26&color=bb9af7)](LICENSE)
  [![Last Commit](https://img.shields.io/github/last-commit/SOV710/nvim-config?style=flat-square&labelColor=1a1b26&color=7aa2f7)](https://github.com/SOV710/nvim-config/commits/main)
  [![Stars](https://img.shields.io/github/stars/SOV710/nvim-config?style=flat-square&labelColor=1a1b26&color=7aa2f7&logo=github&logoColor=white)](https://github.com/SOV710/nvim-config/stargazers)
  [![Neovim](https://img.shields.io/badge/Neovim-0.11%2B-57A143?style=flat-square&labelColor=1a1b26&logo=neovim&logoColor=white)](https://neovim.io)
  [![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?style=flat-square&labelColor=1a1b26&logo=lua&logoColor=white)](https://www.lua.org)
  [![Gentoo](https://img.shields.io/badge/Gentoo-Linux-54487A?style=flat-square&labelColor=1a1b26&logo=gentoo&logoColor=white)](https://www.gentoo.org)

  [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/SOV710/nvim-config)

</div>

<p align="center">
 <strong>English</strong> | <a href="README_zh.md">中文</a>
</p>

![dashboard-showcase](https://preview.github.sov710.org/nvim-config/neovim-dashboard.png)

## Philosophy

Every editor — VS Code, Emacs, Sublime, JetBrains, Neovim — is a composition of the same eight things:

1. **A plugin manager** that disappears into the background
2. **The editor's own knobs** — `vim.opt`, autocmds, the built-ins
3. **A modal keymap layer** you fully own
4. **A UI with taste** — dashboard, statusline, indent guides, colorscheme
5. **An editing flow** — pairs, file tree, picker, which-key, marks, terminal
6. **First-class language support** — for *every* language, all eight of:
   Tree-sitter, LSP, completion, diagnostics, linter, formatter, DAP, snippets
7. **Version control** that doesn't make you drop to a shell
8. **AI integration** — because it's 2026 and ignoring it is its own statement

This config covers all eight.

## Who this is for

**You're already maintaining your own config.** You're trying to organize 20+ language setups without the whole thing becoming a mess, you've outgrown copy-pasting from someone else's `init.lua`, or you want to see what a from-scratch architecture looks like at some scale. Take whatever's useful.

**Or: you're using LazyVim, NvChad, AstroVim, LunarVim** and you're starting to run into its limits. You can't quite articulate what you want changed, but you know your editor is doing things you don't fully understand. This repo is a from-scratch alternative — opinionated, structured, and small enough to read in full.

If you're brand new to Neovim, start with [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Come back here in six months.

## Contents

### 1. Plugin manager

`lazy.nvim`. Spec files are organized by purpose under `lua/plugins/{ui,editor,langs,git,ai}/`, each directory imported as a unit. Snacks modules live in separate spec files under `lua/plugins/ui/`; lazy.nvim merges them automatically.

### 2. Options

`lua/core/options.lua` — a few dozen lines of `vim.opt`. If something can stay a default, it stays a default.

### 3. Keymaps

All keymaps live under `lua/keymaps/`, organized by feature. Plugin specs never call `vim.keymap.set` directly — they reference keymap files that return plain tables:

```lua
-- lua/plugins/editor/flash.lua
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = require('keymaps.editor.flash'),
}
```

```lua
-- lua/keymaps/editor/flash.lua
return {
  { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,       desc = 'Flash jump' },
  { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash treesitter' },
}
```

All keymaps are greppable from one directory.

A few notable bindings:

- `s` / `S` → flash (overrides native substitute, which I never use)
- `m` → grapple toggle (overrides native mark)
- `'` → grapple menu (overrides native mark jump)
- `+` / `-` → dial (replaces `<C-a>` / `<C-x>`)
- `<leader>g*` → git, `<leader>h*` → hunks, `<leader>a*` → AI

### 4. UI

Tokyo Night colorscheme throughout. The statusline and tabline are a custom heirline build — the tabline integrates `grapple.nvim` so marked files appear directly in the top bar.

| Component | Plugin |
|---|---|
| Colorscheme | `folke/tokyonight.nvim` |
| Statusline + tabline | `rebelot/heirline.nvim` (custom) |
| Messages | `folke/noice.nvim` (messages only; cmdline stays inline at the bottom) |
| Dashboard, indent, scroll, statuscolumn, image | `folke/snacks.nvim` |

> 🚧 Showcase pending: full UI tour — dashboard → editing buffer → grapple-aware tabline (15s GIF)

### 5. Editing flow

| Component | Plugin |
|---|---|
| File explorer | `stevearc/oil.nvim` + `snacks.explorer` |
| Picker | `snacks.picker` (replaces telescope) |
| Motion | `folke/flash.nvim` |
| Surround | `echasnovski/mini.surround` |
| Pairs | `windwp/nvim-autopairs` |
| Text objects | `nvim-treesitter-textobjects` |
| Yank ring | `gbprod/yanky.nvim` |
| Comments | `folke/ts-comments.nvim` (treesitter-aware, replaces `Comment.nvim`) |
| Marks (harpoon-style) | `cbochs/grapple.nvim` |
| Split / join | `Wansmer/treesj` |
| Inc / dec | `monaqa/dial.nvim` |
| Undo tree | `jiaoshijie/undotree` |
| Substitute | `gbprod/substitute.nvim` |
| Project search & replace | `MagicDuck/grug-far.nvim` |
| Terminal | `akinsho/toggleterm.nvim` |
| Which-key | `folke/which-key.nvim` |

> 🚧 Showcase pending: 10s flash.nvim jump GIF
>
> 🚧 Showcase pending: grapple marks appearing in heirline tabline (10s GIF)

### 6. Languages

Each supported language — Rust, Go, Python, TypeScript, Haskell, Lua, C/C++, LaTeX, Fish, SQL, and 20+ others — has a single file under `lua/langs/`. That file declares everything: LSP server config, treesitter parsers, formatters, linters, DAP adapters, snippets, mason packages, file-type detection, and any language-specific plugins.

A typical `lua/langs/<name>.lua`:

```lua
return {
  filetypes = { 'rust' },
  treesitter = { 'rust' },

  lsp = {
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = { command = 'clippy' },
        },
      },
    },
  },

  formatter = 'rustfmt',
  -- linter omitted: rust_analyzer covers it

  dap = {
    adapter        = { codelldb = { type = 'server', port = '${port}', ... } },
    configurations = { rust = { { name = 'Launch', type = 'codelldb', ... } } },
  },

  snippets = function()
    local ls = require('luasnip')
    return {
      ls.snippet('pln', { ls.text_node('println!("'), ls.insert_node(1), ls.text_node('");') }),
    }
  end,

  mason = { 'rust-analyzer', 'codelldb' },

  external_deps = {
    { cmd = 'cargo',   install = 'rustup default stable',          required = true },
    { cmd = 'rustfmt', install = 'rustup component add rustfmt',   required = true },
  },

  plugins = {
    { 'mrcjkb/rustaceanvim', version = '^5', lazy = false },
  },
}
```

`lua/core/language.lua` scans `lua/langs/*.lua` on require and aggregates the declarations into:

| Aggregated as | Consumed by |
|---|---|
| `language.formatters` | `conform.nvim` |
| `language.linters` | `nvim-lint` |
| `language.treesitter` | `nvim-treesitter`'s `ensure_installed` |
| `language.mason` | `mason-tool-installer` |
| `language.dap_adapters`, `language.dap_configurations` | `nvim-dap` |
| `language.snippets` | `LuaSnip` |
| `language.plugins` | injected directly into the lazy.nvim spec |
| LSP servers | registered via the native `vim.lsp.config` / `vim.lsp.enable` API — no `nvim-lspconfig` |

So conform's full spec is:

```lua
opts = {
  formatters_by_ft = require('core.language').formatters,
}
```

> 🚧 Showcase pending: architecture diagram — `lua/langs/*.lua` → `core/language.lua` → fan-out to consumers

**Toggling languages.** Each lang file accepts an `enabled = false` field. When set, the file is dropped during the scan and all downstream consumers (LSP, conform, lint, DAP, snippets, mason) lose it consistently. Useful for isolating which language broke after a plugin update.

**External dependencies.** Many language toolchains can't be managed by mason — `tsgo` builds from source, `ty` ships via PyPI, HLS via GHCup, `fish-lsp` via npm, `sleek` via cargo, and things like `latexindent` and `chktex` come bundled with TeX Live. Each lang file with non-mason deps documents them in two places:

1. **A top-of-file block comment** with the install command and a one-liner to verify it.
2. **A structured `external_deps` field** consumed by `:checkhealth langs`, which reports what's present and what's missing.

```text
:checkhealth langs

==============================================================================
langs:                                          require("langs.health").check()

haskell ~
- OK ghc
- OK cabal
- ERROR haskell-language-server: not found
  - install: ghcup install hls recommended
- WARN haskell-debug-adapter: not found (optional)
  - install: cabal install haskell-debug-adapter haskell-dap ghci-dap

python ~
- OK ty

rust ~
- OK cargo
- OK rustfmt
```

![dashboard-checkhealth-langs](https://preview.github.sov710.org/nvim-config/neovim-checkhealth-langs.png)

**The plumbing per language:**

| Layer | Plugin |
|---|---|
| Tree-sitter | `nvim-treesitter` |
| LSP | `vim.lsp.config` + `vim.lsp.enable` (native, no `nvim-lspconfig`) |
| Completion | `saghen/blink.cmp` (Rust fuzzy matcher) |
| Snippets | `L3MON4D3/LuaSnip` + `friendly-snippets` |
| Formatter | `stevearc/conform.nvim` |
| Linter | `mfussenegger/nvim-lint` |
| Diagnostics | `vim.diagnostic` (native) |
| DAP | `mfussenegger/nvim-dap` + `theHamsta/nvim-dap-virtual-text` |

### 7. Version control

| Component | Plugin | Purpose |
|---|---|---|
| Hunks in the gutter | `lewis6991/gitsigns.nvim` | `]h` / `[h` jump, `<leader>hs` stage hunk, blame line |
| Git commands | `tpope/vim-fugitive` | `:Git status`, commit, push, pull, blame |
| Diff viewer | `sindrets/diffview.nvim` | Visual diffs and file history |
| Open in browser | `Snacks.gitbrowse` | `<leader>gB` to GitHub / Codeberg |

The four tools don't overlap: fugitive handles git commands, diffview handles viewing diffs, gitsigns handles in-buffer hunk operations, gitbrowse opens the web view.

### 8. AI

- **`coder/claudecode.nvim`** — Claude Code bridge over WebSocket MCP. Bindings under `<leader>a*`: toggle the terminal, send the visual selection, accept or deny a diff, switch model, resume a previous session.

No chat overlay or inline code generation. Just a terminal bridge.

## Adding a new language

1. Drop a new file: `lua/langs/<name>.lua`
2. Fill in the fields you need (everything is optional except `filetypes`)
3. Restart Neovim

The aggregator picks it up on the next require; all downstream plugins see the new entries automatically.

To temporarily disable a language without deleting the file, add `enabled = false` at the top and restart. It disappears from all consumers — LSP, formatters, linters, DAP, snippets.

## Quick start

Requirements: **Neovim 0.11+**, Git, a Nerd Font, and a C compiler (for tree-sitter parsers).

```bash
git clone https://github.com/SOV710/nvim-config ~/.config/nvim
nvim
```

`lazy.nvim` bootstraps itself on first launch, installs all plugins, and `mason-tool-installer` pulls every mason-managed package.

Then run:

```vim
:checkhealth langs
```

This reports which non-mason external tools still need installing, with the install command for each.

For per-language install instructions, see [`docs/langs/`](docs/langs/).

## Project layout

```text
init.lua                     -- lazy.nvim bootstrap, top-level setup
lua/
├── core/
│   ├── options.lua
│   ├── language.lua         -- the aggregator
│   └── sysinfo.lua
├── keymaps/                 -- every keymap, organized by feature
│   ├── init.lua
│   ├── editing.lua
│   ├── winbuf.lua
│   ├── snacks.lua
│   ├── which-key.lua
│   ├── editor/
│   ├── git/
│   ├── ai/
│   └── langs/
├── plugins/
│   ├── snacks.lua           -- central Snacks registration
│   ├── ui/
│   ├── editor/
│   ├── langs/               -- completion, format, lint, treesitter, dap, mason, snippets
│   ├── git/
│   └── ai/
└── langs/                   -- one file per language; the source of truth
    ├── rust.lua
    ├── python.lua
    ├── haskell.lua
    └── ...
```

## Acknowledgments

- [folke](https://github.com/folke) for `lazy.nvim`, `snacks.nvim`, `tokyonight.nvim`, `flash.nvim`, `which-key.nvim`, `noice.nvim`, `ts-comments.nvim`, and a large portion of the modern Neovim ecosystem.
- The [LazyVim](https://github.com/LazyVim/LazyVim) source — a useful reference even when rolling your own.
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) for showing that a single readable `init.lua` is the right starting point.
- [TJ DeVries](https://github.com/tjdevries) and the Neovim core team for `vim.lsp.config`, `vim.lsp.enable`, `vim.snippet`, and the native APIs that made the no-`lspconfig` path viable.
- Every plugin author in this stack — `git log` and the `lazy.nvim` lockfile have the full list.

## License

GPL-3.0-or-later. See [LICENSE](./LICENSE).

Every source file carries an `SPDX-License-Identifier` header.
