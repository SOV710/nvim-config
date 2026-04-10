return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  build = 'cargo build --release',
  dependencies = {
    'L3MON4D3/LuaSnip',
  },
  opts = {
    keymap = {
      preset = 'default',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = 'rounded' },
      },
      menu = {
        border = 'rounded',
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
          },
        },
      },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
    },
    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'snippets', 'path', 'buffer' },
    },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
  },
}
