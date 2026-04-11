-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local heatmap = require 'plugins.ui.dashboard.heatmap'
local clock = require 'plugins.ui.dashboard.clock'
local sysinfo = require 'core.sysinfo'

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
       ██      ██ ██  ██         ██ ██  ██ 
  ████   ████   ████    ██  ██   ████  
   ████     ████     ████    ███████████████   
]]

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
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
          {
            icon = '󰊢 ',
            key = 'b',
            desc = 'Git Browse',
            action = function()
              Snacks.gitbrowse()
            end,
          },
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
              text = { { clock.line(), hl = 'SnacksDashboardDesc' } },
              align = 'center',
              padding = 1,
              pane = 1,
            },
            {
              text = {
                { sysinfo.line(), hl = 'SnacksDashboardDesc' },
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
              ttl = 60,
              pane = 2,
            },
            vim.tbl_extend('force', heatmap.section { palette = 'tokyo_night' }, { pane = 2 }),
          }
        else
          return {
            header,
            {
              text = { { clock.line(), hl = 'SnacksDashboardDesc' } },
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
                { sysinfo.line(), hl = 'SnacksDashboardDesc' },
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
