-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

-- Diagnostic keymaps using native vim.diagnostic API.

local function copy_to_clipboard(text, msg)
  vim.fn.setreg('+', text)
  vim.notify(msg)
end

local function format_diag(fname, d)
  local sev = vim.diagnostic.severity[d.severity]
  return string.format('%s:%d:%d: [%s] %s', fname, d.lnum + 1, d.col + 1, sev, d.message)
end

local function copy_under_cursor()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local diags = vim.diagnostic.get(0, { lnum = lnum })
  if #diags == 0 then
    vim.notify('No diagnostic on this line', vim.log.levels.WARN)
    return
  end
  local target
  for _, d in ipairs(diags) do
    if col >= d.col and col <= (d.end_col or d.col) then
      target = d
      break
    end
  end
  target = target or diags[1]
  local text = string.format('[%s%s] %s', target.source or '?', target.code and (':' .. target.code) or '', target.message)
  copy_to_clipboard(text, 'Copied diagnostic')
end

local function copy_buffer()
  local bufnr = 0
  local diags = vim.diagnostic.get(bufnr)
  if #diags == 0 then
    vim.notify('No diagnostics in buffer', vim.log.levels.WARN)
    return
  end
  table.sort(diags, function(a, b)
    if a.lnum ~= b.lnum then
      return a.lnum < b.lnum
    end
    return a.col < b.col
  end)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local lines = {}
  for _, d in ipairs(diags) do
    table.insert(lines, format_diag(fname, d))
  end
  copy_to_clipboard(table.concat(lines, '\n'), string.format('Copied %d diagnostics', #diags))
end

local function copy_workspace()
  local diags = vim.diagnostic.get(nil)
  if #diags == 0 then
    vim.notify('No diagnostics in workspace', vim.log.levels.WARN)
    return
  end
  local by_buf = {}
  for _, d in ipairs(diags) do
    by_buf[d.bufnr] = by_buf[d.bufnr] or {}
    table.insert(by_buf[d.bufnr], d)
  end
  local lines = {}
  for bufnr, buf_diags in pairs(by_buf) do
    local fname = vim.api.nvim_buf_get_name(bufnr)
    table.sort(buf_diags, function(a, b)
      if a.lnum ~= b.lnum then
        return a.lnum < b.lnum
      end
      return a.col < b.col
    end)
    for _, d in ipairs(buf_diags) do
      table.insert(lines, format_diag(fname, d))
    end
  end
  copy_to_clipboard(table.concat(lines, '\n'), string.format('Copied %d diagnostics from %d files', #diags, vim.tbl_count(by_buf)))
end

-- Workspace-wide diagnostic jump.
-- direction: 1 for next, -1 for prev.
local function jump_workspace(direction)
  local all = vim.diagnostic.get(nil)
  if #all == 0 then
    vim.notify('No diagnostics in workspace', vim.log.levels.WARN)
    return
  end

  -- Sort by (bufnr, lnum, col) for a stable global order.
  table.sort(all, function(a, b)
    if a.bufnr ~= b.bufnr then
      return a.bufnr < b.bufnr
    end
    if a.lnum ~= b.lnum then
      return a.lnum < b.lnum
    end
    return a.col < b.col
  end)

  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  local cur_lnum = cur_pos[1] - 1
  local cur_col = cur_pos[2]

  local function is_after(d)
    if d.bufnr ~= cur_buf then
      return d.bufnr > cur_buf
    end
    if d.lnum ~= cur_lnum then
      return d.lnum > cur_lnum
    end
    return d.col > cur_col
  end

  local function is_at_cursor(d)
    return d.bufnr == cur_buf and d.lnum == cur_lnum and d.col == cur_col
  end

  local target
  if direction > 0 then
    for _, d in ipairs(all) do
      if is_after(d) then
        target = d
        break
      end
    end
    target = target or all[1] -- wrap to first
  else
    for i = #all, 1, -1 do
      local d = all[i]
      if not is_after(d) and not is_at_cursor(d) then
        target = d
        break
      end
    end
    target = target or all[#all] -- wrap to last
  end

  if target.bufnr ~= cur_buf then
    vim.api.nvim_set_current_buf(target.bufnr)
  end
  vim.api.nvim_win_set_cursor(0, { target.lnum + 1, target.col })
end

return {
  {
    '<leader>nf',
    function()
      vim.diagnostic.jump { count = 1 }
    end,
    desc = 'Next diagnostic (buffer)',
  },
  {
    '<leader>nd',
    function()
      vim.diagnostic.jump { count = -1 }
    end,
    desc = 'Prev diagnostic (buffer)',
  },
  {
    '<leader>nF',
    function()
      jump_workspace(1)
    end,
    desc = 'Next diagnostic (workspace)',
  },
  {
    '<leader>nD',
    function()
      jump_workspace(-1)
    end,
    desc = 'Prev diagnostic (workspace)',
  },
  {
    '<leader>nc',
    copy_under_cursor,
    desc = 'Copy diagnostic under cursor',
  },
  {
    '<leader>na',
    copy_buffer,
    desc = 'Copy buffer diagnostics',
  },
  {
    '<leader>nA',
    copy_workspace,
    desc = 'Copy workspace diagnostics',
  },
}
