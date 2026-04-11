-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local M = {}

-- ── Helpers ──────────────────────────────────────────────────────────

local function has(bufnr, method)
  method = method:find '/' and method or 'textDocument/' .. method
  for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.supports_method(method, bufnr) then
      return true
    end
  end
  return false
end

-- ── Setup ──────────────────────────────────────────────────────────

function M.setup()
  -- ── Delete Neovim 0.11 default gr* mappings ─────────────────────
  pcall(vim.keymap.del, 'n', 'grn')
  pcall(vim.keymap.del, 'n', 'gra')
  pcall(vim.keymap.del, 'n', 'grr')
  pcall(vim.keymap.del, 'n', 'gri')
  pcall(vim.keymap.del, 'n', 'grt')

  -- ── LspAttach autocmd ───────────────────────────────────────────
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('core-lsp-keymaps', { clear = true }),
    callback = function(ev)
      local bufnr = ev.buf

      local lsp_keymaps = {
        { 'ld', vim.lsp.buf.definition, 'definition', 'Definition' },
        { 'lD', vim.lsp.buf.declaration, 'declaration', 'Declaration' },
        { 'lt', vim.lsp.buf.type_definition, 'typeDefinition', 'Type Definition' },
        { 'lr', vim.lsp.buf.references, 'references', 'References' },
        { 'li', vim.lsp.buf.implementation, 'implementation', 'Implementation' },
        { 'ln', vim.lsp.buf.rename, 'rename', 'Rename' },
        { 'lc', vim.lsp.buf.code_action, 'codeAction', 'Code Action' },
      }

      for _, km in ipairs(lsp_keymaps) do
        local lhs, fn, method, desc = km[1], km[2], km[3], km[4]
        if not method or has(bufnr, method) then
          vim.keymap.set('n', '<leader>' .. lhs, fn, { buffer = bufnr, desc = desc })
        end
      end
    end,
  })
end

return M
