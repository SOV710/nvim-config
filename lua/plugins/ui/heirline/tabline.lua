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
    if self.is_active then
      return 'TabLineSel'
    end
    return { fg = 'gray' }
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

local function get_file_icon(bufname)
  local ok, icon = pcall(function()
    return Snacks.util.icon(bufname)
  end)
  return ok and icon or ''
end

-- Check if a buffer is tagged in grapple and return its index
local function grapple_index(buf)
  local ok, grapple = pcall(require, 'grapple')
  if not ok then
    return nil
  end
  local exists = pcall(grapple.find, { buffer = buf })
  if not exists then
    return nil
  end
  local tags_ok, tags = pcall(grapple.tags)
  if not tags_ok or not tags then
    return nil
  end
  for i, tag in ipairs(tags) do
    if tag.path == vim.api.nvim_buf_get_name(buf) then
      return i
    end
  end
  return nil
end

local Windows = {
  flexible = 3,
  -- Full: icon + filename
  {
    init = function(self)
      local wins = vim.api.nvim_tabpage_list_wins(0)
      local cur_win = vim.api.nvim_get_current_win()
      local children = {}

      for _, win in ipairs(wins) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative == '' then
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          local name = vim.fn.fnamemodify(bufname, ':t')
          if name == '' then
            name = '[No Name]'
          end
          local icon = get_file_icon(bufname)
          local is_active = (win == cur_win)

          local gidx = grapple_index(buf)
          table.insert(children, {
            provider = ' ' .. icon .. ' ' .. name,
            hl = is_active and 'TabLineSel' or { fg = 'gray' },
          })
          if gidx then
            table.insert(children, {
              provider = ' 󰛢' .. gidx,
              hl = { fg = 'yellow' },
            })
          end
        end
      end

      self[1] = self:new(children, 1)
    end,
    provider = '',
  },
  -- Compressed: icons only
  {
    init = function(self)
      local wins = vim.api.nvim_tabpage_list_wins(0)
      local cur_win = vim.api.nvim_get_current_win()
      local children = {}

      for _, win in ipairs(wins) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative == '' then
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          local icon = get_file_icon(bufname)
          local is_active = (win == cur_win)
          local gidx = grapple_index(buf)

          table.insert(children, {
            provider = ' ' .. icon .. (gidx and ' 󰛢' or ''),
            hl = is_active and 'TabLineSel' or { fg = 'gray' },
          })
        end
      end

      self[1] = self:new(children, 1)
    end,
    provider = '',
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
