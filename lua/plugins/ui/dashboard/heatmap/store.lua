local M = {}

---@return string
function M.path()
  return vim.fn.stdpath('data') .. '/heatmap.json'
end

---@return table<string, integer>
function M.load()
  local f = io.open(M.path(), 'r')
  if not f then
    return {}
  end
  local content = f:read('*a')
  f:close()
  if not content or content == '' then
    return {}
  end
  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= 'table' then
    return {}
  end
  return data
end

---@param data table<string, integer>
function M.save(data)
  local f = io.open(M.path(), 'w')
  if not f then
    vim.notify('[heatmap] failed to write ' .. M.path(), vim.log.levels.WARN)
    return
  end
  f:write(vim.json.encode(data))
  f:close()
end

---@return integer  new count for today
function M.increment_today()
  local data = M.load()
  local today = os.date('%Y-%m-%d')
  data[today] = (data[today] or 0) + 1
  M.save(data)
  return data[today]
end

---@param date_str string  "YYYY-MM-DD"
---@return integer
function M.get(date_str)
  local data = M.load()
  return data[date_str] or 0
end

return M
