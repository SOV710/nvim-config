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

Every editor — VS Code, Emacs, Sublime, JetBrains, Neovim — is, at the bottom, a composition of the same eight things. The editor that nails all eight is one of the strongest editors in existence.

1. **A plugin manager** that disappears into the background
2. **The editor's own knobs** — `vim.opt`, autocmds, the built-ins
3. **A modal keymap layer** you fully own
4. **A UI with taste** — dashboard, statusline, indent guides, colorscheme
5. **An editing flow** — pairs, file tree, picker, which-key, marks, terminal
6. **First-class language support** — for *every* language, all eight of:
   Tree-sitter, LSP, completion, diagnostics, linter, formatter, DAP, snippets
7. **Version control** that doesn't make you drop to a shell
8. **AI integration** — because it's 2026 and ignoring it is its own statement

This config is my answer to those eight layers.

## Who this is for

**You're already deep in your own config.** You're trying to organize 20+ language setups without losing your mind, you've outgrown copy-pasting from someone else's `init.lua`, or you want to see what a from-scratch architecture looks like that doesn't collapse at scale. Steal whatever's useful here. The architecture is the point.

**Or: you're using LazyVim, NvChad, AstroVim, LunarVim** and you're starting to feel the walls. You can't quite articulate what you want changed, but you know your editor is doing things you don't fully understand. This repo is what comes after the distro — opinionated, structured, and small enough that one person can hold the whole thing in their head.

If you're brand new to Neovim, start with [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Come back here in six months.

## What's in the box

The stack, layer by layer.

### 1. The plugin manager

`lazy.nvim`. Spec files are organized by purpose under `lua/plugins/{ui,editor,langs,git,ai}/`, each directory imported as a unit. Snacks modules are split into separate spec files and lazy.nvim merges them automatically — no 800-line `snacks.lua`.

### 2. Options

`lua/core/options.lua` — small and boring on purpose. A few dozen lines of `vim.opt`. If something can stay a default, it stays a default.

### 3. Keymaps

Every keymap in the config lives under `lua/core/keymaps/`, organized by feature. Plugin specs **never** call `vim.keymap.set` directly — they consume return-table keymap files:

```lua
-- lua/plugins/editor/flash.lua
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = require('core.keymaps.editor.flash'),  -- the only keymap line in this spec
}
```

```lua
-- lua/core/keymaps/editor/flash.lua
return {
  { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,       desc = 'Flash jump' },
  { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash treesitter' },
}
```

The whole keymap surface is greppable in one directory. No hunting through plugin specs. No more "where did I bind `<leader>fg` again."

A few points:

- `s` / `S` → flash (overrides native substitute, which I never use)
- `m` → grapple toggle (overrides native mark)
- `'` → grapple menu (overrides native mark jump)
- `+` / `-` → dial (replaces `<C-a>` / `<C-x>`)
- `<M-c>` → toggle Copilot source in blink.cmp, normal and insert mode
- `<leader>g*` → git, `<leader>h*` → hunks, `<leader>a*` → AI

### 4. UI

Tokyo Night. The status line and tabline are a custom heirline build — the tabline integrates `grapple.nvim` so marked files appear directly in the top bar instead of a separate floating window.

| Niche | Choice |
|---|---|
| Colorscheme | `folke/tokyonight.nvim` |
| Statusline + tabline | `rebelot/heirline.nvim` (custom) |
| Messages | `folke/noice.nvim` (messages only; cmdline stays inline at the bottom) |
| Dashboard, indent, scroll, statuscolumn, image | `folke/snacks.nvim` |

> 🚧 Showcase pending: full UI tour — dashboard → editing buffer → grapple-aware tabline (15s GIF)

### 5. Editing flow

The everyday loop. This is the layer where the choices diverge most from distro defaults.

| Niche | Choice |
|---|---|
| File explorer | `stevearc/oil.nvim` + `snacks.explorer` |
| Picker | `snacks.picker` (replaces telescope) |
| Motion | `folke/flash.nvim` |
| Surround | `echasnovski/mini.surround` |
| Pairs | `windwp/nvim-autopairs` |
| Text objects | `nvim-treesitter-textobjects` + `mini.ai` |
| Yank ring | `gbprod/yanky.nvim` |
| Comments | `folke/ts-comments.nvim` (treesitter-aware, replaces `Comment.nvim`) |
| Marks (harpoon-style) | `cbochs/grapple.nvim` |
| Folding | `kevinhwang91/nvim-ufo` (LSP → treesitter fallback) |
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

This is where the architecture earns its name.

Every language this config supports — Rust, Go, Python, TypeScript, Haskell, Lua, C/C++, LaTeX, Fish, SQL, and 20+ others — lives in **a single declarative file** under `lua/langs/`. That file is the source of truth for everything: LSP server config, treesitter parsers, formatters, linters, DAP adapters, snippets, mason packages, file-type detection, language-specific options, and any extra plugins (`rustaceanvim`, `crates.nvim`, etc.).

A typical `lua/langs/<name>.lua` looks like this:

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

That's the *whole* declaration. There's no second file to update, no `formatters_by_ft` table to remember to extend, no separate mason `ensure_installed` list.

`lua/core/language.lua` scans `lua/langs/*.lua` on require and aggregates the per-language declarations into:

| Aggregated as | Consumed by |
|---|---|
| `language.formatters` | `conform.nvim` |
| `language.linters` | `nvim-lint` |
| `language.treesitter` | `nvim-treesitter`'s `ensure_installed` |
| `language.mason` | `mason-tool-installer` |
| `language.dap_adapters`, `language.dap_configurations` | `nvim-dap` |
| `language.snippets` | `LuaSnip` |
| `language.plugins` | injected directly into the lazy.nvim spec |
| LSP servers | registered via the native `vim.lsp.config` / `vim.lsp.enable` API — **no `nvim-lspconfig` middleware** |

So conform's spec, in full:

```lua
opts = {
  formatters_by_ft = require('core.language').formatters,
}
```

That's it. Adding Kotlin tomorrow means dropping `lua/langs/kotlin.lua` and restarting Neovim. No other file changes anywhere.

> 🚧 Showcase pending: architecture diagram — `lua/langs/*.lua` → `core/language.lua` → fan-out to consumers

**Toggling languages.** Every lang file accepts an `enabled = false` switch. When set, the file is silently dropped during the scan, and *every* downstream consumer (LSP, conform, lint, DAP, snippets, mason) loses it consistently. This is the kill switch for isolating which language broke after a plugin update — flip one boolean, restart, the language vanishes from the entire stack.

**External dependencies.** Half the language toolchains in this config can't be managed by mason — `tsgo` builds from source, `ty` ships via PyPI, HLS via GHCup, `fish-lsp` via npm, `sleek` via cargo, plus things like `latexindent` and `chktex` that come bundled with TeX Live. Every lang file with non-mason deps documents them in two places:

1. **A top-of-file block comment** describing what to install, the install command, and a one-liner to verify it. You see it the moment you open the file.
2. **A structured `external_deps` field** consumed by `:checkhealth langs` — Neovim's native health framework reports which deps are present and which are missing, with the install command inline.

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

**The plumbing per language**, for completeness:

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

| Niche | Choice | What it's for |
|---|---|---|
| Hunks in the gutter | `lewis6991/gitsigns.nvim` | `]h` / `[h` jump, `<leader>hs` stage hunk, blame line |
| Git commands | `tpope/vim-fugitive` | `:Git status`, commit, push, pull, blame |
| Diff viewer | `sindrets/diffview.nvim` | All visual diffs and file history |
| Open in browser | `Snacks.gitbrowse` | `<leader>gB` to GitHub / Codeberg |

These don't overlap on purpose. Fugitive is for *commands*; diffview is for *seeing* diffs; gitsigns is for *in-buffer hunk operations*; gitbrowse opens the *web view*. Four tools, four distinct verbs. No keymap I press will ever surprise me about which one shows up.

### 8. AI

Two integrations, kept deliberately minimal.

- **`coder/claudecode.nvim`** — official Claude Code bridge over WebSocket MCP. Lets me hand the editor to Claude Code as a frontend.
- **`zbirenbaum/copilot.lua`** running headless as an LSP backend, surfaced via **`fang2hou/blink-copilot`** as a `blink.cmp` source. Copilot suggestions appear as ghost text *inside* the same completion menu as LSP and snippets — not as a separate competing UI.

`<M-c>` toggles the Copilot source on or off without unloading the plugin. When I want suggestions, they're there. When I don't, they're silent.

No `avante.nvim`, no auto-prompted "let me write this function for you" chat overlay. The AI assists; it doesn't drive.

> 🚧 Showcase pending: blink.cmp menu with Copilot ghost text inline (screenshot)

## Adding a new language

Three steps, none of which touch any file outside `lua/langs/`:

1. Drop a new file: `lua/langs/<name>.lua`
2. Fill in the fields you actually need (everything is optional except `filetypes`)
3. Restart Neovim

That's all. The aggregator picks it up on the next require, and every downstream plugin that consumes `language.*` sees the new entries automatically. No `ensure_installed` list to update. No `formatters_by_ft` to extend. No mason package list to grow.

To temporarily disable a language without deleting the file: add `enabled = false` at the top. Restart. Gone — from LSP, conform, mason, treesitter, DAP, snippets, every consumer.

## Quick start

Requirements: **Neovim 0.11+**, Git, a Nerd Font, and a C compiler (for tree-sitter parsers).

```bash
git clone https://github.com/SOV710/nvim-config ~/.config/nvim
nvim
```

`lazy.nvim` will bootstrap itself, install plugins, and `mason-tool-installer` will pull every mason-managed package on first launch.

Then:

```vim
:checkhealth langs
```

This tells you which **non-mason external tools** still need installing (toolchains, LSPs from package managers, language-specific debuggers, etc.), with the exact install command for each. Read the output, install the missing ones, restart, done.

For full per-language install instructions, see [`docs/langs/`](docs/langs/).

## Project layout

```text
lua/
├── init.lua                 -- lazy.nvim bootstrap, top-level setup
├── core/
│   ├── options.lua
│   ├── language.lua         -- the aggregator
│   ├── autocmds.lua
│   └── keymaps/             -- every keymap, organized by feature
│       ├── editing.lua
│       ├── winbuf.lua
│       ├── editor/
│       ├── git/
│       └── ai/
├── plugins/
│   ├── snacks.lua           -- central Snacks registration
│   ├── ui/
│   ├── editor/
│   ├── langs/               -- conform, blink, treesitter, dap, lint, etc.
│   ├── git/
│   └── ai/
└── langs/                   -- one file per language; the source of truth
    ├── rust.lua
    ├── python.lua
    ├── haskell.lua
    └── ...
```

## Acknowledgments

- [folke](https://github.com/folke) for `lazy.nvim`, `snacks.nvim`, `tokyonight.nvim`, `flash.nvim`, `which-key.nvim`, `noice.nvim`, `ts-comments.nvim`, and roughly half the modern Neovim ecosystem.
- The [LazyVim](https://github.com/LazyVim/LazyVim) source — invaluable as a reference even when you've decided to roll your own.
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) for the proof that a single readable `init.lua` is the right starting point.
- [TJ DeVries](https://github.com/tjdevries) and the Neovim core team for `vim.lsp.config`, `vim.lsp.enable`, `vim.snippet`, and the long parade of native APIs that made the no-`lspconfig`, no-Mason path possible.
- Every plugin author whose work is in this stack. There are too many to list individually — `git log` and the `lazy.nvim` lockfile have the full credits.

## License

GPL-3.0-or-later. See [LICENSE](./LICENSE).

Every source file carries an `SPDX-License-Identifier` header.
