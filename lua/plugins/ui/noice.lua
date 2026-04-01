return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    -- IMPORTANT: only messages, no cmdline/search takeover
    cmdline = { enabled = false },
    popupmenu = { enabled = false },

    messages = {
      enabled = true, -- take over message display
      view = 'notify', -- default: show as notification
      view_error = 'notify', -- errors as notifications
      view_warn = 'notify', -- warnings as notifications
      view_history = 'messages', -- :Noice history → normal buffer
      view_search = 'virtualtext', -- search count as virtual text
    },

    notify = {
      enabled = true, -- take over vim.notify
      view = 'notify', -- render via notify view
    },

    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
      progress = {
        enabled = true, -- show LSP progress
        view = 'mini', -- compact right-bottom display
      },
      hover = {
        enabled = true, -- beautify hover docs
        silent = true, -- don't notify if no hover info
      },
      signature = {
        enabled = true, -- beautify signature help
        auto_open = { enabled = true },
      },
    },

    routes = {
      -- skip "No information available" hover messages
      { filter = { event = 'notify', find = 'No information available' }, opts = { skip = true } },
      -- skip write messages like "5L, 123B"
      { filter = { event = 'msg_show', find = '%d+L, %d+B' }, opts = { skip = true } },
      -- long messages go to split
      { filter = { event = 'msg_show', min_height = 10 }, view = 'split' },
    },

    presets = {
      bottom_search = false, -- DO NOT move search to bottom
      command_palette = false, -- DO NOT float the cmdline
      long_message_to_split = true, -- redirect long messages to split
      lsp_doc_border = true, -- add border to hover/signature
    },
  },
}
