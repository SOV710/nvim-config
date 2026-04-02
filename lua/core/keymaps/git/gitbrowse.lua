return {
  -- ── gitbrowse ─────────────────────────────────────────────────────

  {
    '<leader>go',
    function() Snacks.gitbrowse() end,
    desc = 'Open file in browser',
    mode = { 'n', 'v' },  -- visual sends selected line range
  },
  {
    '<leader>gO',
    function() Snacks.gitbrowse { what = 'repo' } end,
    desc = 'Open repo in browser',
  },
}
