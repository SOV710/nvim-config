-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local M = {}

local function enabled_filetypes()
  local langs = require('core.language')._langs
  local filetypes = {}

  for _, name in ipairs { 'clojure', 'racket' } do
    if langs[name] then
      filetypes[#filetypes + 1] = name
    end
  end

  return filetypes
end

---@param filetype 'clojure'|'racket'
---@return LazySpec
function M.spec(filetype)
  assert(filetype == 'clojure' or filetype == 'racket', 'unsupported Conjure language: ' .. filetype)

  return {
    'Olical/conjure',
    ft = enabled_filetypes,
    init = function()
      vim.g['conjure#filetypes'] = enabled_filetypes()
    end,
  }
end

return M
