local heatmap = require 'plugins.ui.dashboard.heatmap'

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

-- --- Clock Line ---------------------

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

-- --- System Info Line ----------------

local function os_info()
  local uname = vim.uv.os_uname()
  local sysname = uname.sysname

  -- Windows
  if sysname:match 'Windows' then
    -- uname.version on Windows usually looks like "Windows 11 Pro" or similar
    local name = uname.version ~= '' and uname.version or sysname
    return ' ' .. name
  end

  -- macOS
  if sysname == 'Darwin' then
    local handle = io.popen 'sw_vers -productVersion 2>/dev/null'
    local version = ''
    if handle then
      version = (handle:read '*a' or ''):gsub('%s+$', '')
      handle:close()
    end
    if version == '' then
      version = uname.release -- fallback to Darwin kernel version
    end
    return ' macOS ' .. version
  end

  -- Unix-like: read /etc/os-release
  local pretty_name, id, id_like = nil, nil, nil
  local f = io.open('/etc/os-release', 'r')
  if f then
    for line in f:lines() do
      local k, v = line:match '^([%w_]+)=(.+)$'
      if k and v then
        v = v:gsub('^"(.*)"$', '%1'):gsub("^'(.*)'$", '%1')
        if k == 'PRETTY_NAME' then
          pretty_name = v
        elseif k == 'ID' then
          id = v
        elseif k == 'ID_LIKE' then
          id_like = v
        end
      end
    end
    f:close()
  end

  pretty_name = pretty_name or sysname

  -- Nerd Font icons keyed by /etc/os-release ID
  local icons = {
    debian = ' ',
    ubuntu = ' ',
    ['pop'] = ' ',
    linuxmint = '󰣭 ',
    deepin = ' ',
    rocky = ' ',
    fedora = ' ',
    opensuse = ' ',
    ['opensuse-tumbleweed'] = ' ',
    ['opensuse-leap'] = ' ',
    gentoo = ' ',
    arch = ' ',
    nixos = ' ',
    slackware = ' ',
    void = ' ',
    alpine = ' ',
    aosc = ' ',
    ['aosc-os'] = ' ',
    manjaro = ' ',
    freebsd = ' ',
    endeavouros = ' ',
    kali = ' ',
    garuda = ' ',
    rhel = ' ',
    qubes = ' ',
    guix = ' ',
  }

  local icon = id and icons[id]
  -- Fallback: try ID_LIKE (e.g. derivatives not in our explicit list)
  if not icon and id_like then
    for token in id_like:gmatch '%S+' do
      if icons[token] then
        icon = icons[token]
        break
      end
    end
  end
  icon = icon or ' ' -- generic Linux/Tux

  return icon .. pretty_name
end

local function nvim_version()
  local v = vim.version()
  local s = string.format(' Neovim %d.%d.%d', v.major, v.minor, v.patch)
  if v.prerelease then
    s = s .. '-' .. tostring(v.prerelease)
  end
  return s
end

return {
  'folke/snacks.nvim',
  init = function()
    heatmap.setup()
  end,
  opts = {
    dashboard = {
      enabled = true,
      width = 60, -- content width
      pane_gap = 4, -- gap between panes in wide layout

      preset = {
        header = logo,
        keys = {
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'f', desc = 'Find File', action = pick 'files' },
          { icon = '󱎸 ', key = 'g', desc = 'Grep', action = pick 'grep' },
          { icon = '󰋚 ', key = 'r', desc = 'Recent Files', action = pick 'recent' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
          { icon = '󰊢 ', key = 'b', desc = 'Git Browse', action = function() Snacks.gitbrowse() end },
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
            {
              text = { { clock_line(), hl = 'SnacksDashboardDesc' } },
              align = 'center',
              padding = 1,
              pane = 1,
            },
            {
              text = {
                { os_info(), hl = 'SnacksDashboardDesc' },
                { '  |  ', hl = 'SnacksDashboardDimmed' },
                { nvim_version(), hl = 'SnacksDashboardDesc' },
              },
              align = 'center',
              padding = 1,
              pane = 1,
            },
            keys,
            { section = 'startup', padding = 1, pane = 1 },
            {
              section = 'projects',
              title = 'Projects',
              icon = ' ',
              indent = 2,
              padding = 1,
              pane = 2,
            },
            {
              section = 'recent_files',
              title = 'Recent',
              icon = '󰋚 ',
              indent = 2,
              padding = 1,
              pane = 2,
            },
            {
              icon = ' ',
              section = 'terminal',
              title = 'Git Status',
              cmd = 'git --no-pager diff --stat -B -M -C',
              height = 5,
              pane = 2,
            },
            vim.tbl_extend('force', heatmap.section { palette = 'tokyo_night' }, { pane = 2 }),
          }
        else
          return {
            header,
            {
              text = { { clock_line(), hl = 'SnacksDashboardDesc' } },
              align = 'center',
              padding = 1,
            },
            {
              section = 'recent_files',
              title = 'Recent',
              icon = '󰋚 ',
              indent = 2,
              padding = 1,
            },
            {
              text = {
                { os_info(), hl = 'SnacksDashboardDesc' },
                { '  |  ', hl = 'SnacksDashboardDimmed' },
                { nvim_version(), hl = 'SnacksDashboardDesc' },
              },
              align = 'center',
              padding = 1,
            },
            keys,
            startup,
          }
        end
      end,
    },
  },
}
