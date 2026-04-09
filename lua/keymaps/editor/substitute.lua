return {
  -- ══════════════════════════════════════════════════════════════════
  -- ── Exchange ───────────────────────────────────────────────────────
  -- ══════════════════════════════════════════════════════════════════
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
  -- ══════════════════════════════════════════════════════════════════
  -- ── Substitute (paste-over without polluting register) ──────────
  -- ══════════════════════════════════════════════════════════════════
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

  -- ══════════════════════════════════════════════════════════════════
  -- Range substitute — <leader>S namespace
  --
  -- Usage pattern: <leader>S<motion1><motion2>
  --   motion1 = what to replace (subject)
  --   motion2 = where to apply (range)
  -- Then command line opens pre-filled, type replacement, <CR> to apply.
  -- ══════════════════════════════════════════════════════════════════

  -- ── Base operator (you pick both subject and range) ──────────────
  {
    '<leader>S',
    function()
      require('substitute.range').operator()
    end,
    desc = 'Range substitute (pick subject + range)',
  },
  {
    '<leader>S',
    function()
      require('substitute.range').visual()
    end,
    mode = 'x',
    desc = 'Range substitute (visual selection as subject)',
  },

  -- ── Cursor word as subject ───────────────────────────────────────
  -- <leader>Ss<motion> → replace current <cword> in <motion> range
  -- (this is substitute.nvim's built-in .word() convenience)
  {
    '<leader>Ss',
    function()
      require('substitute.range').word()
    end,
    desc = 'Range substitute [s]cword (pick range)',
  },

  -- ── Subject presets (subject fixed, you pick range) ──────────────
  {
    '<leader>Sw',
    function()
      require('substitute.range').operator { subject = { motion = 'iw' } }
    end,
    desc = 'Range substitute inner [w]ord (pick range)',
  },
  {
    '<leader>SW',
    function()
      require('substitute.range').operator {
        subject = { motion = 'iW' },
      }
    end,
    desc = 'Range substitute inner [W]ORD (pick range)',
  },
  {
    '<leader>S"',
    function()
      require('substitute.range').operator {
        subject = { motion = 'i"' },
        range = '%',
      }
    end,
    desc = 'Range substitute inside ["] (pick range)',
  },
  {
    "<leader>S'",
    function()
      require('substitute.range').operator {
        subject = { motion = "i'" },
        range = '%',
      }
    end,
    desc = "Range substitute inside ['] (pick range)",
  },

  -- ── Last search as subject ───────────────────────────────────────
  -- After pressing * / / / ?, run this to replace matches in a range
  {
    '<leader>S/',
    function()
      require('substitute.range').operator { subject = { last_search = true } }
    end,
    desc = 'Range substitute last search [/] (pick range)',
  },

  -- ══════════════════════════════════════════════════════════════════
  -- Combined presets — subject AND range both fixed
  -- These are one-press operators for very common refactor patterns.
  -- ══════════════════════════════════════════════════════════════════

  -- ── cword in whole file (most common refactor shortcut) ──────────
  {
    '<leader>Swf',
    function()
      require('substitute.range').operator {
        subject = { expand = '<cword>' },
        range = '%',
      }
    end,
    desc = 'Replace [w]ord in whole [f]ile',
  },

  -- ── cWORD in whole file ──────────────────────────────────────────
  {
    '<leader>SWf',
    function()
      require('substitute.range').operator {
        subject = { expand = '<cWORD>' },
        range = '%',
      }
    end,
    desc = 'Replace [W]ORD in whole [f]ile',
  },

  -- ── last search in whole file ────────────────────────────────────
  -- Workflow: `*` to search cword, N to go back, then <leader>S/R
  {
    '<leader>S/r',
    function()
      require('substitute.range').operator {
        subject = { last_search = true },
        range = '%',
      }
    end,
    desc = 'Replace last search in whole file',
  },
}
