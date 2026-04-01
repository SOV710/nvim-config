local conditions = require("heirline.conditions")

-- ══════════════════════════════════════════════════════════════════════
-- Mode indicator
-- ══════════════════════════════════════════════════════════════════════

local mode_names = {
  n = "NORMAL", no = "NORMAL", nov = "NORMAL", noV = "NORMAL", ["no\22"] = "NORMAL",
  niI = "NORMAL", niR = "NORMAL", niV = "NORMAL", nt = "NORMAL", ntT = "NORMAL",
  i = "INSERT", ic = "INSERT", ix = "INSERT",
  v = "VISUAL", vs = "VISUAL",
  V = "V-LINE", Vs = "V-LINE",
  ["\22"] = "V-BLOCK", ["\22s"] = "V-BLOCK",
  s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
  c = "COMMAND", cv = "COMMAND", ce = "COMMAND",
  R = "REPLACE", Rc = "REPLACE", Rx = "REPLACE",
  Rv = "V-REPLACE", Rvc = "V-REPLACE", Rvx = "V-REPLACE",
  r = "PROMPT", rm = "MORE", ["r?"] = "CONFIRM",
  ["!"] = "SHELL", t = "TERMINAL",
}

local ModeBlock = {
  provider = function(self)
    return " " .. (mode_names[self.mode] or self.mode) .. " "
  end,
  hl = function(self)
    return { fg = "dark", bg = self.mode_color, bold = true }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
  },
}

local ModeSep = {
  provider = "",
  hl = function(self)
    return { fg = self.mode_color, bg = "bright_bg" }
  end,
}

local ModeSepEnd = {
  provider = "",
  hl = function(self)
    return { fg = self.mode_color }
  end,
}

-- ── Git branch (shown after mode when in git repo) ──────────────────

local GitBranch = {
  condition = conditions.is_git_repo,
  provider = function()
    local dict = vim.b.gitsigns_status_dict
    return dict and dict.head and ("  " .. dict.head .. " ") or ""
  end,
  hl = { fg = "white", bg = "bright_bg" },
}

local GitBranchSep = {
  condition = conditions.is_git_repo,
  provider = "",
  hl = { fg = "bright_bg" },
}

-- Mode with fallthrough: git variant vs plain variant
local Mode = {
  fallthrough = false,
  -- Git variant: Mode + sep + branch + sep
  {
    condition = conditions.is_git_repo,
    ModeBlock,
    ModeSep,
    GitBranch,
    GitBranchSep,
  },
  -- Non-git variant: Mode + sep (direct to bg)
  {
    ModeBlock,
    ModeSepEnd,
  },
}

-- ══════════════════════════════════════════════════════════════════════
-- Diagnostics
-- ══════════════════════════════════════════════════════════════════════

local Diagnostics = {
  condition = conditions.has_diagnostics,
  update = { "DiagnosticChanged", "BufEnter" },
  init = function(self)
    self.errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.info     = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.hints    = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  end,
  {
    provider = " ",
  },
  {
    provider = function(self)
      return self.errors > 0 and (" " .. self.errors .. " ") or ""
    end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (" " .. self.warnings .. " ") or ""
    end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self)
      return self.info > 0 and (" " .. self.info .. " ") or ""
    end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self)
      return self.hints > 0 and ("󰌵 " .. self.hints .. " ") or ""
    end,
    hl = { fg = "diag_hint" },
  },
}

-- ══════════════════════════════════════════════════════════════════════
-- File info (with fallthrough for buffer types)
-- ══════════════════════════════════════════════════════════════════════

local function get_file_icon(filename)
  local ok, icon, icon_hl = pcall(function()
    return Snacks.util.icon(filename)
  end)
  if ok and icon then
    return icon, icon_hl
  end
  return "", nil
end

local FileIcon = {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    self.icon, self.icon_hl = get_file_icon(filename)
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ") or ""
  end,
  hl = function(self)
    return self.icon_hl and { fg = self.icon_hl } or nil
  end,
}

local WorkDir = {
  flexible = 1,  -- first to compress
  {
    provider = function()
      local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.:h")
      if cwd == "." then return "" end
      return cwd .. "/"
    end,
    hl = { fg = "gray" },
  },
  {
    provider = function()
      local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.:h")
      if cwd == "." then return "" end
      return vim.fn.pathshorten(cwd) .. "/"
    end,
    hl = { fg = "gray" },
  },
  {
    provider = " ",
  },
}

local FileName = {
  flexible = 10,  -- last to compress
  {
    provider = function()
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
      if name == "" then return "[No Name]" end
      return name
    end,
    hl = function()
      return {
        fg = vim.bo.modified and "orange" or "white",
        bold = true,
      }
    end,
  },
}

local FileFlags = {
  provider = function()
    if not vim.bo.modifiable or vim.bo.readonly then
      return "  "
    end
    return ""
  end,
  hl = { fg = "orange" },
}

-- Terminal buffer
local TerminalFile = {
  condition = function()
    return vim.bo.buftype == "terminal"
  end,
  {
    provider = " ",
    hl = { fg = "green" },
  },
  {
    provider = function()
      local name = vim.api.nvim_buf_get_name(0)
      -- strip path prefix and toggleterm suffix
      name = name:gsub("^.*:", ""):gsub(";#toggleterm#%d+$", "")
      return name
    end,
  },
}

-- Help buffer
local HelpFile = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  {
    provider = "󱛉 ",
    hl = { fg = "blue" },
  },
  {
    provider = function()
      return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    end,
  },
}

-- Oil buffer
local OilFile = {
  condition = function()
    return vim.bo.buftype == "acwrite" and vim.bo.filetype == "oil"
  end,
  {
    provider = " ",
    hl = { fg = "blue" },
  },
  {
    provider = function()
      local ok, oil = pcall(require, "oil")
      if ok and oil.get_current_dir then
        local dir = oil.get_current_dir()
        return dir and vim.fn.fnamemodify(dir, ":~") or "[Oil]"
      end
      return "[Oil]"
    end,
  },
}

-- Normal file
local NormalFile = {
  condition = function()
    return vim.bo.buftype == ""
  end,
  FileIcon,
  WorkDir,
  FileName,
  FileFlags,
}

-- Fallback
local FallbackFile = {
  provider = "",
}

local File = {
  fallthrough = false,
  update = { "BufWritePost", "BufEnter", "TextChanged", "VimResized" },
  { provider = " " },  -- left padding
  TerminalFile,
  HelpFile,
  OilFile,
  NormalFile,
  FallbackFile,
}

-- ══════════════════════════════════════════════════════════════════════
-- Git diff counts
-- ══════════════════════════════════════════════════════════════════════

local GitDiff = {
  flexible = 4,
  {
    condition = function()
      if not conditions.is_git_repo() then return false end
      local dict = vim.b.gitsigns_status_dict
      return dict and (dict.added or 0) + (dict.changed or 0) + (dict.removed or 0) > 0
    end,
    init = function(self)
      local dict = vim.b.gitsigns_status_dict or {}
      self.added   = dict.added or 0
      self.changed = dict.changed or 0
      self.removed = dict.removed or 0
    end,
    {
      provider = function(self)
        return self.added > 0 and (" +" .. self.added) or ""
      end,
      hl = { fg = "git_added" },
    },
    {
      provider = function(self)
        return self.changed > 0 and (" ~" .. self.changed) or ""
      end,
      hl = { fg = "git_changed" },
    },
    {
      provider = function(self)
        return self.removed > 0 and (" -" .. self.removed) or ""
      end,
      hl = { fg = "git_removed" },
    },
    { provider = " " },
  },
  -- compressed: empty
  { provider = "" },
}

-- ══════════════════════════════════════════════════════════════════════
-- Noice status (optional)
-- ══════════════════════════════════════════════════════════════════════

local Noice = {
  condition = function()
    return package.loaded["noice"] ~= nil
  end,
  {
    provider = function()
      local ok, noice = pcall(require, "noice")
      if ok and noice.api.status.command.has() then
        return " " .. noice.api.status.command.get() .. " "
      end
      return ""
    end,
    hl = { fg = "purple" },
  },
  {
    provider = function()
      local ok, noice = pcall(require, "noice")
      if ok and noice.api.status.mode.has() then
        return " " .. noice.api.status.mode.get() .. " "
      end
      return ""
    end,
    hl = { fg = "orange" },
  },
}

-- ══════════════════════════════════════════════════════════════════════
-- Ruler + Clock
-- ══════════════════════════════════════════════════════════════════════

local function visual_range()
  local mode = vim.fn.mode()
  local start = vim.fn.getpos("v")
  local stop = vim.fn.getpos(".")
  local start_row, start_col = start[2], start[3]
  local stop_row, stop_col = stop[2], stop[3]

  local rows = math.abs(stop_row - start_row) + 1

  if mode == "v" then
    -- character-wise: count total chars
    if rows == 1 then
      return rows .. ":" .. (math.abs(stop_col - start_col) + 1)
    end
    local first_line = vim.fn.getline(math.min(start_row, stop_row))
    local last_line = vim.fn.getline(math.max(start_row, stop_row))
    local first_col = start_row < stop_row and start_col or stop_col
    local last_col = start_row < stop_row and stop_col or start_col
    local chars = (#first_line - first_col + 1) + last_col
    for r = math.min(start_row, stop_row) + 1, math.max(start_row, stop_row) - 1 do
      chars = chars + #vim.fn.getline(r)
    end
    return rows .. ":" .. chars
  elseif mode == "V" then
    -- line-wise: rows:current_line_length
    local cur_line = vim.fn.getline(".")
    return rows .. ":" .. #cur_line
  elseif mode == "\22" then
    -- block-wise: rows:columns
    local cols = math.abs(stop_col - start_col) + 1
    return rows .. ":" .. cols
  end
  return ""
end

local RulerSep = {
  provider = "",
  hl = function(self)
    return { fg = "bright_bg" }
  end,
}

local RulerContent = {
  provider = function(self)
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      return " " .. visual_range() .. " "
    end
    return " %3l:%-3c "
  end,
  hl = function(self)
    return { fg = self.mode_color, bg = "bright_bg" }
  end,
}

local ClockSep = {
  provider = "",
  hl = function(self)
    return { fg = self.mode_color, bg = "bright_bg" }
  end,
}

local Clock = {
  provider = function()
    return " " .. os.date("%R") .. " "
  end,
  hl = function(self)
    return { fg = "dark", bg = self.mode_color, bold = true }
  end,
}

local Ruler = {
  RulerSep,
  RulerContent,
  ClockSep,
  Clock,
}

-- ══════════════════════════════════════════════════════════════════════
-- Assembly
-- ══════════════════════════════════════════════════════════════════════

return {
  init = function(self)
    self.mode = vim.fn.mode()
    self.mode_color = self.mode_colors[self.mode] or "blue"
  end,
  static = {
    mode_colors = {
      n = "blue", i = "green", v = "purple", V = "purple",
      ["\22"] = "purple", c = "yellow", s = "pink", S = "pink",
      ["\19"] = "pink", R = "red", r = "blue", ["!"] = "red", t = "aqua",
    },
  },

  Mode, Diagnostics, File,
  { provider = "%=" },  -- align right
  Noice, GitDiff, Ruler,
}
