-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- Host OS detection shared across plugin configs.
---
--- Detects the host OS (Windows / macOS / Linux distro) and exposes both
--- the nerd font icon glyph and the pretty name. Consumed by the dashboard
--- (system info line) and heirline statusline (mode block icon).
---
--- Detection runs at most once per session; results are memoized on first
--- call to icon()/name()/line().

local M = {}

---@class SysinfoHost
---@field icon string  Nerd font glyph (no trailing space)
---@field name string  Pretty name, e.g. "Gentoo Linux", "macOS 14.5"

---@type SysinfoHost|nil
local cache

---@return SysinfoHost
local function detect()
  local uname = vim.uv.os_uname()
  local sysname = uname.sysname

  -- Windows
  if sysname:match 'Windows' then
    return {
      icon = '󰖳',
      name = (uname.version ~= '' and uname.version) or sysname,
    }
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
    return { icon = ' ', name = 'macOS ' .. version }
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

  -- Nerd font icons keyed by /etc/os-release ID.
  -- NOTE: no trailing space here; callers handle spacing so that heirline
  -- (which pads both sides) and dashboard (which wants "icon name") can
  -- both reuse the same raw glyph.
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

  return {
    icon = icon or '', -- generic Linux/Tux
    name = pretty_name or sysname,
  }
end

---@return SysinfoHost
function M.get()
  cache = cache or detect()
  return cache
end

---@return string
function M.icon()
  return M.get().icon
end

---@return string
function M.name()
  return M.get().name
end

--- `icon + " " + name`, e.g. ` Gentoo Linux`. Preserves the exact byte
--- sequence previously produced by dashboard.lua's os_info().
---@return string
function M.line()
  local h = M.get()
  return h.icon .. ' ' .. h.name
end

return M
