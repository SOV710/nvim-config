return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  build = 'cargo build --release',

  dependencies = { 'L3MON4D3/LuaSnip' },

  opts = {
    keymap = {
      preset = 'super-tab',
      ['<C-space>'] = { 'accept', 'fallback' }, -- ctrl+space for accept completion
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿', -- Plain text item; no strong semantic type.
        Method = '󰊕', -- Member function bound to a type or object.
        Function = '󰊕', -- Standalone callable function.
        Constructor = '󰒓', -- Constructor or initializer used to create an instance.
        Field = '󰜢', -- Direct data field on a struct or class.
        Variable = '󰆦', -- General variable, local or global.
        Property = '󰖷', -- Property-like member, often with accessor semantics.
        Class = '󱡠', -- Class type definition.
        Interface = '󱡠', -- Interface or abstract behavioral contract.
        Struct = '󱡠', -- Struct type, typically data-oriented.
        Module = '󰅩', -- Module, namespace, or package.
        Unit = '󰪚', -- Unit-like value, often used for measures or dimensions.
        Value = '󰦨', -- General value item.
        Enum = '󰦨', -- Enumeration type.
        EnumMember = '󰦨', -- Member of an enumeration.
        Keyword = '󰻾', -- Language keyword.
        Constant = '󰏿', -- Immutable constant value.
        Snippet = '󱄽', -- Expandable code snippet or template.
        Color = '󰏘', -- Color literal or color-related item.
        File = '󰈔', -- File path or file-like item.
        Reference = '󰬲', -- Symbol reference or indirection target.
        Folder = '󰉋', -- Directory or folder path.
        Event = '󱐋', -- Event, callback, or signal-like item.
        Operator = '󰪚', -- Language or symbolic operator.
        TypeParameter = '󰬛', -- Generic type parameter.
      },
    },
    completion = {
      keyword = { range = 'full' },
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
      ghost_text = {
        enabled = true,
        show_with_menu = true,
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
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
}
