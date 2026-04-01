return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  keys = require 'core.keymaps.editor.grug-far',
  opts = {
    engine = 'ripgrep',                    -- search engine: "ripgrep"|"astgrep"
    startInInsertMode = true,              -- start with cursor in insert mode
    startCursorRow = 3,                    -- initial cursor row (search input line)
    transient = false,                     -- close grug-far buffer on window close
    folding = {
      enabled = true,                      -- enable folding in results
      foldlevel = 0,                       -- initial fold level (0 = all folded)
    },
    resultLocation = {
      showNumberLabel = true,              -- show result number labels
    },
    keymaps = {
      replace = { n = '<localleader>r' },       -- replace all matches
      qflist = { n = '<localleader>q' },        -- send results to quickfix
      syncLocations = { n = '<localleader>s' }, -- sync changes back to files
      syncLine = { n = '<localleader>l' },      -- sync current line changes
      close = { n = 'q' },                      -- close grug-far window
      historyOpen = { n = '<localleader>t' },   -- open search history
      historyAdd = { n = '<localleader>a' },    -- add current search to history
      refresh = { n = '<localleader>f' },       -- refresh results
      openLocation = { n = '<localleader>o' },  -- open file at result location
      openNextLocation = { n = '<down>' },      -- open next result location
      openPrevLocation = { n = '<up>' },        -- open previous result location
      gotoLocation = { n = '<enter>' },         -- go to result location
      pickHistoryEntry = { n = '<enter>' },     -- pick history entry
      abort = { n = '<localleader>b' },         -- abort current search/replace
      help = { n = 'g?' },                      -- show help
      toggleShowCommand = { n = '<localleader>p' }, -- toggle showing rg command
      swapEngine = { n = '<localleader>e' },    -- swap between ripgrep/astgrep
      previewLocation = { n = '<localleader>i' }, -- preview result in split
      swapReplacementInterpreter = { n = '<localleader>x' }, -- swap replacement mode
    },
    windowCreationCommand = 'split',       -- command to create window: "split"|"vsplit"|"tabnew"
  },
}
