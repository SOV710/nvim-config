--- Dashboard clock line — Japanese weekday + date + time + UTC offset.
---
--- Dashboard-specific formatting, co-located with plugins/ui/dashboard/heatmap/
--- as a functional submodule consumed by the sibling plugins/ui/dashboard.lua
--- lazy spec.

local M = {}

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

---@return string
function M.line()
  local weekdays = { '日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日' }
  local wday = weekdays[tonumber(os.date '%w') + 1]
  return string.format(
    '%s   %s (%s)   %s %s',
    wday,
    os.date '%y-%m-%d',
    os.date '%b %d',
    os.date '%H:%M',
    get_utc_offset()
  )
end

return M
