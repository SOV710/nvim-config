return {
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  treesitter = { "javascript", "typescript", "tsx" },
  lsp = {
    vtsls = {
      filetypes = {
        "javascript", "javascriptreact", "javascript.jsx",
        "typescript", "typescriptreact", "typescript.tsx",
      },
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
          enableMoveToFileCodeAction = true,
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = { completeFunctionCalls = true },
          inlayHints = {
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = false },
            functionLikeReturnTypes = { enabled = true },
          },
        },
      },
    },
  },
  formatter = "prettier",
  mason = { "vtsls", "prettier" },
}
