return {
  -- ── Exchange ───────────────────────────────────────────────────────
  { 'cx', function() require('substitute.exchange').operator() end, desc = 'Exchange operator' },
  { 'cxx', function() require('substitute.exchange').line() end, desc = 'Exchange line' },
  { 'X', function() require('substitute.exchange').visual() end, desc = 'Exchange visual', mode = 'x' },
  { 'cxc', function() require('substitute.exchange').cancel() end, desc = 'Cancel exchange' },
}
