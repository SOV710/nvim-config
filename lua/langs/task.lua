return {
  filetypes = { 'taskrc' },
  treesitter = { 'taskwarrior' },
  treesitter_parsers = {
    taskwarrior = {
      url = 'https://github.com/SOV710/tree-sitter-taskwarrior',
      branch = 'main',
      revision = 'ae67458960c2889f2d561d330ae46a76edcd9aba',
      files = { 'src/parser.c' },
      filetype = 'taskrc',
      generate = false,
      queries = 'queries',
    },
  },
  filetype = {
    filename = {
      ['taskrc'] = 'taskrc',
    },
  },
}
