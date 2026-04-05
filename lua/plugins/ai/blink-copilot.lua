-- Merge spec for saghen/blink.cmp — wires blink-copilot as a completion source.
-- lazy.nvim merges this with the main blink.cmp spec in plugins/langs/completion.lua.
-- opts_extend ensures 'sources.default' arrays are appended, not overwritten.
return {
  'saghen/blink.cmp',
  dependencies = {
    'fang2hou/blink-copilot', -- blink.cmp source adapter for copilot.lua
    'zbirenbaum/copilot.lua', -- headless LSP backend (must load before source queries it)
  },
  opts_extend = { 'sources.default' },
  opts = {
    -- ── Ghost text ────────────────────────────────────────────────────
    completion = {
      ghost_text = {
        enabled = true, -- inline preview of the top completion item
      },
    },

    -- ── Sources ───────────────────────────────────────────────────────
    sources = {
      -- 'copilot' is appended to the existing default list via opts_extend
      default = { 'copilot' },

      providers = {
        copilot = {
          name = 'copilot', -- label shown in blink.cmp menu
          module = 'blink-copilot', -- require('blink-copilot')
          score_offset = 100, -- float above LSP/snippet/buffer items
          async = true, -- copilot responses are async
          opts = {
            max_completions = 3, -- max copilot items per trigger
            max_attempts = 4, -- retry attempts on request failure
            kind_name = 'Copilot', -- item kind label in menu
            kind_icon = ' ', -- nerd-font icon for copilot items
            kind_hl = false, -- no custom highlight group
            debounce = 200, -- ms throttle between requests
            auto_refresh = { backward = true, forward = true },
          },
          should_show_items = function() -- respects <M-c> toggle
            return not vim.g.blink_copilot_disabled
          end,
        },
      },
    },
  },
}
