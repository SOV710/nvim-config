local M = {}

local ICON = '󰝤'
local FUTURE = -1
local WEEKDAYS = { 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' }
local MONTHS = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' }

--- Convert Lua os.date wday (1=Sun..7=Sat) to ISO weekday (1=Mon..7=Sun)
---@param wday integer
---@return integer
local function iso_weekday(wday)
  return (wday - 2) % 7 + 1
end

---@param today? table  os.date('*t') override for testing
---@return table
local function resolve_today(today)
  return today or os.date '*t'
end

--- Format integer with comma separators (e.g. 1247 → "1,247")
---@param n integer
---@return string
local function format_number(n)
  local s = tostring(n)
  return s:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
end

--- count → level. 0→0, 1→1, 2-3→2, 4-7→3, 8+→4
---@param count integer
---@return integer  0..4
function M.bucket(count)
  if count <= 0 then
    return 0
  end
  return math.min(4, math.ceil(math.log(count + 1) / math.log(2)))
end

--- Build a 7×26 grid of activity levels.
--- grid[row][col]: row 1=Mon..7=Sun, col 1=oldest week..26=current week.
--- Future cells (after today in the current week) are marked -1.
---@param data table<string, integer>
---@param today? table
---@return integer[][]
function M.build_grid(data, today)
  local t = resolve_today(today)
  local iw = iso_weekday(t.wday)

  -- Monday of the current week (col 26)
  local mon_ts = os.time { year = t.year, month = t.month, day = t.day - (iw - 1), hour = 12 }
  local mon_d = os.date('*t', mon_ts)
  -- Monday of col 1 (25 weeks earlier)
  local start_ts = os.time { year = mon_d.year, month = mon_d.month, day = mon_d.day - 25 * 7, hour = 12 }
  local start_d = os.date('*t', start_ts)

  local today_str = string.format('%04d-%02d-%02d', t.year, t.month, t.day)

  local grid = {}
  for row = 1, 7 do
    grid[row] = {}
    for col = 1, 26 do
      local offset = (col - 1) * 7 + (row - 1)
      local cell_ts = os.time {
        year = start_d.year,
        month = start_d.month,
        day = start_d.day + offset,
        hour = 12,
      }
      local cell_str = os.date('%Y-%m-%d', cell_ts)
      if cell_str > today_str then
        grid[row][col] = FUTURE
      else
        grid[row][col] = M.bucket(data[cell_str] or 0)
      end
    end
  end

  return grid
end

--- Compute aggregate statistics from the data table.
---@param data table<string, integer>
---@param today? table
---@return { total: integer, active_days: integer, streak: integer }
function M.stats(data, today)
  local total = 0
  local active_days = 0
  for _, count in pairs(data) do
    total = total + count
    if count > 0 then
      active_days = active_days + 1
    end
  end

  -- Streak: consecutive days with activity, ending at today (or yesterday if
  -- today has no activity yet — grace period for the current day).
  local t = resolve_today(today)
  local today_str = string.format('%04d-%02d-%02d', t.year, t.month, t.day)
  local streak = 0

  local check_ts
  if data[today_str] and data[today_str] > 0 then
    check_ts = os.time { year = t.year, month = t.month, day = t.day, hour = 12 }
  else
    check_ts = os.time { year = t.year, month = t.month, day = t.day - 1, hour = 12 }
  end

  while true do
    local ds = os.date('%Y-%m-%d', check_ts)
    if data[ds] and data[ds] > 0 then
      streak = streak + 1
      local d = os.date('*t', check_ts)
      check_ts = os.time { year = d.year, month = d.month, day = d.day - 1, hour = 12 }
    else
      break
    end
  end

  return { total = total, active_days = active_days, streak = streak }
end

--- Build the month-labels row as snacks.dashboard.Text segments.
--- Labels appear at columns where a new month begins.
---@param today? table
---@return snacks.dashboard.Text[]
function M.month_labels_row(today)
  local t = resolve_today(today)
  local iw = iso_weekday(t.wday)

  local mon_ts = os.time { year = t.year, month = t.month, day = t.day - (iw - 1), hour = 12 }
  local mon_d = os.date('*t', mon_ts)
  local start_ts = os.time { year = mon_d.year, month = mon_d.month, day = mon_d.day - 25 * 7, hour = 12 }
  local start_d = os.date('*t', start_ts)

  -- Determine the month of each column's Monday
  local col_months = {}
  for col = 1, 26 do
    local ts = os.time {
      year = start_d.year,
      month = start_d.month,
      day = start_d.day + (col - 1) * 7,
      hour = 12,
    }
    col_months[col] = os.date('*t', ts).month
  end

  -- Identify columns where a new month starts
  local labels = {}
  for col = 1, 26 do
    if col == 1 or col_months[col] ~= col_months[col - 1] then
      labels[#labels + 1] = { col = col, name = MONTHS[col_months[col]] }
    end
  end

  -- Drop overlapping labels (each label occupies 3 character columns)
  local filtered = {}
  local last_end = -1
  for _, label in ipairs(labels) do
    local pos = (label.col - 1) * 2
    if pos >= last_end then
      filtered[#filtered + 1] = label
      last_end = pos + 3
    end
  end

  -- Assemble text segments
  local segments = {}
  local cursor = 0

  -- 4-char prefix to align with weekday row labels ("Mon ")
  segments[#segments + 1] = { '    ' }

  for _, label in ipairs(filtered) do
    local pos = (label.col - 1) * 2
    if pos > cursor then
      segments[#segments + 1] = { string.rep(' ', pos - cursor) }
    end
    segments[#segments + 1] = { label.name, hl = 'SnacksDashboardDesc' }
    cursor = pos + 3
  end

  return segments
end

--- Build 7 data rows, one per weekday (Mon..Sun).
---@param grid integer[][]
---@return snacks.dashboard.Text[][]  7 elements, each an array of segments
function M.data_rows(grid)
  local rows = {}
  for row = 1, 7 do
    local segments = {}
    -- Weekday label prefix (3 chars + 1 space)
    segments[#segments + 1] = { WEEKDAYS[row] .. ' ', hl = 'SnacksDashboardDesc' }
    for col = 1, 26 do
      local level = grid[row][col]
      if level == FUTURE then
        segments[#segments + 1] = { '  ' } -- blank placeholder
      else
        segments[#segments + 1] = { ICON .. ' ', hl = 'HeatmapL' .. level }
      end
    end
    rows[row] = segments
  end
  return rows
end

--- Build the footer row: legend + statistics.
---@param data table<string, integer>
---@param today? table
---@return snacks.dashboard.Text[]
function M.footer(data, today)
  local s = M.stats(data, today)
  local segments = {}

  -- 4-char prefix
  segments[#segments + 1] = { '    ' }

  -- Legend: Less □ □ □ □ □ More
  segments[#segments + 1] = { 'Less ', hl = 'SnacksDashboardDesc' }
  for level = 0, 4 do
    segments[#segments + 1] = { ICON .. ' ', hl = 'HeatmapL' .. level }
  end
  segments[#segments + 1] = { 'More', hl = 'SnacksDashboardDesc' }

  -- Statistics
  segments[#segments + 1] = { '  ' }
  segments[#segments + 1] = {
    string.format('%s edits · %d days · streak %d', format_number(s.total), s.active_days, s.streak),
    hl = 'SnacksDashboardDesc',
  }

  return segments
end

return M
