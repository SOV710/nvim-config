return {
  'sindrets/diffview.nvim',
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
  },
  keys = require 'keymaps.git.diffview',
  opts = {
    diff_binaries = false, -- show diffs for binary files
    enhanced_diff_hl = false, -- more granular diff highlighting
    use_icons = true, -- file icons (requires mini.icons or nvim-web-devicons)
    show_help_hints = true, -- show keybind hints in panels
    watch_index = true, -- watch git index for changes

    view = {
      -- Default two-way diff view
      default = {
        layout = 'diff2_horizontal', -- 'diff2_horizontal'|'diff2_vertical'
        disable_diagnostics = true, -- hide diagnostics in diff buffers
        winbar_info = false, -- show info in winbar
      },
      -- Three-way merge conflict view
      merge_tool = {
        layout = 'diff3_horizontal', -- 'diff3_horizontal'|'diff3_vertical'|'diff4_mixed'
        disable_diagnostics = true, -- hide diagnostics in merge buffers
        winbar_info = true, -- show file info in winbar
      },
      -- File history diff view
      file_history = {
        layout = 'diff2_horizontal',
        disable_diagnostics = true,
        winbar_info = false,
      },
    },

    file_panel = {
      listing_style = 'tree', -- 'tree'|'list'
      tree_options = {
        flatten_dirs = true, -- collapse single-child directories
        folder_statuses = 'only_folded', -- 'never'|'only_folded'|'always'
      },
      win_config = {
        position = 'left', -- panel position: 'left'|'right'|'top'|'bottom'
        width = 35, -- panel width in columns
        win_opts = {},
      },
    },

    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            diff_merges = 'combined', -- merge commit diff strategy
            follow = true, -- follow file through renames
          },
          multi_file = {
            diff_merges = 'first-parent', -- merge commit diff strategy
          },
        },
      },
      win_config = {
        position = 'bottom', -- panel position
        height = 16, -- panel height in lines
        win_opts = {},
      },
    },

    -- Internal keymaps for diffview panels (separate from core/keymaps/).
    -- Actions are wrapped in functions so require() is deferred until use.
    keymaps = {
      disable_defaults = false, -- keep all built-in bindings as baseline
      view = {
        {
          'n',
          '<tab>',
          function()
            require('diffview.actions').select_next_entry()
          end,
          { desc = 'Open diff for next file' },
        },
        {
          'n',
          '<s-tab>',
          function()
            require('diffview.actions').select_prev_entry()
          end,
          { desc = 'Open diff for previous file' },
        },
        {
          'n',
          'gf',
          function()
            require('diffview.actions').goto_file_tab()
          end,
          { desc = 'Open file in new tabpage' },
        },
        {
          'n',
          '<leader>e',
          function()
            require('diffview.actions').focus_files()
          end,
          { desc = 'Bring focus to file panel' },
        },
        {
          'n',
          '<leader>b',
          function()
            require('diffview.actions').toggle_files()
          end,
          { desc = 'Toggle file panel' },
        },
        {
          'n',
          'g?',
          function()
            require('diffview.actions').help 'view'
          end,
          { desc = 'Open keybind help panel' },
        },
      },
      file_panel = {
        {
          'n',
          'j',
          function()
            require('diffview.actions').next_entry()
          end,
          { desc = 'Next file entry' },
        },
        {
          'n',
          'k',
          function()
            require('diffview.actions').prev_entry()
          end,
          { desc = 'Previous file entry' },
        },
        {
          'n',
          '<cr>',
          function()
            require('diffview.actions').select_entry()
          end,
          { desc = 'Open diff for selected entry' },
        },
        {
          'n',
          's',
          function()
            require('diffview.actions').toggle_stage_entry()
          end,
          { desc = 'Stage / unstage entry' },
        },
        {
          'n',
          '-',
          function()
            require('diffview.actions').toggle_stage_entry()
          end,
          { desc = 'Stage / unstage (alias)' },
        },
        {
          'n',
          'S',
          function()
            require('diffview.actions').stage_all()
          end,
          { desc = 'Stage all entries' },
        },
        {
          'n',
          'U',
          function()
            require('diffview.actions').unstage_all()
          end,
          { desc = 'Unstage all entries' },
        },
        {
          'n',
          'X',
          function()
            require('diffview.actions').restore_entry()
          end,
          { desc = 'Restore entry to left-side state' },
        },
        {
          'n',
          'zo',
          function()
            require('diffview.actions').open_fold()
          end,
          { desc = 'Expand fold' },
        },
        {
          'n',
          'zc',
          function()
            require('diffview.actions').close_fold()
          end,
          { desc = 'Collapse fold' },
        },
        {
          'n',
          'za',
          function()
            require('diffview.actions').toggle_fold()
          end,
          { desc = 'Toggle fold' },
        },
        {
          'n',
          '<leader>e',
          function()
            require('diffview.actions').focus_files()
          end,
          { desc = 'Bring focus to file panel' },
        },
        {
          'n',
          '<leader>b',
          function()
            require('diffview.actions').toggle_files()
          end,
          { desc = 'Toggle file panel' },
        },
        {
          'n',
          'g?',
          function()
            require('diffview.actions').help 'file_panel'
          end,
          { desc = 'Open keybind help panel' },
        },
      },
      file_history_panel = {
        {
          'n',
          'j',
          function()
            require('diffview.actions').next_entry()
          end,
          { desc = 'Next entry' },
        },
        {
          'n',
          'k',
          function()
            require('diffview.actions').prev_entry()
          end,
          { desc = 'Previous entry' },
        },
        {
          'n',
          '<cr>',
          function()
            require('diffview.actions').select_entry()
          end,
          { desc = 'Open diff for selected entry' },
        },
        {
          'n',
          'y',
          function()
            require('diffview.actions').copy_hash()
          end,
          { desc = 'Copy commit hash to clipboard' },
        },
        {
          'n',
          'g?',
          function()
            require('diffview.actions').help 'file_history_panel'
          end,
          { desc = 'Open keybind help panel' },
        },
      },
    },
  },
}
