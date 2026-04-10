return {
  {
    '<leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'Toggle breakpoint',
  },
  {
    '<leader>dB',
    function()
      require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end,
    desc = 'Conditional breakpoint',
  },
  {
    '<leader>dc',
    function()
      require('dap').continue()
    end,
    desc = 'Continue',
  },
  {
    '<leader>dC',
    function()
      require('dap').run_to_cursor()
    end,
    desc = 'Run to cursor',
  },
  {
    '<leader>di',
    function()
      require('dap').step_into()
    end,
    desc = 'Step into',
  },
  {
    '<leader>do',
    function()
      require('dap').step_over()
    end,
    desc = 'Step over',
  },
  {
    '<leader>dO',
    function()
      require('dap').step_out()
    end,
    desc = 'Step out',
  },
  {
    '<leader>dp',
    function()
      require('dap').pause()
    end,
    desc = 'Pause',
  },
  {
    '<leader>dt',
    function()
      require('dap').terminate()
    end,
    desc = 'Terminate',
  },
  {
    '<leader>dr',
    function()
      require('dap').repl.toggle()
    end,
    desc = 'Toggle REPL',
  },
  {
    '<leader>dl',
    function()
      require('dap').run_last()
    end,
    desc = 'Run last',
  },
}
