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
 <a href="README.md">English</a> | <strong>中文</strong>
</p>

![dashboard-showcase](https://preview.github.sov710.org/nvim-config/neovim-dashboard.png)

> [!WARNING]
> **Neovim 0.12 迁移计划中。** `plenary.nvim` 将于 2026-06-30 停止维护并 archive，而本配置里的 `undotree` 依赖 plenary。所以本项目会尽快迁移到 Neovim 0.12。
>
> 阻塞点是 `nvim-treesitter`：它与 0.12 不兼容。Neovim 0.12 虽然把 treesitter 的全部功能都集成进了 core，但仍然 lack a treesitter installer。我会等社区出现 treesitter installer 的解决方案，然后在恰当的时机把整个配置升级到 0.12。
>
> **如果你现在正在用 Neovim 0.12，不要使用这份配置。**

## 设计哲学

任何编辑器——VS Code、Emacs、Sublime、JetBrains、Neovim——本质上都是同样八件事的组合：

1. **一个隐形的插件管理器**——你不需要时它根本不存在
2. **编辑器自身的旋钮**——`vim.opt`、autocmd、各种内置选项
3. **一套完全属于你的模态键位层**
4. **有审美的 UI**——dashboard、状态栏、缩进线、配色方案
5. **编辑流**——括号补全、文件树、模糊查找、which-key、文件标记、终端
6. **对每一种语言的完整支持**，包括：
   Tree-sitter、LSP、补全、诊断、Linter、Formatter、DAP、Snippets
7. **不需要切回 shell 就能完成的版本控制**
8. **AI 集成**——因为这是 2026 年，无视 AI 本身就是一种态度

这份配置覆盖了这八层。

## 写给谁看

**你已经在维护自己的配置了。** 你在试图组织 20+ 种语言的支持而不让整件事变成一团乱麻，你已经不想再从别人的 `init.lua` 复制粘贴，或者你想看看一份 from-scratch 的架构在有一定规模时长什么样。

**或者：你正在用 LazyVim、NvChad、AstroVim、LunarVim**，并且开始感觉到它的边界。你说不出具体想改什么，但你知道你的编辑器在做一些你不完全理解的事情。这份 repo 是一个从零开始的替代方案。

如果你完全是 Neovim 新手，先去看 [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)。半年之后再回来这里。

## Quick Start

依赖：**Neovim 0.11+**、Git、一个 Nerd Font，以及一个 C 编译器（用来编 tree-sitter parser）。

```bash
git clone https://github.com/SOV710/nvim-config ~/.config/nvim
nvim
```

首次启动时 `lazy.nvim` 自举并安装所有插件，`mason-tool-installer` 拉取所有 mason 管理的包。

然后运行：

```vim
:checkhealth langs
```

输出会列出哪些非 mason 外部工具还需要安装，并给出每个工具的安装命令。

## Contents

### 1. Plugin manager

`lazy.nvim`。所有 spec 文件按用途组织在 `lua/plugins/{ui,editor,langs,git,ai}/` 下，每个目录作为一个整体被 import。Snacks 的各个模块拆成独立的 spec 文件放在 `lua/plugins/ui/` 下，由 lazy.nvim 自动 merge。

### 2. Options

`lua/core/options.lua`——几十行 `vim.opt`。能保持默认的就保持默认。

### 3. Keymaps

所有键位都在 `lua/keymaps/` 下，按功能组织。Plugin spec 不直接调用 `vim.keymap.set`——它们引用返回普通 table 的 keymap 文件：

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

所有键位都可以在一个目录里 grep 到。

几个重点绑定：

- `s` / `S` → flash（覆盖原生 substitute，反正我从不用）
- `m` → grapple toggle（覆盖原生 mark）
- `'` → grapple 菜单（覆盖原生 jump-to-mark）
- `+` / `-` → dial（替代 `<C-a>` / `<C-x>`）
- `<leader>g*` → git，`<leader>h*` → hunk，`<leader>a*` → AI

### 4. UI

Tokyo Night 统一配色。状态栏和 tabline 是用 heirline 自己搭的——tabline 和 `grapple.nvim` 集成，被标记的文件直接出现在顶栏里。

| 组件 | 插件 |
|---|---|
| Colorscheme | `folke/tokyonight.nvim` |
| Statusline + tabline | `rebelot/heirline.nvim`（custom） |
| Messages | `folke/noice.nvim`（仅 messages；cmdline 留在底部内联） |
| Dashboard、indent、scroll、statuscolumn、image | `folke/snacks.nvim` |
| 模式感知的 cursorline | `mvllow/modes.nvim` |
| 颜色字面量（hex、CSS、Tailwind） | `brenoprata10/nvim-highlight-colors` |

> 🚧 Showcase pending：完整 UI 巡礼——dashboard → 编辑 buffer → grapple-aware tabline（15 秒 GIF）

### 5. 编辑流

| 组件 | 插件 |
|---|---|
| File explorer | `stevearc/oil.nvim` + `snacks.explorer` |
| Picker | `snacks.picker`（替代 telescope） |
| Motion | `folke/flash.nvim` |
| Surround | `echasnovski/mini.surround` |
| 括号补全 | `windwp/nvim-autopairs` |
| 括号 / tag 匹配 | `andymass/vim-matchup` |
| 文本对象 | `nvim-treesitter-textobjects` |
| Yank ring | `gbprod/yanky.nvim` |
| 注释 | `folke/ts-comments.nvim`（treesitter-aware） |
| 文件标记（harpoon style） | `cbochs/grapple.nvim` |
| LSP reference 跳转 | `snacks.words` |
| Scratch buffer | `snacks.scratch` |
| Split / join | `Wansmer/treesj` |
| Inc / dec | `monaqa/dial.nvim` |
| Undo tree | `jiaoshijie/undotree` |
| Substitute | `gbprod/substitute.nvim` |
| 项目级搜索替换 | `MagicDuck/grug-far.nvim` |
| Terminal | `akinsho/toggleterm.nvim` |
| Which-key | `folke/which-key.nvim` |

> 🚧 Showcase pending：10 秒 flash.nvim 跳转 GIF
>
> 🚧 Showcase pending：grapple 标记在 heirline tabline 中显示（10 秒 GIF）

### 6. 语言支持

每种支持的语言——Rust、Go、Python、TypeScript、Haskell、Lua、C/C++、LaTeX、Fish、SQL，外加 20 多种——在 `lua/langs/` 下对应一个文件。这个文件包含关于该语言的全部声明：LSP server 配置、treesitter parser、formatter、linter、DAP adapter、snippets、mason 包、文件类型识别，以及任何语言专属插件。

一个典型的 `lua/langs/<name>.lua`：

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
  -- linter 省略：rust_analyzer 已经覆盖

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

`lua/core/language.lua` 在 require 时扫描 `lua/langs/*.lua`，把各语言的声明聚合成：

| 聚合后的字段 | 谁在消费 |
|---|---|
| `language.formatters` | `conform.nvim` |
| `language.linters` | `nvim-lint` |
| `language.treesitter` | `nvim-treesitter` 的 `ensure_installed` |
| `language.mason` | `mason-tool-installer` |
| `language.dap_adapters`、`language.dap_configurations` | `nvim-dap` |
| `language.snippets` | `LuaSnip` |
| `language.plugins` | 直接 inject 进 lazy.nvim 的 spec |
| LSP servers | 通过原生 `vim.lsp.config` / `vim.lsp.enable` 注册，不经过 `nvim-lspconfig` |

所以 conform 的整个 spec 是：

```lua
opts = {
  formatters_by_ft = require('core.language').formatters,
}
```

> 🚧 Showcase pending：架构图——`lua/langs/*.lua` → `core/language.lua` → 扇出到各个消费者

**开关单种语言。** 每个 lang 文件都接受 `enabled = false` 字段。设置后，该文件在扫描阶段被跳过，所有下游消费者（LSP、conform、lint、DAP、snippets、mason）同步看不到它。当某次插件更新后某种语言出了问题，用这个方式可以快速隔离。

**外部依赖。** 很多语言工具链不能由 mason 管理——`tsgo` 要从源码编译，`ty` 走 PyPI，HLS 走 GHCup，`fish-lsp` 走 npm，`sleek` 走 cargo，`latexindent`、`chktex` 随 TeX Live 一起安装。每个有非 mason 依赖的 lang 文件都在两处记录这些依赖：

1. **文件顶部的块注释**，写明安装命令和验证方式。
2. **结构化的 `external_deps` 字段**，由 `:checkhealth langs` 消费——报告哪些依赖在、哪些缺，并给出安装命令。

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

**每种语言的下层管线：**

| 层级 | 插件 |
|---|---|
| Package manager | `williamboman/mason.nvim` + `WhoIsSethDaniel/mason-tool-installer.nvim` |
| Tree-sitter | `nvim-treesitter` |
| LSP | `vim.lsp.config` + `vim.lsp.enable`（原生，不走 `nvim-lspconfig`） |
| 补全 | `saghen/blink.cmp`（Rust 写的 fuzzy matcher） |
| Snippets | `L3MON4D3/LuaSnip` + `friendly-snippets` |
| Formatter | `stevearc/conform.nvim` |
| Linter | `mfussenegger/nvim-lint` |
| 诊断 | `vim.diagnostic`（原生）+ `rachartier/tiny-inline-diagnostic.nvim` |
| 诊断列表 | `folke/trouble.nvim` |
| DAP | `mfussenegger/nvim-dap` + `theHamsta/nvim-dap-virtual-text` |

**语言专属插件。** 通过每个 lang 文件的 `plugins` 字段注入到 lazy.nvim 的 spec 里：

| 语言 | 插件 |
|---|---|
| Rust | `mrcjkb/rustaceanvim`、`Saecki/crates.nvim` |
| Haskell | `mrcjkb/haskell-tools.nvim` |
| C / C++ | `p00f/clangd_extensions.nvim` |
| LaTeX | `lervag/vimtex` |
| Clojure / Lisp | `Olical/conjure` |
| Markdown | `MeanderingProgrammer/render-markdown.nvim` |
| CSV / TSV | `cameron-wags/rainbow_csv.nvim` |
| JSON / YAML | `b0o/SchemaStore.nvim` |
| Ghostty | `bezhermoso/tree-sitter-ghostty` |

### 7. 版本控制

| 组件 | 插件 | 用来做什么 |
|---|---|---|
| 边栏 hunk 提示 | `lewis6991/gitsigns.nvim` | `]h` / `[h` 跳转、`<leader>hs` stage hunk、行 blame |
| Git 命令 | `tpope/vim-fugitive` | `:Git status`、commit、push、pull、blame |
| Diff 浏览 | `sindrets/diffview.nvim` | 可视化 diff 和文件历史 |
| 浏览器打开 | `Snacks.gitbrowse` | `<leader>gB` 打开 GitHub / Codeberg |

四个工具职责不重叠：fugitive 管命令，diffview 管看差异，gitsigns 管在 buffer 里操作 hunk，gitbrowse 管打开网页。

实际用起来，这一节里我最常打开的其实是 `toggleterm`。大部分 git 操作——stage、commit、rebase、push——都在 shell buffer 里完成。上面四个插件只用来补终端里做起来别扭的那几件事：inline blame、当前 buffer 里的 hunk 跳转、并排 diff，以及在浏览器里打开某次提交。

### 8. AI

- **`coder/claudecode.nvim`**——Claude Code 的 WebSocket MCP bridge。`<leader>a*` 下有一组绑定：打开 terminal、发送 visual 选区、接受或拒绝 diff、切换 model、恢复上一次的 session。

没有 chat overlay，没有 inline 代码生成。只是一个 terminal bridge。

说实话这一层我其实一个都不想装。现在的 coding agent——Claude Code、Codex——都在往独立 TUI 的方向走，自带 chatbox，不需要 editor 参与。这也是我选 `claudecode.nvim` 而不是 `avante.nvim` 的原因：我没想在 Neovim 里重新搭一个 Cursor 风格的体验。装它唯一的理由是偶尔想把当前 buffer 或选区作为 context 交给 Claude Code；而且比起 sidebar，我更愿意把它作为 float window 挂在编辑器上。

## 添加一种新语言

1. 新建 `lua/langs/<name>.lua`
2. 填上需要的字段（除 `filetypes` 外都是可选的）
3. 重启 Neovim

聚合器在下次 require 时自动捡起新文件，所有下游插件看到新条目。

临时禁用一种语言而不删文件：在文件顶部加 `enabled = false`，重启。该语言从所有消费者——LSP、formatter、linter、DAP、snippets——中消失。

## 删除一种语言

1. 删掉 `lua/langs/<name>.lua`——或者只是把 `mason` 字段里不想要的那项去掉。
2. 重启 Neovim。
3. 跑 `:checkhealth langs`。`langs.mason` 那一节会把所有还装着但已经不在声明里的 mason 包标出来。
4. 用 `:MasonUninstall <pkg>` 精确卸载，或 `:MasonToolsClean` 一次清掉所有孤儿包。`:MasonToolsClean` 同时也会把当前被 `enabled = false` 的 lang 对应的包一起删掉，所以如果有禁用中的 lang，优先用 per-package 的 `:MasonUninstall`。

## 项目结构

```text
init.lua                     -- lazy.nvim 自举,顶层 setup
lua/
├── core/
│   ├── options.lua
│   ├── language.lua         -- 聚合器
│   └── sysinfo.lua
├── keymaps/                 -- 全部键位,按功能组织
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
│   ├── snacks.lua           -- 中心 Snacks 注册
│   ├── ui/
│   ├── editor/
│   ├── langs/               -- completion、format、lint、treesitter、dap、mason、snippets
│   ├── git/
│   └── ai/
└── langs/                   -- 每种语言一个文件；声明的唯一来源
    ├── rust.lua
    ├── python.lua
    ├── haskell.lua
    └── ...
```

## License

GPL-3.0-or-later。完整文本见 [LICENSE](./LICENSE)。

每个源文件都带有 `SPDX-License-Identifier` 头。
