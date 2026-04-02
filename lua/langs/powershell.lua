local mason_path = vim.fn.stdpath("data") .. "/mason"

return {
  treesitter = { "powershell" },

  lsp = {
    powershell_es = {
      bundle_path = mason_path .. "/packages/powershell-editor-services",
      shell = "pwsh",
      settings = {
        powershell = {
          codeFormatting = {
            preset = "OTBS",
          },
        },
      },
    },
  },

  -- formatter: not set — PSES provides formatting via LSP
  -- linter: not set — PSES provides PSScriptAnalyzer diagnostics via LSP

  mason = { "powershell-editor-services" },
}
