-- SPDX-FileCopyrightText: 2026 SOV710
--
-- SPDX-License-Identifier: GPL-3.0-or-later

local api = vim.api
local fn = vim.fn
local uv = vim.uv or vim.loop

local language = require 'core.language'

local M = {
  _commands_defined = false,
  _enabled = false,
  _operation = nil,
}

local data_dir = fn.stdpath 'data' .. '/treesitter'
local checkouts_dir = data_dir .. '/checkouts'
local runtime_dir = data_dir .. '/runtime'
local parser_runtime_dir = runtime_dir .. '/parsers'
local parser_dir = parser_runtime_dir .. '/parser'
local query_runtime_dir = runtime_dir .. '/query-sources'
local state_dir = data_dir .. '/state'
local parser_state_dir = state_dir .. '/parsers'
local query_state_dir = state_dir .. '/queries'

local function join(...)
  return table.concat({ ... }, '/')
end

local function sorted_keys(tbl)
  local keys = vim.tbl_keys(tbl)
  table.sort(keys)
  return keys
end

local function stat(path)
  return uv.fs_stat(path)
end

local function exists(path)
  return stat(path) ~= nil
end

local function is_dir(path)
  local info = stat(path)
  return info ~= nil and info.type == 'directory'
end

local function mkdirp(path)
  if not is_dir(path) then
    fn.mkdir(path, 'p')
  end
end

local function read_file(path)
  local file = assert(io.open(path, 'rb'))
  local content = file:read '*a'
  file:close()
  return content
end

local function write_file(path, content)
  local file = assert(io.open(path, 'wb'))
  file:write(content)
  file:close()
end

local function read_json(path)
  if not exists(path) then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, read_file(path))
  if not ok or type(decoded) ~= 'table' then
    return nil
  end
  return decoded
end

local function write_json(path, value)
  mkdirp(fn.fnamemodify(path, ':h'))
  write_file(path, vim.json.encode(value))
end

local function scandir(path)
  local handle = uv.fs_scandir(path)
  if not handle then
    return function()
      return nil
    end
  end

  return function()
    return uv.fs_scandir_next(handle)
  end
end

local function copy_dir(src, dst)
  mkdirp(dst)
  for name, kind in scandir(src) do
    local src_path = join(src, name)
    local dst_path = join(dst, name)
    if kind == 'directory' then
      copy_dir(src_path, dst_path)
    elseif kind == 'file' then
      write_file(dst_path, read_file(src_path))
    end
  end
end

local function source_mode(source)
  if type(source.revision) == 'string' and source.revision ~= '' then
    return 'pinned'
  end
  return 'floating'
end

local function source_key(source)
  return fn.sha256(vim.json.encode {
    type = source.type,
    url = source.url,
    branch = source.branch,
  }):sub(1, 16)
end

local function source_checkout_dir(source)
  local repo = source.url:match '/([^/]+)%.git$' or source.url:match '/([^/]+)$' or 'parser'
  return join(checkouts_dir, repo .. '-' .. source_key(source))
end

local function source_root(source)
  local checkout = source_checkout_dir(source)
  if source.location and source.location ~= '' then
    return join(checkout, source.location)
  end
  return checkout
end

local function parser_ext()
  if fn.has 'win32' == 1 then
    return 'dll'
  end
  if fn.has 'macunix' == 1 then
    return 'dylib'
  end
  return 'so'
end

local function parser_path(lang_name)
  return join(parser_dir, lang_name .. '.' .. parser_ext())
end

local function query_runtime_root(lang_name, index)
  return join(query_runtime_dir, lang_name, string.format('%02d', index))
end

local function parser_state_path(lang_name)
  return join(parser_state_dir, lang_name .. '.json')
end

local function query_state_path(lang_name, index)
  return join(query_state_dir, lang_name, string.format('%02d.json', index))
end

local function parser_installed(lang_name)
  return exists(parser_path(lang_name))
end

local function run_async(args, opts, cb)
  opts = opts or {}
  vim.system(args, {
    cwd = opts.cwd,
    text = true,
  }, vim.schedule_wrap(function(result)
    if result.code ~= 0 then
      local cmd = table.concat(args, ' ')
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local details = stderr ~= '' and stderr or stdout
      cb(("command failed: %s\n%s"):format(cmd, vim.trim(details)))
      return
    end

    cb(nil, vim.trim(result.stdout or ''))
  end))
end

local function remove_path_async(path, cb)
  if not exists(path) then
    cb()
    return
  end

  if fn.has 'win32' == 1 then
    local args
    if is_dir(path) then
      args = { 'cmd', '/C', 'rmdir', '/s', '/q', path }
    else
      args = { 'cmd', '/C', 'del', '/f', '/q', path }
    end
    run_async(args, {}, function(err)
      cb(err)
    end)
    return
  end

  run_async({ 'rm', '-rf', path }, {}, function(err)
    cb(err)
  end)
end

local function each_serial(items, iterator, done)
  local index = 1

  local function step()
    if index > #items then
      done()
      return
    end

    local item = items[index]
    local item_index = index
    index = index + 1

    iterator(item, item_index, function(err)
      if err then
        done(err)
        return
      end
      step()
    end)
  end

  step()
end

local function git_head_async(path, cb)
  run_async({ 'git', 'rev-parse', 'HEAD' }, { cwd = path }, function(err, result)
    if err then
      cb(nil)
      return
    end
    cb(result)
  end)
end

local function remote_ref_async(path, source, cb)
  if source.branch and source.branch ~= '' then
    cb(nil, 'refs/remotes/origin/' .. source.branch)
    return
  end

  run_async({ 'git', 'symbolic-ref', 'refs/remotes/origin/HEAD' }, { cwd = path }, cb)
end

local function resolve_source_revision_async(path, source, cb)
  if source_mode(source) == 'pinned' then
    cb(nil, source.revision)
    return
  end

  remote_ref_async(path, source, function(err, ref)
    if err then
      cb(err)
      return
    end
    run_async({ 'git', 'rev-parse', ref }, { cwd = path }, cb)
  end)
end

local function source_label(source)
  if source_mode(source) == 'pinned' then
    return source.revision
  end

  if source.branch and source.branch ~= '' then
    return 'origin/' .. source.branch
  end

  return 'origin/HEAD'
end

local function source_state(source, resolved_revision)
  return {
    mode = source_mode(source),
    branch = source.branch,
    desired = source_label(source),
    resolved_revision = resolved_revision,
    url = source.url,
    location = source.location,
  }
end

local function ensure_checkout_async(source, context, cb)
  local checkout = source_checkout_dir(source)
  local active = context.seen_sources[checkout]
  if active then
    if active.done then
      cb(nil, source_root(source), active.resolved_revision)
    else
      active.callbacks[#active.callbacks + 1] = cb
    end
    return
  end

  active = {
    callbacks = { cb },
    done = false,
    resolved_revision = nil,
  }
  context.seen_sources[checkout] = active

  local function finish(err, resolved_revision)
    local callbacks = active.callbacks
    if err then
      context.seen_sources[checkout] = nil
      for _, callback in ipairs(callbacks) do
        callback(err)
      end
      return
    end

    active.done = true
    active.resolved_revision = resolved_revision
    for _, callback in ipairs(callbacks) do
      callback(nil, source_root(source), resolved_revision)
    end
  end

  local function continue_after_fetch(current_head, cloned)
    local floating = source_mode(source) == 'floating'
    local needs_fetch = context.update or (floating and not cloned)
    if source_mode(source) == 'pinned' and current_head ~= source.revision then
      needs_fetch = true
    end

    local function after_fetch()
      resolve_source_revision_async(checkout, source, function(err, resolved_revision)
        if err then
          finish(err)
          return
        end

        git_head_async(checkout, function(head)
          if head == resolved_revision then
            finish(nil, resolved_revision)
            return
          end

          run_async(
            { 'git', '-c', 'advice.detachedHead=false', 'checkout', '--force', resolved_revision },
            { cwd = checkout },
            function(checkout_err)
              finish(checkout_err, resolved_revision)
            end
          )
        end)
      end)
    end

    if needs_fetch then
      run_async({ 'git', 'fetch', '--tags', '--force', 'origin' }, { cwd = checkout }, function(err)
        if err then
          finish(err)
          return
        end
        after_fetch()
      end)
    else
      after_fetch()
    end
  end

  if not is_dir(checkout) then
    mkdirp(checkouts_dir)
    local clone_args = { 'git', 'clone', '--filter=blob:none' }
    if source.branch and source.branch ~= '' then
      clone_args[#clone_args + 1] = '--branch'
      clone_args[#clone_args + 1] = source.branch
    end
    clone_args[#clone_args + 1] = source.url
    clone_args[#clone_args + 1] = checkout
    run_async(clone_args, {}, function(err)
      if err then
        finish(err)
        return
      end
      git_head_async(checkout, function(current_head)
        continue_after_fetch(current_head, true)
      end)
    end)
    return
  end

  git_head_async(checkout, function(current_head)
    continue_after_fetch(current_head, false)
  end)
end

local function compiler_args(spec, output)
  local args = {
    '-o',
    output,
    '-I./src',
  }

  for _, file in ipairs(spec.parser.build.files) do
    args[#args + 1] = file
  end

  args[#args + 1] = '-Os'
  args[#args + 1] = '-std=c11'
  if fn.has 'macunix' == 1 then
    args[#args + 1] = '-bundle'
  else
    args[#args + 1] = '-shared'
  end
  if fn.has 'win32' == 0 then
    args[#args + 1] = '-fPIC'
  end

  local needs_stdcpp = vim.tbl_contains(vim.tbl_map(function(file)
    local ext = fn.fnamemodify(file, ':e')
    return ext == 'cc' or ext == 'cpp' or ext == 'cxx'
  end, spec.parser.build.files), true)
  if needs_stdcpp then
    args[#args + 1] = '-lstdc++'
  end

  return args
end

local function install_parser_async(lang_name, spec, context, cb)
  ensure_checkout_async(spec.parser.source, context, function(err, root, resolved_revision)
    if err then
      cb(err)
      return
    end

    mkdirp(parser_dir)

    local function compile()
      local output = parser_path(lang_name)
      local args = vim.list_extend({ fn.getenv 'CC' ~= vim.NIL and fn.getenv 'CC' or 'cc' }, compiler_args(spec, output))
      run_async(args, { cwd = root }, function(compile_err)
        if compile_err then
          cb(compile_err)
          return
        end

        write_json(parser_state_path(lang_name), source_state(spec.parser.source, resolved_revision))
        cb()
      end)
    end

    if spec.parser.build.generate then
      run_async({ 'tree-sitter', 'generate', '--no-bindings' }, { cwd = root }, function(generate_err)
        if generate_err then
          cb(generate_err)
          return
        end
        compile()
      end)
    else
      compile()
    end
  end)
end

local function query_source_checkout_async(lang_name, spec, source, context, cb)
  if source.type == 'parser_source' then
    ensure_checkout_async(spec.parser.source, context, function(err, root, resolved_revision)
      if err then
        cb(err)
        return
      end
      cb(nil, join(root, 'queries'), resolved_revision, spec.parser.source)
    end)
    return
  end

  ensure_checkout_async(source, context, function(err, root, resolved_revision)
    if err then
      cb(err)
      return
    end
    cb(nil, join(root, source.path or 'queries'), resolved_revision, source)
  end)
end

local function install_query_source_async(lang_name, spec, source, index, context, cb)
  query_source_checkout_async(lang_name, spec, source, context, function(err, src_dir, resolved_revision, state_source)
    if err then
      cb(err)
      return
    end

    if not is_dir(src_dir) then
      cb(("missing query source for '%s': %s"):format(lang_name, src_dir))
      return
    end

    local runtime_root = query_runtime_root(lang_name, index)
    local dst_dir = join(runtime_root, 'queries', source.lang or lang_name)
    remove_path_async(runtime_root, function(remove_err)
      if remove_err then
        cb(remove_err)
        return
      end

      mkdirp(join(runtime_root, 'queries'))

      local ok = uv.fs_symlink(src_dir, dst_dir, { dir = true })
      if not ok then
        copy_dir(src_dir, dst_dir)
      end

      local state = source_state(state_source, resolved_revision)
      state.lang = source.lang or lang_name
      state.kind = source.type
      write_json(query_state_path(lang_name, index), state)
      cb()
    end)
  end)
end

local function install_lang_async(lang_name, spec, context, cb)
  install_parser_async(lang_name, spec, context, function(err)
    if err then
      cb(err)
      return
    end

    local sources = spec.queries and spec.queries.sources or {}
    each_serial(sources, function(source, index, next_step)
      install_query_source_async(lang_name, spec, source, index, context, next_step)
    end, cb)
  end)
end

local function active_runtime_roots()
  local roots = { parser_runtime_dir }
  for _, lang_name in ipairs(sorted_keys(language.treesitter)) do
    local spec = language.treesitter[lang_name]
    local sources = spec.queries and spec.queries.sources or {}
    for index = 1, #sources do
      local root = query_runtime_root(lang_name, index)
      if is_dir(root) then
        roots[#roots + 1] = root
      end
    end
  end
  return roots
end

local function managed_root(path)
  return vim.startswith(path, runtime_dir)
end

local function apply_runtimepath(roots)
  local current = api.nvim_list_runtime_paths()
  local normal = {}
  local after = {}

  for _, path in ipairs(current) do
    if not managed_root(path) then
      if path:match '[/\\]after$' then
        after[#after + 1] = path
      else
        normal[#normal + 1] = path
      end
    end
  end

  local insert_at = #normal + 1
  local config_root = fn.stdpath 'config'
  for index, path in ipairs(normal) do
    if path == config_root then
      insert_at = index + 1
      break
    end
  end

  for offset, root in ipairs(roots) do
    table.insert(normal, insert_at + offset - 1, root)
  end

  vim.o.runtimepath = table.concat(vim.list_extend(normal, after), ',')
end

local function register_languages()
  for lang_name, spec in pairs(language.treesitter) do
    if spec.filetypes and #spec.filetypes > 0 then
      vim.treesitter.language.register(lang_name, spec.filetypes)
    end
  end
end

local function maybe_start(bufnr)
  local ft = vim.bo[bufnr].filetype
  if ft == '' then
    return
  end

  local lang_name = vim.treesitter.language.get_lang(ft)
  if not lang_name then
    return
  end

  local spec = language.treesitter[lang_name]
  if not spec or spec.auto_start == false then
    return
  end

  local path = parser_path(lang_name)
  if not exists(path) then
    return
  end

  if vim.treesitter.highlighter.active[bufnr] then
    return
  end

  local ok = vim.treesitter.language.add(lang_name, { path = path })
  if not ok then
    return
  end

  pcall(vim.treesitter.start, bufnr, lang_name)
end

local function reload_language(lang_name)
  if vim._ts_remove_language then
    pcall(vim._ts_remove_language, lang_name)
  end

  for _, bufnr in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(bufnr) then
      local ft = vim.bo[bufnr].filetype
      if vim.treesitter.language.get_lang(ft) == lang_name then
        pcall(vim.treesitter.stop, bufnr)
        maybe_start(bufnr)
      end
    end
  end
end

local function selected_langs(args)
  if #args == 0 then
    return sorted_keys(language.treesitter)
  end

  local langs = {}
  for _, lang_name in ipairs(args) do
    if not language.treesitter[lang_name] then
      error(("unknown treesitter language: %s"):format(lang_name))
    end
    langs[#langs + 1] = lang_name
  end
  return langs
end

local function begin_operation(name)
  if M._operation then
    vim.notify('treesitter operation already running: ' .. M._operation, vim.log.levels.WARN, { title = 'Treesitter' })
    return false
  end
  M._operation = name
  return true
end

local function finish_operation()
  M._operation = nil
end

local function install_langs_async(args, update, cb)
  local langs = selected_langs(args)
  local context = {
    update = update,
    seen_sources = {},
  }

  each_serial(langs, function(lang_name, _, next_step)
    install_lang_async(lang_name, language.treesitter[lang_name], context, next_step)
  end, function(err)
    if err then
      cb(err)
      return
    end

    M.setup_runtime()
    for _, lang_name in ipairs(langs) do
      reload_language(lang_name)
    end

    cb(nil, langs)
  end)
end

local function active_checkout_dirs()
  local dirs = {}
  for _, spec in pairs(language.treesitter) do
    dirs[source_checkout_dir(spec.parser.source)] = true
    local sources = spec.queries and spec.queries.sources or {}
    for _, source in ipairs(sources) do
      if source.type == 'git' then
        dirs[source_checkout_dir(source)] = true
      end
    end
  end
  return dirs
end

local function clean_async(cb)
  local keep_checkouts = active_checkout_dirs()
  local active_query_roots = {}
  local active_query_states = {}
  local to_remove = {}
  local seen = {}

  local function queue_remove(path)
    if path ~= nil and path ~= '' and not seen[path] then
      seen[path] = true
      to_remove[#to_remove + 1] = path
    end
  end

  for _, lang_name in ipairs(sorted_keys(language.treesitter)) do
    local spec = language.treesitter[lang_name]
    local sources = spec.queries and spec.queries.sources or {}
    for index = 1, #sources do
      active_query_roots[query_runtime_root(lang_name, index)] = true
      active_query_states[query_state_path(lang_name, index)] = true
    end
  end

  for name, kind in scandir(parser_dir) do
    if kind == 'file' then
      local lang_name = fn.fnamemodify(name, ':r')
      if not language.treesitter[lang_name] then
        queue_remove(join(parser_dir, name))
      end
    end
  end

  for name, kind in scandir(parser_state_dir) do
    if kind == 'file' then
      local lang_name = fn.fnamemodify(name, ':r')
      if not language.treesitter[lang_name] then
        queue_remove(join(parser_state_dir, name))
      end
    end
  end

  for name, kind in scandir(query_runtime_dir) do
    if kind == 'directory' then
      local lang_root = join(query_runtime_dir, name)
      if not language.treesitter[name] then
        queue_remove(lang_root)
      else
        local has_active_child = false
        for child, child_kind in scandir(lang_root) do
          if child_kind == 'directory' then
            local path = join(lang_root, child)
            if not active_query_roots[path] then
              queue_remove(path)
            else
              has_active_child = true
            end
          end
        end
        if not has_active_child then
          queue_remove(lang_root)
        end
      end
    end
  end

  for name, kind in scandir(query_state_dir) do
    if kind == 'directory' then
      local lang_root = join(query_state_dir, name)
      if not language.treesitter[name] then
        queue_remove(lang_root)
      else
        local has_active_child = false
        for child, child_kind in scandir(lang_root) do
          if child_kind == 'file' then
            local path = join(lang_root, child)
            if not active_query_states[path] then
              queue_remove(path)
            else
              has_active_child = true
            end
          end
        end
        if not has_active_child then
          queue_remove(lang_root)
        end
      end
    end
  end

  for name, kind in scandir(checkouts_dir) do
    if kind == 'directory' then
      local path = join(checkouts_dir, name)
      if not keep_checkouts[path] then
        queue_remove(path)
      end
    end
  end

  each_serial(to_remove, function(path, _, next_step)
    remove_path_async(path, next_step)
  end, function(err)
    if err then
      cb(err)
      return
    end

    M.setup_runtime()
    vim.notify('treesitter cache cleaned', vim.log.levels.INFO, { title = 'Treesitter' })
    cb()
  end)
end

local function status_lines(args)
  local lines = {}
  for _, lang_name in ipairs(selected_langs(args)) do
    local entry = M.status()[lang_name]
    lines[#lines + 1] = ('%s: parser=%s, mode=%s, target=%s, resolved=%s, query-sources=%d/%d, discovered-query-files=%d'):format(
      lang_name,
      entry.parser.installed and 'installed' or 'missing',
      entry.parser.mode,
      entry.parser.desired or '-',
      entry.parser.resolved_revision or '-',
      entry.queries.installed,
      entry.queries.required,
      #entry.queries.discovered_files
    )
  end
  return lines
end

local function with_error_boundary(cb)
  return function(opts)
    local ok, err = xpcall(function()
      cb(opts)
    end, debug.traceback)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR, { title = 'Treesitter' })
    end
  end
end

local function trigger_install(args, update)
  local langs = selected_langs(args)
  local op_name = update and 'TSUpdate' or 'TSInstall'
  if not begin_operation(op_name) then
    return
  end

  vim.notify(('treesitter %s started: %s'):format(update and 'update' or 'install', table.concat(langs, ', ')), vim.log.levels.INFO, {
    title = 'Treesitter',
  })

  install_langs_async(langs, update, function(err, installed_langs)
    finish_operation()
    if err then
      vim.notify(err, vim.log.levels.ERROR, { title = 'Treesitter' })
      return
    end

    vim.notify(
      ('treesitter %s: %s'):format(update and 'updated' or 'installed', table.concat(installed_langs, ', ')),
      vim.log.levels.INFO,
      { title = 'Treesitter' }
    )
  end)
end

local function define_commands()
  if M._commands_defined then
    return
  end

  local completion = function(_, _, _)
    return sorted_keys(language.treesitter)
  end

  api.nvim_create_user_command('TSInstall', with_error_boundary(function(opts)
    trigger_install(opts.fargs, false)
  end), {
    nargs = '*',
    complete = completion,
  })

  api.nvim_create_user_command('TSUpdate', with_error_boundary(function(opts)
    trigger_install(opts.fargs, true)
  end), {
    nargs = '*',
    complete = completion,
  })

  api.nvim_create_user_command('TSClean', with_error_boundary(function()
    if not begin_operation 'TSClean' then
      return
    end
    clean_async(function(err)
      finish_operation()
      if err then
        vim.notify(err, vim.log.levels.ERROR, { title = 'Treesitter' })
      end
    end)
  end), {
    nargs = 0,
  })

  api.nvim_create_user_command('TSStatus', with_error_boundary(function(opts)
    vim.notify(table.concat(status_lines(opts.fargs), '\n'), vim.log.levels.INFO, { title = 'Treesitter' })
  end), {
    nargs = '*',
    complete = completion,
  })

  M._commands_defined = true
end

function M.setup_runtime()
  mkdirp(checkouts_dir)
  mkdirp(parser_dir)
  mkdirp(query_runtime_dir)
  mkdirp(parser_state_dir)
  mkdirp(query_state_dir)
  register_languages()
  apply_runtimepath(active_runtime_roots())
  define_commands()
end

function M.enable()
  if M._enabled then
    return
  end

  register_languages()

  local group = api.nvim_create_augroup('sov710.treesitter', { clear = true })
  api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(ev)
      maybe_start(ev.buf)
    end,
  })

  for _, bufnr in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(bufnr) then
      maybe_start(bufnr)
    end
  end

  M._enabled = true
end

function M.languages()
  return sorted_keys(language.treesitter)
end

function M.needs_generate()
  for _, spec in pairs(language.treesitter) do
    if spec.parser.build.generate then
      return true
    end
  end
  return false
end

function M.status()
  local status = {}

  for _, lang_name in ipairs(sorted_keys(language.treesitter)) do
    local spec = language.treesitter[lang_name]
    local parser_installed_now = parser_installed(lang_name)
    local parser_state = parser_installed_now and (read_json(parser_state_path(lang_name)) or {}) or {}
    local query_sources = spec.queries and spec.queries.sources or {}
    local installed_queries = 0
    local query_entries = {}
    for index = 1, #query_sources do
      local query_installed = is_dir(query_runtime_root(lang_name, index))
      if query_installed then
        installed_queries = installed_queries + 1
      end
      query_entries[index] = (query_installed and read_json(query_state_path(lang_name, index)) or nil) or {
        mode = source_mode(query_sources[index].type == 'parser_source' and spec.parser.source or query_sources[index]),
        desired = source_label(query_sources[index].type == 'parser_source' and spec.parser.source or query_sources[index]),
        resolved_revision = nil,
        kind = query_sources[index].type,
        lang = query_sources[index].lang or lang_name,
      }
    end

    status[lang_name] = {
      parser = {
        installed = parser_installed_now,
        path = parser_path(lang_name),
        generate = spec.parser.build.generate == true,
        mode = parser_state.mode or source_mode(spec.parser.source),
        desired = parser_state.desired or source_label(spec.parser.source),
        resolved_revision = parser_state.resolved_revision,
        branch = parser_state.branch or spec.parser.source.branch,
      },
      queries = {
        required = #query_sources,
        installed = installed_queries,
        discovered_files = api.nvim_get_runtime_file(('queries/%s/*.scm'):format(lang_name), true),
        sources = query_entries,
      },
    }
  end

  return status
end

function M.requirements()
  return {
    has_languages = next(language.treesitter) ~= nil,
    needs_generate = M.needs_generate(),
    git = fn.executable 'git' == 1,
    compiler = fn.executable(fn.getenv 'CC' ~= vim.NIL and fn.getenv 'CC' or 'cc') == 1,
    tree_sitter = fn.executable 'tree-sitter' == 1,
  }
end

return M
