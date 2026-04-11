-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

--- Health check for langs/*.lua external dependency declarations.
---
--- Invoked by :checkhealth langs. Iterates every lang config loaded by
--- core.language and verifies that each declared `external_deps[i].cmd`
--- binary is resolvable via vim.fn.executable().
---
--- Required deps missing → vim.health.error (with install command in advice).
--- Optional deps missing → vim.health.warn  (with install command in advice).
--- Present deps          → vim.health.ok.
---
--- Langs without an `external_deps` field are skipped silently.

local M = {}

--- Collect lang names that declare a non-empty external_deps field.
---@param langs table<string, LangConfig>
---@return string[] sorted lang names
local function langs_with_deps(langs)
  local names = {}
  for name, cfg in pairs(langs) do
    if cfg.external_deps and #cfg.external_deps > 0 then
      names[#names + 1] = name
    end
  end
  table.sort(names)
  return names
end

--- Build the advice list passed to vim.health.error/warn for a missing dep.
---@param dep LangExternalDep
---@return string[]
local function build_advice(dep)
  local advice = { 'install: ' .. dep.install }
  if dep.note and dep.note ~= '' then
    advice[#advice + 1] = 'note: ' .. dep.note
  end
  return advice
end

--- Check a single lang's external_deps list, emitting one line per dep.
---@param name string
---@param deps LangExternalDep[]
local function check_lang(name, deps)
  vim.health.start('langs.' .. name)
  for _, dep in ipairs(deps) do
    if vim.fn.executable(dep.cmd) == 1 then
      vim.health.ok(dep.cmd .. ' found in $PATH')
    else
      local msg = dep.cmd .. ' not found in $PATH'
      if dep.required then
        vim.health.error(msg, build_advice(dep))
      else
        vim.health.warn(msg, build_advice(dep))
      end
    end
  end
end

--- Diff the mason install directory against the declared mason package set.
--- Declared → OK. Belongs to an `enabled = false` lang → INFO (kept).
--- Unknown → WARN with an uninstall-command hint.
---@param language table core.language module
local function check_mason_orphans(language)
  vim.health.start 'langs.mason'

  local ok, registry = pcall(require, 'mason-registry')
  if not ok then
    vim.health.info 'mason-registry unavailable; skipping mason orphan check'
    return
  end

  local installed = registry.get_installed_package_names()
  if #installed == 0 then
    vim.health.info 'no mason packages installed'
    return
  end
  table.sort(installed)

  for _, pkg in ipairs(installed) do
    if language._seen_mason[pkg] then
      vim.health.ok(pkg .. ': declared')
    elseif language._disabled_mason[pkg] then
      local owner = language._disabled_mason[pkg]
      vim.health.info(pkg .. ": kept (belongs to disabled lang '" .. owner .. "')")
    else
      vim.health.warn(pkg .. ': installed but not declared', {
        'remove with `:MasonUninstall ' .. pkg .. '` (or `:MasonToolsClean` for all orphans)',
      })
    end
  end
end

--- :checkhealth langs entry point.
function M.check()
  local language = require 'core.language'
  local all_langs = language._langs

  vim.health.start 'langs'
  local total = vim.tbl_count(all_langs)
  local names = langs_with_deps(all_langs)
  vim.health.info(('%d lang configs loaded; %d declare external_deps'):format(total, #names))

  for _, name in ipairs(names) do
    check_lang(name, all_langs[name].external_deps)
  end

  check_mason_orphans(language)
end

return M
