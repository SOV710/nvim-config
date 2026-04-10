local M = {}
local utils = require 'heirline.utils'

-- ══════════════════════════════════════════════════════════════════════
-- State
-- ══════════════════════════════════════════════════════════════════════

local tab_names = {} -- tabpage handle → custom name
local show_picker = false -- picker mode active?

-- Home-row key sequence for tab picker
local picker_keys = 'asdfjklghvbnyuio'

-- Build reverse map: char → index
local label_map = {}
for i = 1, #picker_keys do
  label_map[picker_keys:sub(i, i)] = i
end

-- Numbered tab icons (Nerd Font)
local tab_icons = {
  '󰲡',
  '󰲣',
  '󰲥',
  '󰲧',
  '󰲩',
  '󰲫',
  '󰲭',
  '󰲯',
  '󰲱',
  '󰿭',
}

local update_events = {
  'TabEnter',
  'TabNew',
  'TabClosed',
  'WinNew',
  'WinClosed',
  'WinLeave',
  'WinEnter',
  'BufWinEnter',
  'BufWinLeave',
  'BufDelete',
}

-- ══════════════════════════════════════════════════════════════════════
-- Public functions (for keymaps)
-- ══════════════════════════════════════════════════════════════════════

function M.pick()
  show_picker = true
  vim.cmd.redrawtabline()

  local ok, char = pcall(vim.fn.getcharstr)
  show_picker = false

  if ok and char then
    local idx = label_map[char:lower()]
    local tabs = vim.api.nvim_list_tabpages()
    if idx and idx <= #tabs then
      vim.api.nvim_set_current_tabpage(tabs[idx])
    end
  end

  vim.cmd.redrawtabline()
end

function M.rename()
  vim.ui.input({ prompt = 'Tab name: ' }, function(name)
    if name and name ~= '' then
      tab_names[vim.api.nvim_get_current_tabpage()] = name
    else
      tab_names[vim.api.nvim_get_current_tabpage()] = nil
    end
    vim.cmd.redrawtabline()
  end)
end

-- ══════════════════════════════════════════════════════════════════════
-- Tab component (one per tabpage, used by make_tablist)
-- ══════════════════════════════════════════════════════════════════════

local TabComponent = {
  init = function(self)
    local tabnr = self.tabnr
    local tabpage = self.tabpage
    local is_active = self.is_active

    -- Get tab name: custom or auto-derived from active window buffer
    local name = tab_names[tabpage]
    if not name then
      local win = vim.api.nvim_tabpage_get_win(tabpage)
      local buf = vim.api.nvim_win_get_buf(win)
      name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
      if name == '' then
        name = '[No Name]'
      end
    end

    self.tab_name = name

    -- Icon
    if show_picker then
      local key = picker_keys:sub(tabnr, tabnr):upper()
      self.tab_icon = key
    elseif is_active then
      self.tab_icon = '󰻂'
    else
      local icon_idx = tabnr <= #tab_icons and tabnr or #tab_icons
      self.tab_icon = tab_icons[icon_idx]
    end
  end,

  provider = function(self)
    return ' ' .. self.tab_icon .. ' ' .. self.tab_name .. ' '
  end,

  hl = function(self)
    return self.is_active and 'TabLineSel' or 'TabLine'
  end,
}

-- ══════════════════════════════════════════════════════════════════════
-- Tabpages list
-- ══════════════════════════════════════════════════════════════════════

local Tabpages = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  utils.make_tablist(TabComponent),
  update = update_events,
}

-- ══════════════════════════════════════════════════════════════════════
-- Windows list (right side)
-- ══════════════════════════════════════════════════════════════════════

local ignored_filetypes = {
  ['neo-tree'] = true,
  ['neo-tree-popup'] = true,
  ['snacks_picker_list'] = true,
  ['snacks_picker_input'] = true,
  ['snacks_layout_box'] = true,
  ['trouble'] = true,
  ['undotree'] = true,
  ['diff'] = true, -- undotree diff preview
  ['dap-view'] = true,
  ['dap-view-term'] = true,
}

local function is_ignored_win(win)
  local config = vim.api.nvim_win_get_config(win)
  if config.relative ~= '' then
    return true -- floating
  end
  local buf = vim.api.nvim_win_get_buf(win)
  if ignored_filetypes[vim.bo[buf].filetype] then
    return true
  end
  return false
end

local function get_file_icon(buf)
  local ft = vim.bo[buf].filetype
  if ft == '' then
    ft = 'file'
  end
  local ok, icon = pcall(Snacks.util.icon, ft, 'filetype')
  return ok and icon or ''
end

-- Check if a buffer is tagged in grapple and return its index
local function grapple_index(buf)
  local ok, grapple = pcall(require, 'grapple')
  if not ok then
    return nil
  end
  local tags_ok, tags = pcall(grapple.tags)
  if not tags_ok or not tags then
    return nil
  end
  local path = vim.api.nvim_buf_get_name(buf)
  for i, tag in ipairs(tags) do
    if tag.path == path then
      return i
    end
  end
  return nil
end

local function render_windows(compressed)
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local cur_win = vim.api.nvim_get_current_win()
  local parts = {}

  for _, win in ipairs(wins) do
    if not is_ignored_win(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local bufname = vim.api.nvim_buf_get_name(buf)
      local icon = get_file_icon(buf)
      local is_active = (win == cur_win)
      local gidx = grapple_index(buf)
      local hl_group = is_active and 'TabLineSel' or 'TabLine'

      local segment
      if compressed then
        segment = string.format('%%#%s# %s%s%%*', hl_group, icon, gidx and ' 󰛢' or '')
      else
        local name = vim.fn.fnamemodify(bufname, ':t')
        if name == '' then
          name = '[No Name]'
        end
        segment = string.format('%%#%s# %s %s %%*', hl_group, icon, name)
        if gidx then
          segment = segment .. string.format('%%#WarningMsg# 󰛢%d%%*', gidx)
        end
      end

      table.insert(parts, segment)
    end
  end

  return table.concat(parts)
end

local Windows = {
  flexible = 3,
  update = {
    'TabEnter',
    'TabNew',
    'TabClosed',
    'WinNew',
    'WinClosed',
    'WinLeave',
    'WinEnter',
    'BufWinEnter',
    'BufWinLeave',
    'BufDelete',
    'User',
    pattern = { '*', 'GrappleUpdate' },
  },
  {
    provider = function()
      return render_windows(false)
    end,
  },
  {
    provider = function()
      return render_windows(true)
    end,
  },
}

-- ══════════════════════════════════════════════════════════════════════
-- Assembly
-- ══════════════════════════════════════════════════════════════════════

M.tabline = {
  Tabpages,
  { provider = '%=', hl = 'TabLine' }, -- fill space
  Windows,
  { provider = '  ', hl = 'TabLine' }, -- trailing padding
}

return M
