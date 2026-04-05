return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  keys = require 'core.keymaps.ai.copilot',
  opts = {
    -- HEADLESS backend: all UI goes through blink-copilot / blink.cmp.
    -- suggestion and panel are fully disabled.

    -- ── Suggestion (disabled — blink.cmp handles display) ────────────
    suggestion = {
      enabled = false, -- no inline ghost text from copilot.lua
      auto_trigger = false,
      hide_during_completion = true,
      debounce = 15,
      trigger_on_accept = true,
      keymap = {
        accept = '<M-l>',
        accept_word = false,
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
        toggle_auto_trigger = false,
      },
    },

    -- ── Panel (disabled — not needed with blink.cmp) ──────────────────
    panel = {
      enabled = false, -- no copilot panel
      auto_refresh = false,
      keymap = {
        jump_prev = '[[',
        jump_next = ']]',
        accept = '<CR>',
        refresh = 'gr',
        open = '<M-CR>',
      },
      layout = {
        position = 'bottom',
        ratio = 0.4,
      },
    },

    -- ── Node ──────────────────────────────────────────────────────────
    -- Must be Node >= 22; set full path if using nvm/asdf/volta
    copilot_node_command = 'node',

    -- ── Filetypes ─────────────────────────────────────────────────────
    filetypes = {
      TelescopePrompt = false, -- prompt UI — no completions
      snacks_picker_input = false, -- snacks picker input
      oil = false, -- oil file browser
      DressingInput = false, -- dressing.nvim input
      ['*'] = true, -- enabled everywhere else
    },

    -- ── LSP client overrides ──────────────────────────────────────────
    server_opts_overrides = {}, -- extend copilot LSP settings if needed
  },
}
