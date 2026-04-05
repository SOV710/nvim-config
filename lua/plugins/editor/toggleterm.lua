return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = 'ToggleTerm',
  keys = {
    { [[<C-\>]], '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal', mode = { 'n', 't' } },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Float terminal' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Horizontal terminal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', desc = 'Vertical terminal' },
    {
      '<leader>tg',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new {
          cmd = 'lazygit',
          direction = 'float',
          hidden = true,
          float_opts = { border = 'rounded', width = math.floor(vim.o.columns * 0.9), height = math.floor(vim.o.lines * 0.9) },
        }
        lazygit:toggle()
      end,
      desc = 'Lazygit',
    },
  },
  opts = {
    size = function(term) -- direction-aware terminal size
      if term.direction == 'horizontal' then
        return 15 -- rows for horizontal split
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4) -- 40% width for vertical
      end
    end,

    open_mapping = false, -- we handle mapping via `keys` above
    direction = 'float', -- default direction: "float"|"horizontal"|"vertical"|"tab"
    shell = vim.o.shell, -- shell to use (defaults to user's shell)
    shade_terminals = false, -- don't dim inactive terminal background
    start_in_insert = true, -- enter insert mode when opening terminal
    insert_mappings = false, -- don't add open mapping in insert mode
    terminal_mappings = true, -- add open mapping in terminal mode
    persist_size = true, -- remember terminal size across toggles
    persist_mode = true, -- remember insert/normal mode across toggles
    close_on_exit = true, -- auto-close when shell process exits
    auto_scroll = true, -- scroll to bottom on output

    float_opts = {
      border = 'rounded', -- border style: "none"|"single"|"double"|"rounded"
      width = 100, -- float width in columns
      height = 30, -- float height in rows
      winblend = 0, -- window transparency (0=opaque)
      title_pos = 'center', -- title position: "left"|"center"|"right"
    },
  },
}
