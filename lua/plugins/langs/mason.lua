return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    event = "VeryLazy",
    opts = function()
      return {
        ensure_installed = require("core.language").mason,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      }
    end,
  },
}
