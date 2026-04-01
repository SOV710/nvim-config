local conditions = require("heirline.conditions")

-- ══════════════════════════════════════════════════════════════════════
-- Mode names
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

-- ══════════════════════════════════════════════════════════════════════
-- Mode + Git Branch
-- ══════════════════════════════════════════════════════════════════════

local ModeBlock = {
  provider = function(self)
    return " " .. (mode_names[self.mode] or self.mode) .. " "
  end,
  hl = function(self)
    return { fg = "dark", bg = self.mode_color, bold = true }
  end,
}

local ModeWithBranch = {
  fallthrough = false,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
  },

  -- Branch 1: git repo — mode + separator + branch + separator
  {
    condition = conditions.is_git_repo,

    -- Mode block
    ModeBlock,
    -- Separator: mode_color → bright_bg
    {
      provider = "",
      hl = function(self)
        return { fg = self.mode_color, bg = "bright_bg" }
      end,
    },
    -- Branch name
    {
      provider = function()
        local dict = vim.b.gitsigns_status_dict
        return dict and dict.head and ("  " .. dict.head .. " ") or ""
      end,
      hl = { fg = "white", bg = "bright_bg" },
    },
    -- Separator: bright_bg → default
    {
      provider = "",
      hl = { fg = "bright_bg" },
    },
  },

  -- Branch 2: no git — mode + separator to default
  {
    ModeBlock,
    -- Separator: mode_color → default
    {
      provider = "",
      hl = function(self)
        return { fg = self.mode_color }
      end,
    },
  },
}

-- ══════════════════════════════════════════════════════════════════════
-- Diagnostics
-- ══════════════════════════════════════════════════════════════════════

local Diagnostics = {
  condition = conditions.has_diagnostics,
  update = { "DiagnosticChanged", "BufEnter" },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warns  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.infos  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.hints  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  end,
  { provider = " " },
  { provider = function(self) return self.errors > 0 and (" " .. self.errors .. " ") or "" end, hl = { fg = "diag_error" } },
  { provider = function(self) return self.warns  > 0 and (" " .. self.warns  .. " ") or "" end, hl = { fg = "diag_warn" } },
  { provider = function(self) return self.infos  > 0 and (" " .. self.infos  .. " ") or "" end, hl = { fg = "diag_info" } },
  { provider = function(self) return self.hints  > 0 and ("󰌵 " .. self.hints  .. " ") or "" end, hl = { fg = "diag_hint" } },
}

-- ══════════════════════════════════════════════════════════════════════
-- File info
-- ══════════════════════════════════════════════════════════════════════

local FileIcon = {
  init = function(self)
    local ok, icon, hl = pcall(function() return Snacks.util.icon(self.filename) end)
    if ok then
      self.icon, self.icon_hl = icon, hl
    else
      self.icon, self.icon_hl = "", nil
    end
  end,
  provider = function(self) return self.icon and (self.icon .. " ") or "" end,
  hl = function(self) return self.icon_hl end,
}

local WorkDir = {
  flexible = 1, -- first to compress
  {
    provider = function(self)
      local dir = vim.fn.fnamemodify(self.filename, ":~:.:h")
      if dir == "." then return "" end
      return dir .. "/"
    end,
    hl = { fg = "gray" },
  },
  {
    provider = function(self)
      local dir = vim.fn.fnamemodify(self.filename, ":~:.:h")
      if dir == "." then return "" end
      return vim.fn.pathshorten(dir) .. "/"
    end,
    hl = { fg = "gray" },
  },
  { provider = "" },
}

local FileName = {
  flexible = 10, -- last to compress
  {
    provider = function(self)
      local name = vim.fn.fnamemodify(self.filename, ":t")
      if name == "" then return "[No Name]" end
      return name
    end,
    hl = function()
      return { fg = vim.bo.modified and "orange" or "white", bold = true }
    end,
  },
}

local FileFlags = {
  provider = function()
    if not vim.bo.modifiable or vim.bo.readonly then return "  " end
    return ""
  end,
  hl = { fg = "orange" },
}

local NormalFile = {
  condition = function() return vim.bo.buftype == "" end,
  init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
  FileIcon, WorkDir, FileName, FileFlags,
}

local TerminalName = {
  condition = function() return vim.bo.buftype == "terminal" end,
  { provider = " ", hl = { fg = "green" } },
  {
    provider = function()
      local name = vim.api.nvim_buf_get_name(0)
      return name:gsub("^.*:", ""):gsub(";#toggleterm#%d+$", "")
    end,
  },
}

local HelpName = {
  condition = function() return vim.bo.filetype == "help" end,
  { provider = "󱛉 ", hl = { fg = "blue" } },
  {
    provider = function()
      return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    end,
  },
}

local OilName = {
  condition = function() return vim.bo.buftype == "acwrite" and vim.bo.filetype == "oil" end,
  { provider = " ", hl = { fg = "blue" } },
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

local File = {
  fallthrough = false,
  update = { "BufWritePost", "BufEnter", "TextChanged", "VimResized" },
  { provider = " " }, -- left padding
  TerminalName,
  HelpName,
  OilName,
  NormalFile,
  { provider = "" }, -- fallback
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
    { provider = function(self) return self.added   > 0 and (" +" .. self.added)   or "" end, hl = { fg = "git_added" } },
    { provider = function(self) return self.changed > 0 and (" ~" .. self.changed) or "" end, hl = { fg = "git_changed" } },
    { provider = function(self) return self.removed > 0 and (" -" .. self.removed) or "" end, hl = { fg = "git_removed" } },
    { provider = " " },
  },
  -- compressed: empty
  { provider = "" },
}

-- ══════════════════════════════════════════════════════════════════════
-- Noice status
-- ══════════════════════════════════════════════════════════════════════

local NoiceStatus = {
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

local function visual_range(mode)
  local start = vim.fn.getpos("v")
  local stop = vim.fn.getpos(".")
  local s_row, s_col = start[2], start[3]
  local e_row, e_col = stop[2], stop[3]

  if s_row > e_row or (s_row == e_row and s_col > e_col) then
    s_row, s_col, e_row, e_col = e_row, e_col, s_row, s_col
  end

  local rows = e_row - s_row + 1

  if mode == "V" then
    local cur_line = vim.fn.getline(".")
    return string.format("%3d:%-3d", rows, #cur_line)
  elseif mode == "\22" then
    return string.format("%3d:%-3d", rows, math.abs(e_col - s_col) + 1)
  else
    -- char-wise visual
    if rows == 1 then
      return string.format("%3d:%-3d", rows, math.abs(e_col - s_col) + 1)
    end
    local first_line = vim.fn.getline(math.min(s_row, e_row))
    local last_line = vim.fn.getline(math.max(s_row, e_row))
    local chars = (#first_line - s_col + 1) + e_col
    for r = s_row + 1, e_row - 1 do
      chars = chars + #vim.fn.getline(r)
    end
    return string.format("%3d:%-3d", rows, chars)
  end
end

local Ruler = {
  -- Left separator: default → bright_bg
  {
    provider = "",
    hl = { fg = "bright_bg" },
  },

  -- Ruler content: bright_bg background
  {
    provider = function(self)
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" or mode == "\22" then
        return " " .. visual_range(mode) .. " "
      end
      return " %3l:%-3c "
    end,
    hl = function(self)
      return { fg = self.mode_color, bg = "bright_bg" }
    end,
  },

  -- Separator: bright_bg → mode_color
  {
    provider = "",
    hl = function(self)
      return { fg = self.mode_color, bg = "bright_bg" }
    end,
  },

  -- Clock
  {
    provider = function()
      return " " .. os.date("%R") .. " "
    end,
    hl = function(self)
      return { fg = "dark", bg = self.mode_color, bold = true }
    end,
  },
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

  ModeWithBranch, Diagnostics, File,
  { provider = "%=" }, -- right-align
  NoiceStatus, GitDiff, Ruler,
}
