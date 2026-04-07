return {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>e', '<cmd>Oil<cr>', desc = 'File explorer (Oil)' },
  },
  opts = {
    default_file_explorer = true, -- replace netrw as default file explorer
    delete_to_trash = true, -- use trash instead of permanent delete
    skip_confirm_for_simple_edits = true, -- don't prompt for simple renames/creates
    watch_for_changes = true, -- Respond to external filesystem changes

    columns = { 'icon' },

    lsp_file_methods = { -- automatically save import changes when rename
      autosave_changes = 'unmodified',
    },

    view_options = {
      show_hidden = true, -- show dotfiles by default
      natural_order = 'fast', -- sort "file2" before "file10"
      case_insensitive = false,
      is_always_hidden = function(name) -- files that never appear
        return name == '.git' or name == '.DS_Store'
      end,
    },

    float = {
      padding = 2, -- inner padding in float window (cells)
      max_width = 0, -- 0 = no max, positive = max columns
      max_height = 0, -- 0 = no max, positive = max rows
      border = 'rounded', -- border style: "none"|"single"|"double"|"rounded"
      win_options = {
        winblend = 0, -- window transparency (0=opaque, 100=fully transparent)
      },
    },

    confirmation = { border = 'rounded' },
    progress = { border = 'rounded' },
    keymaps_help = { border = 'rounded' },
    ssh = { border = 'rounded' },

    use_default_keymaps = false, -- disable defaults since we defined all above
    keymaps = {
      ['g?'] = 'actions.show_help', -- show all oil keymaps
      ['<CR>'] = 'actions.select', -- open file / enter directory
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } }, -- open in vertical split
      ['<C-x>'] = { 'actions.select', opts = { horizontal = true } }, -- open in horizontal split
      ['<C-t>'] = 'actions.select_tab', -- open in new tab
      ['<C-p>'] = 'actions.preview', -- preview file
      ['<C-c>'] = 'actions.close', -- close oil buffer
      ['<C-r>'] = 'actions.refresh', -- refresh directory listing
      ['-'] = { 'actions.parent', mode = 'n' }, -- navigate to parent directory
      ['_'] = { 'actions.open_cwd', mode = 'n' }, -- open cwd in oil
      ['`'] = { 'actions.cd', mode = 'n' }, -- :cd to current oil directory
      ['~'] = 'actions.tcd', -- :tcd to current oil directory
      ['gs'] = 'actions.change_sort', -- cycle sort order
      ['gx'] = 'actions.open_external', -- open with system handler
      ['g.'] = 'actions.toggle_hidden', -- toggle hidden files
      ['g\\'] = 'actions.toggle_trash', -- toggle trash mode
    },
  },
}
