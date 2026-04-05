local function pick(cmd)
  return function()
    Snacks.dashboard.pick(cmd)
  end
end

local logo = [[
   ████    ██████          ████████████████  
  ████  ██████        ██    ██  ██████ 
 ██      ██   ────是第五魔法使──── ██      ██  ██
 ██████████   ████    ██    ██  ███████████
       ██      ██ ██  ██      󰮯   ██ ██  ██ 
  ████   ████   ████    ██  ██   ████  
   ████     ████     ████    ███████████████   
]]

local function get_utc_offset()
  local tz = os.date '%z' --[[@as string]] -- e.g. "+0100" or "-0500"
  local sign = tz:sub(1, 1)
  local hours = tonumber(tz:sub(2, 3))
  local mins = tonumber(tz:sub(4, 5))
  if mins and mins ~= 0 then
    return string.format('UTC%s%d:%02d', sign, hours, mins)
  else
    return string.format('UTC%s%d', sign, hours)
  end
end

local function clock_line()
  local weekdays = { '日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日' }
  local wday = weekdays[tonumber(os.date '%w') + 1]
  return string.format('%s   %s (%s)   %s %s', wday, os.date '%y-%m-%d', os.date '%b %d', os.date '%H:%M', get_utc_offset())
end

local function clock_section()
  return {
    text = { { clock_line(), hl = 'SnacksDashboardDesc' } },
    align = 'center',
    padding = 1,
  }
end

return {
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      enabled = true,
      width = 60, -- content width
      pane_gap = 4, -- gap between panes in wide layout

      preset = {
        header = logo,
        keys = {
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'f', desc = 'Find File', action = pick 'files' },
          { icon = '󱎸 ', key = 'g', desc = 'Grep', action = pick 'grep' },
          { icon = '󰋚 ', key = 'r', desc = 'Recent Files', action = pick 'recent' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
          { icon = '󰩈 ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },

      sections = function(self)
        local win_width = vim.api.nvim_win_get_width(self.win)
        local pane_gap = self.opts.pane_gap
        local item_width = self.opts.width
        local max_panes = math.floor((win_width + pane_gap) / (item_width + pane_gap))

        local header = { section = 'header', padding = 1 }
        local keys = { section = 'keys', gap = 1, indent = 2, padding = 1 }
        local startup = { section = 'startup', padding = 1 }

        if max_panes > 1 then
          return {
            header,
            clock_section(),
            {
              { section = 'projects', title = 'Projects', icon = ' ', indent = 2, padding = 1, pane = 2 },
              { section = 'recent_files', title = 'Recent', icon = ' ', indent = 2, padding = 1, pane = 2 },
            },
            keys,
            { section = 'startup', padding = 1, pane = 2 },
          }
        else
          return {
            header,
            clock_section(),
            keys,
            startup,
          }
        end
      end,
    },
  },
}
