return {
  'tpope/vim-fugitive',
  cmd = {
    'Git',
    'Gwrite',       -- stage current file (like git add)
    'Gread',        -- checkout current file (discard changes)
    'Gdiffsplit',   -- side-by-side diff of staged vs working
    'Gvdiffsplit',  -- vertical side-by-side diff
    'GMove',        -- rename file and update buffer
    'GRename',      -- rename within same directory
    'GDelete',      -- delete file and buffer
    'GRemove',      -- alias for GDelete
    'GBrowse',      -- open on web hosting provider
    'Ggrep',        -- git grep
    'Gedit',        -- view any blob/tree/commit/tag
  },
  keys = require 'core.keymaps.git.fugitive',
}
