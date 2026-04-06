local M = {}

--- Register BufWritePost autocmd. Idempotent: repeated calls clear the old group.
function M.setup()
  local group = vim.api.nvim_create_augroup('HeatmapCollector', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].buftype ~= '' then
        return
      end
      if args.file == '' then
        return
      end
      require('plugins.ui.dashboard.heatmap.store').increment_today()
    end,
  })
end

return M
