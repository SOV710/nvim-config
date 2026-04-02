return {
  filetypes = { "json", "jsonc" },
  treesitter = { "json", "jsonc", "json5" },

  lsp = {
    jsonls = {
      settings = {
        json = {
          schemas = (function()
            local ok, schemastore = pcall(require, "schemastore")
            return ok and schemastore.json.schemas() or {}
          end)(),
          validate = { enable = true },
        },
      },
    },

    biome = {},
  },

  formatter = "biome",

  mason = { "json-lsp", "biome" },

  plugins = {
    { "b0o/SchemaStore.nvim", lazy = true, version = false },
  },
}
