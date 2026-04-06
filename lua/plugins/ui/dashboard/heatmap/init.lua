local M = {}

--- Return a snacks.dashboard section table for the heatmap.
--- Call this inside the dashboard sections list; it loads fresh data each time.
---@param opts? { palette?: string }
---@return snacks.dashboard.Section
function M.section(opts)
  opts = opts or {}
  local palette_name = opts.palette or 'tokyo_night'

  require('plugins.ui.dashboard.heatmap.palette').apply(palette_name)

  local store = require 'plugins.ui.dashboard.heatmap.store'
  local render = require 'plugins.ui.dashboard.heatmap.render'

  local data = store.load()
  local grid = render.build_grid(data)

  -- Assemble all lines into a flat array of text segments separated by "\n"
  local text = {}

  -- Month labels row
  for _, seg in ipairs(render.month_labels_row()) do
    text[#text + 1] = seg
  end
  text[#text + 1] = { '\n' }

  -- 7 data rows (Mon..Sun)
  local rows = render.data_rows(grid)
  for i, row in ipairs(rows) do
    for _, seg in ipairs(row) do
      text[#text + 1] = seg
    end
    if i < 7 then
      text[#text + 1] = { '\n' }
    end
  end

  -- Blank line then footer
  text[#text + 1] = { '\n' }
  text[#text + 1] = { '\n' }
  for _, seg in ipairs(render.footer(data)) do
    text[#text + 1] = seg
  end

  return {
    text = text,
    align = 'left',
    padding = 1,
    indent = 2,
  }
end

--- Start the BufWritePost collector. Call once during plugin init.
function M.setup()
  require('plugins.ui.dashboard.heatmap.collector').setup()
end

return M
