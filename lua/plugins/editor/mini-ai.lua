return {
  'echasnovski/mini.ai',
  version = '*',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  opts = {
    n_lines = 500, -- lines within which textobject is searched
    custom_textobjects = nil, -- custom textobjects (nil = use defaults + treesitter)
    mappings = {
      around = 'a', -- prefix for "around" textobjects
      inside = 'i', -- prefix for "inside" textobjects
      around_next = 'an', -- prefix for "around next" textobjects
      inside_next = 'in', -- prefix for "inside next" textobjects
      around_last = 'al', -- prefix for "around last" textobjects
      inside_last = 'il', -- prefix for "inside last" textobjects
      goto_left = 'g[', -- goto left boundary of textobject
      goto_right = 'g]', -- goto right boundary of textobject
    },
    search_method = 'cover_or_next', -- search method: "cover"|"cover_or_next"|"cover_or_prev"|"cover_or_nearest"|"next"|"prev"|"nearest"
    silent = false, -- suppress "no textobject found" messages
  },
  config = function(_, opts)
    require('mini.ai').setup(opts)

    -- Register which-key descriptions for textobjects
    local ok, wk = pcall(require, 'which-key')
    if ok then
      local objects = {
        { ' ', 'whitespace' },
        { '"', 'double-quoted string' },
        { "'", 'single-quoted string' },
        { '`', 'backtick string' },
        { '(', 'parentheses' },
        { ')', 'parentheses (ws)' },
        { '{', 'braces' },
        { '}', 'braces (ws)' },
        { '[', 'brackets' },
        { ']', 'brackets (ws)' },
        { '<', 'angle brackets' },
        { '>', 'angle brackets (ws)' },
        { '?', 'user prompt' },
        { 'b', 'block (parens/brackets)' },
        { 'f', 'function' },
        { 'c', 'class' },
        { 'a', 'parameter' },
        { 'q', 'quote' },
        { 't', 'tag' },
      }
      local mappings = {}
      for _, obj in ipairs(objects) do
        local key, desc = obj[1], obj[2]
        table.insert(mappings, { 'a' .. key, desc = 'around ' .. desc })
        table.insert(mappings, { 'i' .. key, desc = 'inside ' .. desc })
      end
      wk.add(mappings)
    end
  end,
}
