local function apply(keymaps)
  for _, km in ipairs(keymaps) do
    vim.keymap.set(km.mode or 'n', km[1], km[2], {
      desc = km.desc,
      expr = km.expr,
      silent = km.silent ~= false,
      remap = km.remap,
    })
  end
end

-- Standalone keymaps (not tied to any plugin)
apply(require 'core.keymaps.editing')
apply(require 'core.keymaps.winbuf')

-- LSP keymaps (special: uses LspAttach autocmd)
require('lua.core.keymaps.langs.lsp').setup()

-- diagnostic keymaps
apply(require 'core.keymaps.langs.diagnostic')
