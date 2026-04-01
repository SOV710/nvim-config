return {
  -- ── General ──────────────────────────────────────────────────────────

  { '<Space>', '<Nop>', mode = { 'n', 'v' }, desc = 'Disable space default' },
  { '<Esc>', '<cmd>nohlsearch<CR>', desc = 'Clear search highlights' },
  {
    '<C-a>',
    function()
      local view = vim.fn.winsaveview()
      local saved_ei = vim.o.eventignore
      vim.o.eventignore = 'CursorMoved,CursorMovedI,WinScrolled'
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = { 'v:*', 'V:*', '\x16:*' }, -- leave visual (char/line/block)
        once = true,
        callback = function()
          if vim.api.nvim_buf_line_count(0) >= view.lnum then
            vim.fn.winrestview(view)
          end
          vim.o.eventignore = saved_ei
        end,
      })
      vim.cmd 'normal! ggVG'
    end,
    desc = 'Select all',
  },

  -- ── Insert / Command-line mode enhancements ──────────────────────────

  { '<C-CR>', '<End><CR>', mode = 'i', desc = 'End line and enter' },
  { '<C-S-V>', '<C-r>"', mode = { 'i', 'c' }, desc = 'Paste from register' },
  { '<S-Insert>', '<C-r>+', mode = { 'i', 'c' }, desc = 'Paste from clipboard' },
  { '<C-BS>', '<C-w>', mode = { 'i', 'c' }, desc = 'Delete word before' },
  { '<C-Delete>', '<C-Right><C-w>', mode = { 'i', 'c' }, desc = 'Delete word after' },

  -- ── Undo break-points ────────────────────────────────────────────────

  { ',', ',<c-g>u', mode = 'i', desc = 'Undo break-point' },
  { '.', '.<c-g>u', mode = 'i', desc = 'Undo break-point' },
  { ';', ';<c-g>u', mode = 'i', desc = 'Undo break-point' },

  -- ── Terminal mode ────────────────────────────────────────────────────

  { '<C-S-V>', '<cmd>stopinsert<CR>pi', mode = 't', desc = 'Paste' },
  { '<S-Insert>', '<cmd>stopinsert<CR>pi', mode = 't', desc = 'Paste' },
  { '<Esc><Esc>', '<cmd>stopinsert<CR>', mode = 't', desc = 'Exit terminal mode' },

  -- ── Better j/k (wrap-aware) ─────────────────────────────────────────

  { 'j', "v:count == 0 ? 'gj' : 'j'", mode = { 'n', 'x' }, desc = 'Down', expr = true },
  { 'k', "v:count == 0 ? 'gk' : 'k'", mode = { 'n', 'x' }, desc = 'Up', expr = true },

  -- ── Move lines with Ctrl+j/k ────────────────────────────────────────

  { '<C-j>', '<esc><cmd>m .+1<cr>==gi', mode = 'i', desc = 'Move Down' },
  { '<C-k>', '<esc><cmd>m .-2<cr>==gi', mode = 'i', desc = 'Move Up' },
  { '<C-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", mode = 'v', desc = 'Move Down' },
  { '<C-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", mode = 'v', desc = 'Move Up' },

  -- ── Saner n/N direction ──────────────────────────────────────────────

  { 'n', "'Nn'[v:searchforward].'zv'", desc = 'Next Search Result', expr = true },
  { 'N', "'nN'[v:searchforward].'zv'", desc = 'Prev Search Result', expr = true },
  { 'n', "'Nn'[v:searchforward]", mode = { 'x', 'o' }, desc = 'Next Search Result', expr = true },
  { 'N', "'nN'[v:searchforward]", mode = { 'x', 'o' }, desc = 'Prev Search Result', expr = true },

  -- ── Scrolling ────────────────────────────────────────────────────────

  { '<C-d>', '<C-d>zz', desc = 'Scroll down and center' },
  { '<C-u>', '<C-u>zz', desc = 'Scroll up and center' },

  -- ── Delete without register ─────────────────────────────────────────

  { 'x', '"_x', desc = 'Delete char without register' },
  { 'dl', '"_dl', desc = 'Delete char-right without register' },

  -- ── Indenting (keep selection) ───────────────────────────────────────

  { '<', '<gv', mode = 'v', desc = 'Indent left (keep sel)' },
  { '>', '>gv', mode = 'v', desc = 'Indent right (keep sel)' },

  -- ── Save / Quit ─────────────────────────────────────────────────────

  { '<C-s>', '<cmd>w<cr><esc>', mode = { 'i', 'x', 'n', 's' }, desc = 'Save File' },
  { '<leader>sN', '<cmd>noautocmd w<CR>', desc = 'Save without auto-formatting' },
  { '<leader>qq', '<cmd>qa<cr>', desc = 'Quit All' },

  -- ── Diagnostics ─────────────────────────────────────────────────────

  {
    '<leader>n',
    function()
      local float_buf, float_win = vim.diagnostic.open_float(nil, {
        scope = 'line',
        focus = false,
        focusable = true,
        close_events = {},
      })

      if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.cmd(('noautocmd call nvim_set_current_win(%d)'):format(float_win))

        vim.keymap.set('n', '<Esc>', function()
          vim.api.nvim_win_close(float_win, true)
        end, { buffer = float_buf, nowait = true, silent = true, desc = 'Close diagnostic float' })

        vim.keymap.set('n', 'q', function()
          vim.api.nvim_win_close(float_win, true)
        end, { buffer = float_buf, nowait = true, silent = true, desc = 'Close diagnostic float' })
      end
    end,
    desc = 'Open diagnostic float and focus',
  },

  -- ── UI ──────────────────────────────────────────────────────────────

  { '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', desc = 'Redraw / Clear highlights' },
  { '<leader>L', '<cmd>Lazy<CR>', desc = 'Lazy' },
}
