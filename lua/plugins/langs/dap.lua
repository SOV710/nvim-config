return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    config = function()
      local dap = require 'dap'
      local language = require 'core.language'

      for name, adapter_config in pairs(language.dap_adapters) do
        dap.adapters[name] = adapter_config
      end

      for filetype, configs in pairs(language.dap_configurations) do
        dap.configurations[filetype] = dap.configurations[filetype] or {}
        for _, config in ipairs(configs) do
          table.insert(dap.configurations[filetype], config)
        end
      end
    end,
    keys = require 'keymaps.langs.dap',
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
    lazy = true,
    opts = {
      enabled = true,
      commented = true,
    },
  },
}
