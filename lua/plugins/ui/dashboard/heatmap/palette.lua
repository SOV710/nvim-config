local M = {}

M.palettes = {
  tokyo_night = { '#2a2f3d', '#3d59a1', '#7aa2f7', '#7dcfff', '#bb9af7' },
  github      = { '#161b22', '#0e4429', '#006d32', '#26a641', '#39d353' },
  heat        = { '#2a1f1a', '#5a2e1f', '#a84620', '#e8601c', '#ffb020' },
  ocean       = { '#1a2332', '#164e63', '#0891b2', '#22c5aa', '#7ee8b8' },
}

---@param name string
function M.apply(name)
  local colors = M.palettes[name]
  if not colors then
    vim.notify(
      '[heatmap] unknown palette "' .. name .. '", falling back to tokyo_night',
      vim.log.levels.WARN
    )
    colors = M.palettes.tokyo_night
  end
  for i, color in ipairs(colors) do
    vim.api.nvim_set_hl(0, 'HeatmapL' .. (i - 1), { fg = color })
  end
end

return M
