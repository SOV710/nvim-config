local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────────

-- Disable the spacebar key's default behavior in Normal and Visual modes
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Select all
map('n', '<C-a>', "m'ggVG", { silent = true, desc = 'Select all' })

-- ── Insert / Command-line mode enhancements ──────────────────────────

map('i', '<C-CR>', '<End><CR>', { desc = 'End line and enter' })
map({ 'i', 'c' }, '<C-S-V>', '<C-r>"', { desc = 'Paste from register' })
map({ 'i', 'c' }, '<S-Insert>', '<C-r>+', { desc = 'Paste from clipboard' })
map({ 'i', 'c' }, '<C-BS>', '<C-w>', { desc = 'Delete word before' })
map({ 'i', 'c' }, '<C-Delete>', '<C-Right><C-w>', { desc = 'Delete word after' })

-- ── Undo break-points ────────────────────────────────────────────────

map('i', ',', ',<c-g>u', { desc = 'Undo break-point' })
map('i', '.', '.<c-g>u', { desc = 'Undo break-point' })
map('i', ';', ';<c-g>u', { desc = 'Undo break-point' })

-- ── Terminal mode ────────────────────────────────────────────────────

map('t', '<C-S-V>', '<cmd>stopinsert<CR>pi', { desc = 'Paste' })
map('t', '<S-Insert>', '<cmd>stopinsert<CR>pi', { desc = 'Paste' })
map('t', '<Esc><Esc>', '<cmd>stopinsert<CR>', { desc = 'Exit terminal mode' })

-- ── Better j/k (wrap-aware) ─────────────────────────────────────────

map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- ── Move lines with Ctrl+j/k ────────────────────────────────────────

map('v', '<C-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down', silent = true })
map('v', '<C-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up', silent = true })

-- ── Saner n/N direction ──────────────────────────────────────────────

map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- ── Scrolling ────────────────────────────────────────────────────────

map('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true, desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true, desc = 'Scroll up and center' })

-- ── Delete without register ─────────────────────────────────────────

map('n', 'x', '"_x', { noremap = true, silent = true, desc = 'Delete char without register' })
map('n', 'dl', '"_dl', { noremap = true, silent = true, desc = 'Delete char-right without register' })

-- ── Indenting (keep selection) ───────────────────────────────────────

map('v', '<', '<gv', { desc = 'Indent left (keep sel)' })
map('v', '>', '>gv', { desc = 'Indent right (keep sel)' })

-- ── Save / Quit ─────────────────────────────────────────────────────

map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
map('n', '<leader>sn', '<cmd>noautocmd w<CR>', { noremap = true, silent = true, desc = 'Save without auto-formatting' })
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- ── Diagnostics ─────────────────────────────────────────────────────

map('n', '<leader>n', function()
  local float_buf, float_win = vim.diagnostic.open_float(nil, {
    scope = 'line',
    focus = false,
    focusable = true,
    close_events = {},
  })

  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.cmd(('noautocmd call nvim_set_current_win(%d)'):format(float_win))

    map('n', '<Esc>', function()
      vim.api.nvim_win_close(float_win, true)
    end, { buffer = float_buf, nowait = true, silent = true, desc = 'Close diagnostic float' })

    map('n', 'q', function()
      vim.api.nvim_win_close(float_win, true)
    end, { buffer = float_buf, nowait = true, silent = true, desc = 'Close diagnostic float' })
  end
end, { desc = 'Open diagnostic float and focus', silent = true })

-- ── UI ──────────────────────────────────────────────────────────────

map('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear highlights' })
map('n', '<leader>l', '<cmd>Lazy<CR>', { desc = 'Lazy' })
