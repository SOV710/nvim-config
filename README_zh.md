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

## 设计哲学

任何编辑器——VS Code、Emacs、Sublime、JetBrains、Neovim——本质上都是同样八件事的组合。能把这八件事都做好的编辑器，就是世界上最强的编辑器之一。

1. **一个隐形的插件管理器**——你不需要时它根本不存在
2. **编辑器自身的旋钮**——`vim.opt`、autocmd、各种内置选项
3. **一套完全属于你的模态键位语义层**
4. **有审美的 UI**——dashboard、状态栏、缩进线、配色方案
5. **可定制的编辑流**——括号补全、文件树、模糊查找、which-key、文件标记、终端
6. **对每一种语言都有一等公民的支持**，对每种语言都包括下面这八件事：
   Tree-sitter、LSP、补全、诊断、Linter、Formatter、DAP、Snippets
7. **不需要切回 shell 就能完成的版本控制**
8. **AI 集成**——因为这是 2026 年，无视 AI 本身就是一种态度

这份配置就是我对这八层的回答。

## 这份配置写给谁看

**你已经在折腾自己的配置了。** 你正在试图组织 20+ 种语言的支持而不让自己疯掉，你已经厌倦了从别人的 `init.lua` 复制粘贴，或者你想看看一份 from-scratch 的架构在规模化后长什么样而不是塌掉。这里的东西随便拿走。架构本身才是重点。

**或者：你正在用 LazyVim、NvChad、AstroVim、LunarVim**，并且开始感觉到墙的存在。你说不出具体想改什么，但你知道你的编辑器在做一些你并不完全理解的事情。这份仓库就是 distro 之后的下一步——有主见、有结构、小到一个人能把整个项目装进脑子里。

如果你完全是 Neovim 新手，先去看 [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)。半年之后再回来这里。

## 这里有什么

按八层逐个讲。

### 1. 插件管理器

`lazy.nvim`。所有 spec 文件按用途组织在 `lua/plugins/{ui,editor,langs,git,ai}/` 下，每个目录作为一个整体被 import。Snacks 的各个模块拆成独立的 spec 文件，由 lazy.nvim 自动 merge——不存在 800 行的 `snacks.lua`。

### 2. Options

`lua/core/options.lua`——刻意保持简短和无聊。几十行 `vim.opt`。能保持默认的就保持默认。

### 3. Keymaps

整个配置里所有键位都在 `lua/core/keymaps/` 下，按功能组织。Plugin spec **从不**直接调用 `vim.keymap.set`——它们消费 return-table 风格的 keymap 文件：

```lua
-- lua/plugins/editor/flash.lua
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = require('core.keymaps.editor.flash'),  -- 这个 spec 里唯一一行 keymap
}
```

```lua
-- lua/core/keymaps/editor/flash.lua
return {
  { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,       desc = 'Flash jump' },
  { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash treesitter' },
}
```

整个键位面板可以在一个目录里 grep 完。不用在 plugin spec 里到处翻。再也没有"我之前把 `<leader>fg` 绑到哪里了"的瞬间。

几个重点：

- `s` / `S` → flash（覆盖原生 substitute，反正我从不用）
- `m` → grapple toggle（覆盖原生 mark）
- `'` → grapple 菜单（覆盖原生 jump-to-mark）
- `+` / `-` → dial（替代 `<C-a>` / `<C-x>`）
- `<M-c>` → 在 normal 和 insert 模式下切换 blink.cmp 的 Copilot source
- `<leader>g*` → git，`<leader>h*` → hunk，`<leader>a*` → AI

### 4. UI

到处都是 Tokyo Night。状态栏和 tabline 是 heirline 自己搭的——tabline 和 `grapple.nvim` 集成，被 mark 的文件直接出现在顶栏里，而不是另开一个 floating window。

| 生态位 | 选择 |
|---|---|
| Colorscheme | `folke/tokyonight.nvim` |
| Statusline + tabline | `rebelot/heirline.nvim`（自定义） |
| Messages | `folke/noice.nvim`（仅 messages；cmdline 留在底部内联） |
| Dashboard、indent、scroll、statuscolumn、image | `folke/snacks.nvim` |

> 🚧 Showcase pending：完整 UI 巡礼——dashboard → 编辑 buffer → grapple-aware tabline（15 秒 GIF）

### 5. 编辑流

每天写代码的 inner loop。这一层里和 distro 默认值差异最大的部分。

| 生态位 | 选择 |
|---|---|
| 文件浏览器 | `stevearc/oil.nvim` + `snacks.explorer` |
| Picker | `snacks.picker`（替代 telescope） |
| Motion | `folke/flash.nvim` |
| Surround | `echasnovski/mini.surround` |
| 括号补全 | `windwp/nvim-autopairs` |
| 文本对象 | `nvim-treesitter-textobjects` + `mini.ai` |
| Yank ring | `gbprod/yanky.nvim` |
| 注释 | `folke/ts-comments.nvim`（treesitter-aware，替代 `Comment.nvim`） |
| 文件标记（harpoon 风格） | `cbochs/grapple.nvim` |
| Folding | `kevinhwang91/nvim-ufo`（LSP → treesitter fallback） |
| Split / join | `Wansmer/treesj` |
| Inc / dec | `monaqa/dial.nvim` |
| Undo tree | `jiaoshijie/undotree` |
| Substitute | `gbprod/substitute.nvim` |
| 项目级搜索替换 | `MagicDuck/grug-far.nvim` |
| 终端 | `akinsho/toggleterm.nvim` |
| Which-key | `folke/which-key.nvim` |

> 🚧 Showcase pending：10 秒 flash.nvim 跳转 GIF
>
> 🚧 Showcase pending：grapple 标记在 heirline tabline 中显示（10 秒 GIF）

### 6. 语言支持

这是这套架构真正配得上"系统"二字的地方。

这份配置支持的每一种语言——Rust、Go、Python、TypeScript、Haskell、Lua、C/C++、LaTeX、Fish、SQL，外加 20 多种——都活在 `lua/langs/` 下**一个声明式的文件**里。这个文件就是关于这个语言的全部真相：LSP server 配置、treesitter parser、formatter、linter、DAP adapter、snippets、mason 包、文件类型识别、language-specific options，以及任何额外的插件（`rustaceanvim`、`crates.nvim` 之类）。

一个典型的 `lua/langs/<name>.lua` 长这样：

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

这就是 *全部* 声明。没有第二个文件需要更新，没有 `formatters_by_ft` 表需要记得去 extend，没有独立的 mason `ensure_installed` 列表。

`lua/core/language.lua` 在 require 时扫描 `lua/langs/*.lua`，把每种语言的声明聚合成：

| 聚合后的字段 | 谁在消费 |
|---|---|
| `language.formatters` | `conform.nvim` |
| `language.linters` | `nvim-lint` |
| `language.treesitter` | `nvim-treesitter` 的 `ensure_installed` |
| `language.mason` | `mason-tool-installer` |
| `language.dap_adapters`、`language.dap_configurations` | `nvim-dap` |
| `language.snippets` | `LuaSnip` |
| `language.plugins` | 直接 inject 进 lazy.nvim 的 spec |
| LSP servers | 通过原生 `vim.lsp.config` / `vim.lsp.enable` 注册——**不经过 `nvim-lspconfig`** |

所以 conform 的整个 spec 长这样：

```lua
opts = {
  formatters_by_ft = require('core.language').formatters,
}
```

没了。明天想加 Kotlin 就是丢一个 `lua/langs/kotlin.lua` 进去，重启 Neovim。其他任何文件都不需要动。

> 🚧 Showcase pending：架构图——`lua/langs/*.lua` → `core/language.lua` → 扇出到各个消费者

**开关单种语言。** 每个 lang 文件都接受一个 `enabled = false` 开关。一旦设为 false，这个文件在扫描阶段就被静默 drop 掉，*所有*下游消费者（LSP、conform、lint、DAP、snippets、mason）都同步看不到它。这是隔离"插件更新后哪种语言挂了"的杀手锏——翻一个布尔值，重启，这种语言从整个 stack 里消失。

**外部依赖。** 这份配置里至少一半的语言工具链是 mason 管不了的——`tsgo` 要从源码编译，`ty` 走 PyPI，HLS 走 GHCup，`fish-lsp` 走 npm，`sleek` 走 cargo，再加上 `latexindent`、`chktex` 这种和 TeX Live 捆绑的。每一个有非 mason 依赖的 lang 文件都在两个地方记录了这些依赖：

1. **文件顶部的块注释**，写明要装什么、怎么装、怎么验证装好了。打开文件第一眼就看到。
2. **结构化的 `external_deps` 字段**，由 `:checkhealth langs` 消费——Neovim 原生的 health 框架会报告哪些依赖在、哪些缺，并把安装命令直接打在屏幕上。

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

> 🚧 Showcase pending：`:checkhealth langs` 截图

**每种语言的下层管线**，列全：

| 层级 | 插件 |
|---|---|
| Tree-sitter | `nvim-treesitter` |
| LSP | `vim.lsp.config` + `vim.lsp.enable`（原生，不走 `nvim-lspconfig`） |
| 补全 | `saghen/blink.cmp`（Rust 写的 fuzzy matcher） |
| Snippets | `L3MON4D3/LuaSnip` + `friendly-snippets` |
| Formatter | `stevearc/conform.nvim` |
| Linter | `mfussenegger/nvim-lint` |
| 诊断 | `vim.diagnostic`（原生） |
| DAP | `mfussenegger/nvim-dap` + `theHamsta/nvim-dap-virtual-text` |

### 7. 版本控制

| 生态位 | 选择 | 用来做什么 |
|---|---|---|
| 边栏 hunk 提示 | `lewis6991/gitsigns.nvim` | `]h` / `[h` 跳转、`<leader>hs` stage hunk、行 blame |
| Git 命令 | `tpope/vim-fugitive` | `:Git status`、commit、push、pull、blame |
| Diff 浏览 | `sindrets/diffview.nvim` | 所有可视化 diff 和文件历史 |
| 浏览器打开 | `Snacks.gitbrowse` | `<leader>gB` 打开 GitHub / Codeberg |

这四个工具的职责故意不重叠。Fugitive 管*命令*；diffview 管*看*差异；gitsigns 管*在 buffer 里操作 hunk*；gitbrowse 管打开*网页*。四个工具，四个不同的动词。任何键位按下去，我都不会被"哪个插件跳出来了"惊吓到。

### 8. AI

两个集成，都刻意保持小。

- **`coder/claudecode.nvim`**——官方的 Claude Code 桥接，走 WebSocket MCP。让我能把这个编辑器交给 Claude Code 当前端用。
- **`zbirenbaum/copilot.lua`** 以 headless 模式作为 LSP backend 跑，由 **`fang2hou/blink-copilot`** 暴露成 `blink.cmp` 的一个 source。Copilot 的建议作为 ghost text 出现在和 LSP/snippets 同一个补全菜单里——不是另开一套打架的 UI。

`<M-c>` 一键开关 Copilot source，不需要 unload 整个插件。我想要建议的时候它在；我不想要的时候它彻底闭嘴。

不用 `avante.nvim`，不用任何"我来帮你写这个函数"的自动弹窗式对话覆盖层。AI 是辅助；不是司机。

> 🚧 Showcase pending：blink.cmp 菜单内嵌 Copilot ghost text（截图）

## 添加一种新语言

三步，没有任何一步会动到 `lua/langs/` 之外的文件：

1. 新建一个文件：`lua/langs/<name>.lua`
2. 填上你实际需要的字段（除了 `filetypes` 之外都是可选的）
3. 重启 Neovim

就这些。聚合器在下次 require 时把它捡起来，所有消费 `language.*` 的下游插件自动看到新条目。没有 `ensure_installed` 列表要更新。没有 `formatters_by_ft` 要 extend。没有 mason 包列表要扩。

要临时禁用一种语言而不删文件：在文件顶部加 `enabled = false`，重启。从 LSP、conform、mason、treesitter、DAP、snippets 所有消费者那里全部消失。

## 上手

要求：**Neovim 0.11+**、Git、一个 Nerd Font，以及一个 C 编译器（用来编 tree-sitter parser）。

```bash
git clone https://github.com/SOV710/nvim-config ~/.config/nvim
nvim
```

`lazy.nvim` 会自举安装自己，装好所有插件，`mason-tool-installer` 会在第一次启动时把所有 mason 管理的包都拉下来。

然后：

```vim
:checkhealth langs
```

这会告诉你**哪些非 mason 的外部工具**还需要装（工具链、来自其他包管理器的 LSP、语言专用 debugger 等等），并且对每个缺失的工具给出确切的安装命令。读输出，装缺的，重启，搞定。

完整的逐语言安装指南在 [`docs/langs/`](docs/langs/)。

## 项目结构

```text
lua/
├── init.lua                 -- lazy.nvim 自举,顶层 setup
├── core/
│   ├── options.lua
│   ├── language.lua         -- 聚合器
│   ├── autocmds.lua
│   └── keymaps/             -- 全部键位,按功能组织
│       ├── editing.lua
│       ├── winbuf.lua
│       ├── editor/
│       ├── git/
│       └── ai/
├── plugins/
│   ├── snacks.lua           -- 中心 Snacks 注册
│   ├── ui/
│   ├── editor/
│   ├── langs/               -- conform、blink、treesitter、dap、lint 等
│   ├── git/
│   └── ai/
└── langs/                   -- 每种语言一个文件;真相之源
    ├── rust.lua
    ├── python.lua
    ├── haskell.lua
    └── ...
```

## 致谢

- [folke](https://github.com/folke)，贡献了 `lazy.nvim`、`snacks.nvim`、`tokyonight.nvim`、`flash.nvim`、`which-key.nvim`、`noice.nvim`、`ts-comments.nvim`，以及现代 Neovim 生态里大约一半的东西。
- [LazyVim](https://github.com/LazyVim/LazyVim) 的源码——即使你已经决定自己从零搭，它仍然是无价的参考。
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)——它证明了"一份可读的 `init.lua`"是正确的起点。
- [TJ DeVries](https://github.com/tjdevries) 和 Neovim 核心团队，因为 `vim.lsp.config`、`vim.lsp.enable`、`vim.snippet`，以及那一长串让"无 lspconfig、无 Mason"路线成为可能的原生 API。
- 这套 stack 里每一位插件作者。具体一一列出太长了——`git log` 和 `lazy.nvim` 的 lockfile 是完整的 credit 列表。

## 许可证

GPL-3.0-or-later。完整文本见 [LICENSE](./LICENSE)。

每个源文件都带有 `SPDX-License-Identifier` 头。
