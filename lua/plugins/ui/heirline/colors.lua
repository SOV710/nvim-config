local M = {}

function M.get()
  local utils = require 'heirline.utils'
  local function hl(name)
    -- safely get highlight, return empty table if not found
    local ok, result = pcall(utils.get_highlight, name)
    return ok and result or {}
  end

  return {
    -- Base
    white = hl('Normal').fg,
    dark = hl('IncSearch').fg,
    mid_bg = hl('CursorLine').bg,
    bright_bg = hl('Folded').bg,
    bright_fg = hl('Folded').fg,
    gray = hl('NonText').fg,

    -- Mode colors (extracted from syntax groups for theme consistency)
    blue = hl('Function').fg,
    green = hl('String').fg,
    purple = hl('Statement').fg,
    red = hl('Substitute').bg,
    orange = hl('Constant').fg,
    yellow = hl('DiagnosticWarn').fg,
    pink = hl('@keyword').fg,
    cyan = hl('Special').fg,
    aqua = hl('DiagnosticHint').fg,

    -- Diagnostics
    diag_error = hl('DiagnosticError').fg,
    diag_warn = hl('DiagnosticWarn').fg,
    diag_info = hl('DiagnosticInfo').fg,
    diag_hint = hl('DiagnosticHint').fg,

    -- Git
    git_added = hl('diffAdded').fg,
    git_changed = hl('diffChanged').fg,
    git_removed = hl('diffRemoved').fg,
  }
end

return M
