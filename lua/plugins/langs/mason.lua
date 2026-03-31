-- Mason consumes: language.mason → string[]
-- e.g. { "rust-analyzer", "codelldb", "clangd", "clang-format", "vtsls", "prettier", ... }
-- Deduplicated automatically by core.language (codelldb appears in both rust.lua and c.lua)

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = require("core.language").mason,
    },
  },
}
