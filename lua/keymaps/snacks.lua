return {
  -- ── Buffer ───────────────────────────────────────────────────────

  {
    '<leader>bd',
    function()
      Snacks.bufdelete()
    end,
    desc = 'Delete buffer',
  },
  {
    '<leader>bo',
    function()
      Snacks.bufdelete.other()
    end,
    desc = 'Delete other buffers',
  },
  {
    '<leader>bD',
    function()
      Snacks.bufdelete { force = true }
    end,
    desc = 'Force delete buffer',
  },

  -- ── File ─────────────────────────────────────────────────────────

  {
    '<leader>fn',
    function()
      Snacks.rename.rename_file()
    end,
    desc = 'Rename file',
  },
  {
    '<leader>fs',
    function()
      Snacks.scratch.open()
    end,
    desc = 'Scratch buffer',
  },
  {
    '<leader>fe',
    function()
      Snacks.scratch.select()
    end,
    desc = 'Select scratch',
  },

  -- ── Explorer ────────────────────────────────────────────────────────

  {
    '<leader>e',
    function()
      Snacks.explorer()
    end,
    desc = 'Explorer sidebar',
  },

  -- ── Picker (find) ──────────────────────────────────────────────────

  {
    '<leader>sf',
    function()
      Snacks.picker.files()
    end,
    desc = 'Find files',
  },
  {
    '<leader>sg',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Grep',
  },
  {
    '<leader>sw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = 'Grep current word',
    mode = { 'n', 'x' },
  },
  {
    '<leader>sb',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Buffers',
  },
  {
    '<leader>sh',
    function()
      Snacks.picker.help()
    end,
    desc = 'Help tags',
  },
  {
    '<leader>sk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    '<leader>sd',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = 'Diagnostics',
  },
  {
    '<leader>sr',
    function()
      Snacks.picker.resume()
    end,
    desc = 'Resume last picker',
  },
  {
    '<leader>s.',
    function()
      Snacks.picker.recent()
    end,
    desc = 'Recent files',
  },
  {
    '<leader>s/',
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = 'Grep open buffers',
  },
  {
    '<leader>sc',
    function()
      Snacks.picker.commands()
    end,
    desc = 'Commands',
  },
  {
    '<leader>sm',
    function()
      Snacks.picker.marks()
    end,
    desc = 'Marks',
  },
  {
    '<leader>sR',
    function()
      Snacks.picker.registers()
    end,
    desc = 'Registers',
  },
  {
    '<leader>sn',
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Neovim config files',
  },

  -- ── Picker (shortcuts) ─────────────────────────────────────────────

  {
    '<leader><leader>',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Buffers',
  },
  {
    '<leader>/',
    function()
      Snacks.picker.lines()
    end,
    desc = 'Search current buffer',
  },

  -- ── Picker (git) ───────────────────────────────────────────────────

  {
    '<leader>gf',
    function()
      Snacks.picker.git_files()
    end,
    desc = 'Git files',
  },
  {
    '<leader>gs',
    function()
      Snacks.picker.git_status()
    end,
    desc = 'Git status',
  },
  {
    '<leader>gl',
    function()
      Snacks.picker.git_log()
    end,
    desc = 'Git log',
  },

  -- ── Picker (LSP) ──────────────────────────────────────────────────

  {
    '<leader>ls',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = 'Document symbols',
  },
  {
    '<leader>lS',
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = 'Workspace symbols',
  },
}
