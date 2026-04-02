# External Dependencies

Tools required by `lua/langs/*.lua` that are **not managed by mason.nvim**.
Install these manually before enabling the corresponding language.

## Language Toolchains

These are language runtimes/compilers that mason packages depend on.
Mason can install *tools* but not the languages themselves.

| Language | Package | Install (Gentoo) |
|----------|---------|------------------|
| Rust | `rustup`, `cargo` | `emerge dev-lang/rust-bin` or `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| Go | `go` | `emerge dev-lang/go` |
| Node.js | `node`, `npm` | `emerge net-libs/nodejs` |
| Python | `python`, `pip`, `uv` | `emerge dev-lang/python` + `pip install uv` |
| GHC | `ghc`, `cabal` | via GHCup (see Haskell section) |
| TeX | `texlive` | `emerge app-text/texlive` |
| PowerShell | `pwsh` | `emerge app-shells/pwsh-bin` (from GURU overlay) |
| Fish | `fish` | `emerge app-shells/fish` |

## LSP Servers

| Server | Used by | Install |
|--------|---------|---------|
| `tsgo` | `typescript.lua` | `git clone --recurse-submodules https://github.com/microsoft/typescript-go && cd typescript-go && go build ./cmd/tsgo` — place binary in `$PATH` |
| `ty` | `python.lua` | `uv tool install ty` |
| `haskell-language-server` | `haskell.lua` | `ghcup install hls` — must match GHC version |
| `cl-lsp` | `common-lisp.lua` | `ros install lem-project/cl-lsp` or via Quicklisp |
| `fish-lsp` | `fish.lua` | `npm install -g fish-lsp` |

## DAP Adapters

| Adapter | Used by | Install |
|---------|---------|---------|
| `haskell-debug-adapter` | `haskell.lua` | `cabal install haskell-debug-adapter haskell-dap ghci-dap` |

## Formatters

| Formatter | Used by | Install |
|-----------|---------|---------|
| `sleek` | `sql.lua` | `cargo install sleek` |
| `fish_indent` | `fish.lua` | Bundled with Fish shell — no separate install |
| `latexindent` | `latex.lua` | Bundled with TeX Live (`texlive-latexextra`) |

## Linters

| Linter | Used by | Install |
|--------|---------|---------|
| `chktex` | `latex.lua` | Bundled with TeX Live |

## Haskell (GHCup)

GHCup manages the entire Haskell toolchain. HLS versions are tightly coupled
to GHC versions — mason cannot handle this dependency.

```bash
# Install GHCup
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Install toolchain
ghcup install ghc recommended
ghcup install cabal recommended
ghcup install hls recommended
ghcup install stack recommended  # optional, if you use stack

# Install DAP (after GHC is set up)
cabal install haskell-debug-adapter haskell-dap ghci-dap
```

## Mason Fallbacks

These tools *should* be in mason but may fail to install on some systems.
If mason fails, install manually:

| Tool | Used by | Fallback install |
|------|---------|-----------------|
| `gersemi` | `cmake.lua` | `pip install gersemi` |
| `cmakelint` | `cmake.lua` | `pip install cmakelint` |
| `sqlfluff` | `sql.lua` | `pip install sqlfluff` |
