local M = {}

function M.aucmd(event, desc, opts)
  opts = vim.tbl_deep_extend(
    'force',
    opts,
    {
      group = vim.api.nvim_create_augroup(desc, {}),
      desc = desc,
    })
  return vim.api.nvim_create_autocmd(event, opts)
end

function M.getlua(luafile)
  local loaded = string.match(luafile, '.+lua/(.+)%.lua')
  if not loaded then
    return ''
  end
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

function M.getsource(luafile)
  return M.rep_backslash(vim.fn.trim(luafile, '@'))
end

function M._get_functions_of_M(m)
  local functions = {}
  for k, v in pairs(m) do
    if type(v) == 'function' and string.sub(k, 1, 1) ~= '_' then
      functions[#functions + 1] = k
    end
  end
  table.sort(functions)
  return functions
end

function M.create_user_command_with_M(m, name)
  vim.api.nvim_create_user_command(name, function(params)
    if #params.fargs == 1 then
      pcall(M.cmd, "lua require('%s').%s()", m.lua, params.fargs[1])
    else
      pcall(M.cmd, "lua require('%s').main()", m.lua)
    end
  end, {
    nargs = '?',
    desc = name,
    complete = function()
      return M._get_functions_of_M(m)
    end,
  })
end

--------------------

function M.rep_slash(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function M.rep_slash_lower(content)
  return vim.fn.tolower(M.rep_slash(content))
end

function M.rep_backslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function M.rep_backslash_lower(content)
  return vim.fn.tolower(M.rep_backslash(content))
end

--------------------

function M.totable(var)
  if type(var) ~= 'table' then
    var = { var, }
  end
  return var
end

function M.getcreate_dirpath(dirs)
  dirs = M.totable(dirs)
  local dir1 = table.remove(dirs, 1)
  dir1 = M.rep_slash(dir1)
  local dir_path = require 'plenary.path':new(dir1)
  for _, dir in ipairs(dirs) do
    if not dir_path:exists() then
      vim.fn.mkdir(dir_path.filename)
    end
    dir_path = dir_path:joinpath(dir)
  end
  return dir_path
end

function M.getcreate_stddata_dirpath(dirs)
  dirs = M.totable(dirs)
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return M.getcreate_dirpath(dirs)
end

function M.getcreate_dir(dirs)
  dirs = M.totable(dirs)
  local dir1 = table.remove(dirs, 1)
  dir1 = M.rep_slash(dir1)
  local dirpath = require 'plenary.path':new(dir1)
  if not dirpath:exists() then
    vim.fn.mkdir(dirpath.filename)
  end
  for _, dir in ipairs(dirs) do
    if not dirpath:exists() then
      vim.fn.mkdir(dirpath.filename)
    end
    dirpath = dirpath:joinpath(dir)
  end
  return dirpath.filename
end

function M.get_filepath(dirs, file)
  local dirpath = M.getcreate_dirpath(dirs)
  return dirpath:joinpath(file)
end

function M.getcreate_filepath(dirs, file)
  local file_path = M.get_filepath(dirs, file)
  if not file_path:exists() then
    file_path:touch()
  end
  return file_path
end

---------

function M.set_timeout(timeout, callback)
  return vim.fn.timer_start(timeout, function()
    callback()
  end, { ['repeat'] = 1, })
end

function M.set_interval(interval, callback)
  return vim.fn.timer_start(interval, function()
    callback()
  end, { ['repeat'] = -1, })
end

function M.clear_interval(timer)
  pcall(vim.fn.timer_stop, timer)
end

---------

function M.is(val)
  if not val or val == 0 or val == '' or val == false or val == {} then
    return nil
  end
  return 1
end

----------------

function M.notify_info(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  require 'notify'.dismiss()
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'info', {
    title = title,
    animate = false,
    on_open = M.notify_on_open,
    timeout = 1000 * 8,
  })
end

function M.notify_error(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'error', {
    title = title,
    animate = false,
    on_open = M.notify_on_open,
    timeout = 1000 * 8,
  })
end

function M.notify_qflist()
  local lines = {}
  for _, i in ipairs(vim.fn.getqflist()) do
    lines[#lines + 1] = i['text']
  end
  M.notify_info(lines)
end

function M.refresh_fugitive()
  vim.cmd 'Lazy load vim-fugitive'
  vim.call 'fugitive#ReloadStatus'
end

M.asyncrun_done_changed = nil

function M.asyncrun_done_default()
  M.notify_qflist()
  M.refresh_fugitive()
  vim.cmd 'au! User AsyncRunStop'
  -- M.set_timeout(10, function() pcall(vim.cmd, 'e!') end)
end

function M.au_user_asyncrunstop()
  vim.cmd 'au User AsyncRunStop call v:lua.AsyncRunDone()'
end

function M.asyncrun_prepare(callback)
  if callback then
    AsyncRunDone = function()
      M.asyncrun_done_changed = nil
      callback()
      vim.cmd 'au! User AsyncRunStop'
      AsyncRunDone = M.asyncrun_done_default
    end
    M.asyncrun_done_changed = 1
  end
  M.au_user_asyncrunstop()
end

function M.asyncrun_prepare_add(callback)
  if callback then
    AsyncRunDone = function()
      M.asyncrun_done_changed = nil
      M.asyncrun_done_default()
      callback()
      AsyncRunDone = M.asyncrun_done_default
    end
    M.asyncrun_done_changed = 1
  end
  M.au_user_asyncrunstop()
end

function M.asyncrun_prepare_default()
  if not M.asyncrun_done_changed then
    AsyncRunDone = M.asyncrun_done_default
    M.au_user_asyncrunstop()
  end
end

function M.notify_on_open(win)
  local buf = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
end

function M.system_run(way, str_format, ...)
  if type(str_format) == 'table' then
    str_format = vim.fn.join(str_format, ' && ')
  end
  local cmd = string.format(str_format, ...)
  if way == 'start' then
    cmd = string.format([[silent !start cmd /c "%s"]], cmd)
    vim.cmd(cmd)
  elseif way == 'start silent' then
    cmd = string.format([[silent !start /b /min cmd /c "%s"]], cmd)
    vim.cmd(cmd)
  elseif way == 'asyncrun' then
    vim.cmd 'Lazy load asyncrun.vim'
    cmd = string.format('AsyncRun %s', cmd)
    M.asyncrun_prepare_default()
    vim.cmd(cmd)
  elseif way == 'term' then
    cmd = string.format('wincmd s|term %s', cmd)
    vim.cmd(cmd)
  end
end

function M.cmd(str_format, ...)
  if type(str_format) == 'table' then
    str_format = vim.fn.join(str_format, ' && ')
  end
  vim.cmd(string.format(str_format, ...))
end

function M.print(str_format, ...)
  print(string.format(str_format, ...))
end

function M.system_cd(file)
  vim.cmd 'Lazy load plenary.nvim'
  local new_file = ''
  if string.sub(file, 2, 2) == ':' then
    new_file = new_file .. string.sub(file, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(file):is_dir() then
    return new_file .. 'cd ' .. file
  else
    return new_file .. 'cd ' .. require 'plenary.path'.new(file):parent().filename
  end
end

-------------------

function M.get_file_dirs(file)
  vim.cmd 'Lazy load plenary.nvim'
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  file = M.rep_slash(file)
  local file_path = require 'plenary.path':new(file)
  if not file_path:is_file() then
    M.notify_info('not file: ' .. file)
    return nil
  end
  local dirs = {}
  for _ = 1, 24 do
    file_path = file_path:parent()
    local name = M.rep_backslash(file_path.filename)
    dirs[#dirs + 1] = name
    if not string.match(name, '/') then
      break
    end
  end
  return dirs
end

function M.get_file_dirs_till_git(file)
  vim.cmd 'Lazy load plenary.nvim'
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  file = M.rep_slash(file)
  local file_path = require 'plenary.path':new(file)
  if not file_path:is_file() then
    M.notify_info('not file: ' .. file)
    return {}
  end
  local dirs = {}
  for _ = 1, 24 do
    file_path = file_path:parent()
    local name = M.rep_backslash(file_path.filename)
    dirs[#dirs + 1] = name
    if M.file_exists(require 'plenary.path':new(name):joinpath '.git'.filename) then
      break
    end
  end
  return dirs
end

function M.get_fname_tail(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = M.rep_slash(file)
  local fpath = require 'plenary.path':new(file)
  if fpath:is_file() then
    file = fpath:_split()
    return file[#file]
  elseif fpath:is_dir() then
    file = fpath:_split()
    if #file[#file] > 0 then
      return file[#file]
    else
      return file[#file - 1]
    end
  end
  return ''
end

function M.get_only_name(file)
  file = M.rep_slash(file)
  local only_name = vim.fn.trim(file, '\\')
  if string.match(only_name, '\\') then
    only_name = string.match(only_name, '.+%\\(.+)$')
  end
  return only_name
end

function M.del_dir(dir)
  M.system_run('start silent', [[del /s /q %s & rd /s /q %s]], dir, dir)
end

function M.scan_files(dir, pattern)
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = true, depth = 1, add_dirs = false, })
  local files = {}
  for _, entry in ipairs(entries) do
    local file = M.rep_slash(entry)
    if not pattern or string.match(file, pattern) then
      files[#files + 1] = M.get_only_name(file)
    end
  end
  return files
end

function M.time_diff(timestamp)
  local diff = os.time() - timestamp
  local years, months, weeks, days, hours, minutes, seconds = 0, 0, 0, 0, 0, 0, 0
  if diff >= 31536000 then
    years = math.floor(diff / 31536000)
    diff = diff - (years * 31536000)
  end
  if diff >= 2592000 then
    months = math.floor(diff / 2592000)
    diff = diff - (months * 2592000)
  end
  if diff >= 604800 then
    weeks = math.floor(diff / 604800)
    diff = diff - (weeks * 604800)
  end
  if diff >= 86400 then
    days = math.floor(diff / 86400)
    diff = diff - (days * 86400)
  end
  if diff >= 3600 then
    hours = math.floor(diff / 3600)
    diff = diff - (hours * 3600)
  end
  if diff >= 60 then
    minutes = math.floor(diff / 60)
    diff = diff - (minutes * 60)
  end
  seconds = diff
  if M.is(years) then
    return string.format('%2d years,   %2d months  ago.', years, months)
  elseif M.is(months) then
    return string.format('%2d months,  %2d weeks   ago.', months, weeks)
  elseif M.is(weeks) then
    return string.format('%2d weeks,   %2d days    ago.', weeks, days)
  elseif M.is(days) then
    return string.format('%2d days,    %2d hours   ago.', days, hours)
  elseif M.is(hours) then
    return string.format('%2d hours,   %2d minutes ago.', hours, minutes)
  elseif M.is(minutes) then
    return string.format('%2d minutes, %2d seconds ago.', minutes, seconds)
  elseif M.is(seconds) then
    return string.format('%2d minutes, %2d seconds ago.', 0, seconds)
  end
end

----------

function M.ui_sel(items, prompt, callback)
  if items and #items > 0 then
    vim.ui.select(items, { prompt = prompt, }, callback)
  end
end

-------------

function M.file_exists(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = M.rep_slash(file)
  return require 'plenary.path':new(file):exists()
end

function M.fetch_existed_files(files)
  local new_files = {}
  for _, file in ipairs(files) do
    file = vim.fn.trim(file)
    if #file > 0 and M.file_exists(file) then
      new_files[#new_files + 1] = file
    end
  end
  return new_files
end

---------

function M.merge_tables(...)
  local result = {}
  for _, t in ipairs { ..., } do
    for _, v in ipairs(t) do
      result[#result + 1] = v
    end
  end
  return result
end

M.depei = vim.fn.expand [[$HOME]] .. '\\DEPEI'

if vim.fn.isdirectory(M.depei) == 0 then vim.fn.mkdir(M.depei) end

M.my_dirs = {
  M.rep_backslash_lower(M.depei),
  M.rep_backslash_lower(vim.fn.expand [[$HOME]]),
  M.rep_backslash_lower(vim.fn.expand [[$TEMP]]),
  M.rep_backslash_lower(vim.fn.expand [[$LOCALAPPDATA]]),
  M.rep_backslash_lower(vim.fn.stdpath 'config'),
  M.rep_backslash_lower(vim.fn.stdpath 'data'),
  M.rep_backslash_lower(vim.fn.expand [[$VIMRUNTIME]]),
}

-----------

function M.lazy_map(tbls)
  for _, tbl in ipairs(tbls) do
    local opt = {}
    for k, v in pairs(tbl) do
      if type(k) == 'string' and k ~= 'mode' then
        opt[k] = v
      end
    end
    vim.keymap.set(tbl['mode'], tbl[1], tbl[2], opt)
  end
end

function M.del_map(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

-----------

function M.is_buf_fts(fts, buf)
  if not buf then
    buf = vim.fn.bufnr()
  end
  if type(fts) == 'string' then
    fts = { fts, }
  end
  if M.is(vim.tbl_contains(fts, vim.api.nvim_buf_get_option(buf, 'filetype'))) then
    return 1
  end
  return nil
end

-----------------

function M.get_dirs_equal(dname, root_dir)
  if not root_dir then
    root_dir = vim.fn['ProjectRootGet']()
  end
  local entries = require 'plenary.scandir'.scan_dir(root_dir, { hidden = false, depth = 32, add_dirs = true, })
  local dirs = {}
  for _, entry in ipairs(entries) do
    entry = M.rep_slash(entry)
    if require 'plenary.path':new(entry):is_dir() then
      local name = M.get_only_name(entry)
      if name == dname then
        dirs[#dirs + 1] = entry
      end
    end
  end
  return dirs
end

return M
