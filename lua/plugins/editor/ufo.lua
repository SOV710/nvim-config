--- Check whether treesitter can actually provide folds for this buffer.
--- Requires both a parser AND a folds.scm query file.
local function has_ts_folds(bufnr, filetype)
  local lang = vim.treesitter.language.get_lang(filetype) or filetype
  local ok_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok_parser then
    return false
  end
  local ok_query, query = pcall(vim.treesitter.query.get, lang, 'folds')
  return ok_query and query ~= nil
end

return {
  'kevinhwang91/nvim-ufo',
  event = 'LazyFile',
  dependencies = { 'kevinhwang91/promise-async' },
  keys = require 'keymaps.editor.ufo',

  init = function()
    -- Fold options co-located with the plugin that manages them
    vim.o.foldcolumn = '1' -- show fold column (1 char wide)
    vim.o.foldlevel = 99 -- open all folds by default
    vim.o.foldlevelstart = 99 -- open all folds when opening a file
    vim.o.foldenable = true -- enable folding
  end,

  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      -- Skip non-file buffers entirely
      if buftype ~= '' then
        return ''
      end

      local has_ts = has_ts_folds(bufnr, filetype)

      -- Filetypes where LSP folding is unreliable — use treesitter as main
      local prefer_ts = {
        markdown = true,
        org = true,
        tex = true,
        python = true,
      }
      if prefer_ts[filetype] then
        return has_ts and { 'treesitter', 'indent' } or { 'indent', 'indent' }
      end

      -- Default: LSP main, treesitter fallback if it actually has folds query,
      -- otherwise indent as fallback
      return has_ts and { 'lsp', 'treesitter' } or { 'lsp', 'indent' }
    end,
    open_fold_hl_timeout = 400, -- ms to highlight newly opened fold (0 = disable)
    close_fold_kinds_for_ft = {
      default = { 'imports' },
    },

    preview = {
      win_config = {
        border = 'rounded', -- preview window border style
        winhighlight = 'Normal:Folded', -- preview window highlight
        winblend = 0, -- preview window transparency
      },
      mappings = {
        scrollU = '<C-u>', -- scroll up in preview
        scrollD = '<C-d>', -- scroll down in preview
        jumpTop = '[', -- jump to top of preview
        jumpBot = ']', -- jump to bottom of preview
      },
    },

    -- Custom virtual text handler: show fold line count
    fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
      local new_virt_text = {}
      local suffix = ('  %d lines '):format(end_lnum - lnum)
      local suf_width = vim.fn.strdisplaywidth(suffix)
      local target_width = width - suf_width
      local curWidth = 0

      for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]
        local chunk_width = vim.fn.strdisplaywidth(chunk_text)
        if target_width > curWidth + chunk_width then
          table.insert(new_virt_text, chunk)
        else
          chunk_text = truncate(chunk_text, target_width - curWidth)
          local hl_group = chunk[2]
          table.insert(new_virt_text, { chunk_text, hl_group })
          chunk_width = vim.fn.strdisplaywidth(chunk_text)
          if curWidth + chunk_width < target_width then
            table.insert(new_virt_text, { (' '):rep(target_width - curWidth - chunk_width) })
          end
          break
        end
        curWidth = curWidth + chunk_width
      end

      table.insert(new_virt_text, { suffix, 'MoreMsg' })
      return new_virt_text
    end,
  },
}
