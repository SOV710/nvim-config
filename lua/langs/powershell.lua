-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local mason_path = vim.fn.stdpath 'data' .. '/mason'
local pses_path = mason_path .. '/packages/powershell-editor-services'

return {
  treesitter = {
    languages = {
      powershell = {
        filetypes = { 'ps1' },
        parser = {
          source = {
            type = 'git',
            url = 'https://github.com/airbus-cert/tree-sitter-powershell',
          },
          build = {
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        },
        queries = {
          sources = {
            { type = 'parser_source', lang = 'powershell' },
          },
        },
      },
    },
  },

  lsp = {
    powershell_es = {
      cmd = {
        'pwsh',
        '-NoLogo',
        '-NoProfile',
        '-Command',
        pses_path .. '/PowerShellEditorServices/Start-EditorServices.ps1',
        '-BundledModulesPath',
        pses_path,
        '-SessionDetailsPath',
        pses_path .. '/session.json',
        '-LogPath',
        vim.fn.stdpath 'cache' .. '/powershell_es.log',
        '-LogLevel',
        'Normal',
        '-HostName',
        'nvim',
        '-HostProfileId',
        '0',
        '-HostVersion',
        '1.0.0',
        '-Stdio',
      },
      filetypes = { 'ps1' },
      root_markers = { 'PSScriptAnalyzerSettings.psd1', '.git' },
      settings = {
        powershell = {
          codeFormatting = {
            preset = 'OTBS',
          },
        },
      },
    },
  },

  -- formatter: not set — PSES provides formatting via LSP
  -- linter: not set — PSES provides PSScriptAnalyzer diagnostics via LSP

  mason = { 'powershell-editor-services' },
}
