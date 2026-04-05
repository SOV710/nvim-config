local function pick(cmd)
  return function()
    Snacks.dashboard.pick(cmd)
  end
end

local function pickfiles(cwd)
  return function()
    Snacks.dashboard.pick('files', { cwd = cwd })
  end
end

local config_dir = vim.fn.stdpath 'config'
local dot_dir = vim.env.XDG_CONFIG_HOME or '~/.config'

local logo = [[
   ████    ██████          ████████████████  
  ████  ██████        ██    ██  ██████ 
 ██      ██   ────是第五魔法使──── ██      ██  ██
 ██████████   ████    ██    ██  ███████████
       ██      ██ ██  ██      󰮯   ██ ██  ██ 
  ████   ████   ████    ██  ██   ████  
   ████     ████     ████    ███████████████   
]]

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
          { icon = ' ', key = 'f', desc = 'Find File', action = pick 'files' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = pick 'recent' },
          { icon = ' ', key = 'c', desc = 'Config', action = pickfiles(config_dir) },
          { icon = ' ', key = '.', desc = 'Dotfiles', action = pickfiles(dot_dir) },
          { icon = ' ', key = 'g', desc = 'Grep', action = pick 'grep' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
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
              { section = 'projects', title = 'Projects', icon = ' ', indent = 2, padding = 1, pane = 2 },
              { section = 'recent_files', title = 'Recent', icon = ' ', indent = 2, padding = 1, pane = 2 },
            },
            keys,
            { section = 'startup', padding = 1, pane = 2 },
          }
        else
          return {
            header,
            keys,
            { section = 'recent_files', title = 'Recent', icon = ' ', indent = 2, padding = 1 },
            startup,
          }
        end
      end,
    },
  },
}
