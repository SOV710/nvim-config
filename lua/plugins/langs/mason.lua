return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    event = "VeryLazy",
    opts = {
      ensure_installed = require("core.language").mason,
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
  },
}
