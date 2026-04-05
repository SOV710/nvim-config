-- Snacks.gitbrowse — open current file/line/selection in browser.
-- Merges into the main folke/snacks.nvim spec via lazy.nvim spec merging.
return {
  'folke/snacks.nvim',
  keys = require 'core.keymaps.git.gitbrowse',
  opts = {
    gitbrowse = {
      notify = true, -- show notification when opening URL
      -- what to open: 'repo'|'branch'|'file'|'commit'|'permalink'
      -- defaults to 'permalink' for visual selections, 'file' otherwise
      what = 'file',
      -- remote_patterns: transform SSH/HTTPS remotes to browsable URLs
      -- (leave empty to use Snacks defaults for GitHub/GitLab/Bitbucket/Azure)
      remote_patterns = {},
      -- url_patterns: domain-keyed URL templates (leave empty for defaults)
      url_patterns = {},
    },
  },
}
