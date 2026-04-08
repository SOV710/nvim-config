return {
  -- ── Exchange ───────────────────────────────────────────────────────
  {
    'cx',
    function()
      require('substitute.exchange').operator()
    end,
    desc = 'Exchange operator',
  },
  {
    'cxx',
    function()
      require('substitute.exchange').line()
    end,
    desc = 'Exchange line',
  },
  {
    'X',
    function()
      require('substitute.exchange').visual()
    end,
    desc = 'Exchange visual',
    mode = 'x',
  },
  {
    'cxc',
    function()
      require('substitute.exchange').cancel()
    end,
    desc = 'Cancel exchange',
  },
  -- ── Substitute (paste-over without polluting register) ──────────
  {
    'gs',
    function()
      require('substitute').operator()
    end,
    desc = 'Substitute operator',
  },
  {
    'gss',
    function()
      require('substitute').line()
    end,
    desc = 'Substitute line',
  },
  {
    'gS',
    function()
      require('substitute').eol()
    end,
    desc = 'Substitute to EOL',
  },
  {
    'gs',
    function()
      require('substitute').visual()
    end,
    desc = 'Substitute visual',
    mode = 'x',
  },
}
