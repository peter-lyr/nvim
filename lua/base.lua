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

-------

function M.lazy_map(tbls)
  for _, tbl in ipairs(tbls) do
    local opt = {}
    for k, v in pairs(tbl) do
      if type(k) == 'string' and k ~= 'mode' then
        opt[k] = v
      end
    end
    local lhs = tbl[1]
    if type(lhs) == 'table' then
      for _, l in ipairs(lhs) do
        vim.keymap.set(tbl['mode'], l, tbl[2], opt)
      end
    else
      vim.keymap.set(tbl['mode'], lhs, tbl[2], opt)
    end
  end
end

function M.del_map(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
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

M.commands = {}

function M.create_user_command_with_M(m, name)
  M.commands[name] = M._get_functions_of_M(m)
  vim.api.nvim_create_user_command(name, function(params)
    if #params.fargs == 0 then
      pcall(M.cmd, "lua require('%s').main()", m.lua)
    elseif #params.fargs == 1 then
      pcall(M.cmd, "lua require('%s').%s()", m.lua, params.fargs[1])
    else
      local func = table.remove(params.fargs, 1)
      pcall(M.cmd, "lua require('%s').%s([[%s]])", m.lua, func, vim.fn.join(params.fargs, ']], [['))
    end
  end, {
    nargs = '*',
    desc = name,
    complete = function()
      return M.commands[name]
    end,
  })
end

function M.all_commands()
  M.ui_sel(vim.tbl_keys(M.commands), 'All Commands', function(command)
    if not command then
      return
    end
    M.ui_sel(M.commands[command], command, function(args)
      if args then
        command = string.format('%s %s', command, args)
        vim.cmd(command)
        vim.fn.histadd(':', command)
      end
    end)
  end)
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

function M.get_dirpath(dirs)
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

function M.getcreate_dirpath(dirs)
  dirs = M.totable(dirs)
  local dir1 = table.remove(dirs, 1)
  dir1 = M.rep_slash(dir1)
  local dir_path = require 'plenary.path':new(dir1)
  if not dir_path:exists() then
    vim.fn.mkdir(dir_path.filename)
  end
  for _, dir in ipairs(dirs) do
    dir_path = dir_path:joinpath(dir)
    if not dir_path:exists() then
      vim.fn.mkdir(dir_path.filename)
    end
  end
  return dir_path
end

function M.getcreate_stddata_dirpath(dirs)
  dirs = M.totable(dirs)
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return M.getcreate_dirpath(dirs)
end

-- M.windows_temp = [[C:\Windows\Temp]]
M.windows_temp = vim.fn.expand [[$HOME]] .. '\\myTemp'

function M.getcreate_temp_dirpath(dirs)
  dirs = M.totable(dirs)
  table.insert(dirs, 1, M.windows_temp)
  return M.getcreate_dirpath(dirs)
end

function M.getcreate_dir(dirs)
  return M.getcreate_dirpath(dirs).filename
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
  require 'notify'.dismiss()
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'error', {
    title = title,
    animate = false,
    on_open = M.notify_on_open,
    timeout = 1000 * 8,
  })
end

function M.notify_info_append(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'info', {
    title = title,
    animate = false,
    on_open = M.notify_on_open,
    timeout = 1000 * 8,
  })
end

function M.notify_error_append(message)
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

function M.qfmakeconv(from, to)
  local qflist = vim.deepcopy(M.qflist)
  for _, i in ipairs(qflist) do
    i.text = vim.fn.iconv(i.text, from, to)
  end
  if qflist then
    vim.fn.setqflist(qflist)
  end
end

function M.notify_qflist()
  local lines = {}
  local chcp_en = M.is_in_str('936', vim.fn.system 'chcp')
  local qflist = vim.deepcopy(M.qflist)
  for _, i in ipairs(qflist) do
    if chcp_en then
      i.text = vim.fn.iconv(i.text, 'cp936', 'utf-8')
    end
    lines[#lines + 1] = i.text
  end
  if qflist then
    vim.fn.setqflist(qflist)
  end
  M.notify_info(lines)
end

function M.refresh_fugitive()
  vim.cmd 'Lazy load vim-fugitive'
  vim.call 'fugitive#ReloadStatus'
end

M.asyncrun_done_changed = nil

function M.asyncrun_done_default()
  M.qflist = vim.fn.getqflist()
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
  vim.api.nvim_win_set_option(win, 'conceallevel', 3)
end

M.histadd_en = nil

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
  else
    M.histadd_en = nil
    return
  end
  if M.histadd_en then
    vim.fn.histadd(':', cmd)
  end
  M.histadd_en = nil
end

function M.powershell_run(str_format, ...)
  vim.g.powershell_script_code = string.format(str_format, ...)
  vim.g.powershell_status_code = nil
  vim.cmd [[
    python << EOF
import vim
import subprocess
powershell_script_code = vim.eval('g:powershell_script_code')
completed_process = subprocess.run(["powershell.exe", "-Command", powershell_script_code], capture_output=True, text=True)
if completed_process.returncode:
  print(f"Error: {completed_process.stderr}")
  vim.command('let g:powershell_status_code = 1')
EOF
]]
end

function M.format(str_format, ...)
  return string.format(str_format, ...)
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

function M.echo(str_format, ...)
  str_format = string.gsub(str_format, "'", '"')
  M.cmd(string.format("ec '" .. str_format .. "'", ...))
end

function M.system_cd(file)
  vim.cmd 'Lazy load plenary.nvim'
  if require 'plenary.path'.new(file):is_dir() then
    return 'cd /d ' .. file
  else
    return 'cd /d ' .. require 'plenary.path'.new(file):parent().filename
  end
end

function M.file_parent(file)
  vim.cmd 'Lazy load plenary.nvim'
  return require 'plenary.path'.new(file):parent().filename
end

-------------------

function M.get_file_dirs(file)
  vim.cmd 'Lazy load plenary.nvim'
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  file = M.rep_slash(file)
  local file_path = require 'plenary.path':new(file)
  local dirs = {}
  if not file_path:is_file() then
    table.insert(dirs, 1, M.rep_backslash(file_path.filename))
  end
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
    table.insert(dirs, 1, name)
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

M.ignore_dirs = {
  'build', 'dist',
  '%.cache',
  '%.git', '%.git-.*',
}

function M.match_string_and(str, patterns)
  patterns = M.totable(patterns)
  for _, pattern in ipairs(patterns) do
    if not string.match(str, pattern) then
      return nil
    end
  end
  return 1
end

function M.match_string_or(str, patterns)
  patterns = M.totable(patterns)
  for _, pattern in ipairs(patterns) do
    if string.match(str, pattern) then
      return 1
    end
  end
  return nil
end

function M.scan_files_do(dir, opt, entries)
  local files = {}
  local patterns = nil
  local filetypes = nil
  if opt then
    patterns = opt['patterns']
    filetypes = opt['filetypes']
  end
  for _, entry in ipairs(entries) do
    local file = M.rep_slash(entry)
    local f = string.sub(file, #dir + 2, #file)
    if (not M.is(patterns) or M.match_string_or(f, patterns)) and
        (not M.is(filetypes) or M.is_file_in_filetypes(f, filetypes)) then
      if not M.match_string_or(f, M.ignore_dirs) then
        files[#files + 1] = file
      end
    end
  end
  return files
end

function M.scan_files_deep(dir, opt)
  if not dir then dir = vim.loop.cwd() end
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = true, depth = 32, add_dirs = false, })
  return M.scan_files_do(dir, opt, entries)
end

function M.scan_files(dir, opt)
  if not dir then dir = vim.loop.cwd() end
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = true, depth = 1, add_dirs = false, })
  return M.scan_files_do(dir, opt, entries)
end

function M.scan_dirs(dir, pattern)
  vim.cmd 'mes clear'
  if not dir then
    dir = vim.loop.cwd()
  end
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = false, depth = 64, add_dirs = true, })
  local dirs = {}
  for _, entry in ipairs(entries) do
    if M.is(require 'plenary.path':new(entry):is_dir()) and (not pattern or string.match(entry, pattern)) then
      dirs[#dirs + 1] = entry
    end
  end
  return dirs
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
  vim.cmd 'Lazy load telescope.nvim'
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

function M.is_file(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = M.rep_slash(file)
  local fpath = require 'plenary.path':new(file)
  if fpath:exists() then
    if fpath:is_file() then
      return 1
    end
  end
  return nil
end

function M.is_dir(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = M.rep_slash(file)
  local fpath = require 'plenary.path':new(file)
  if fpath:exists() then
    if fpath:is_dir() then
      return 1
    end
  end
  return nil
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

function M.merge_dict(...)
  local result = {}
  for _, d in ipairs { ..., } do
    for k, v in pairs(d) do
      result[k] = v
    end
  end
  return result
end

function M.get_dict_count(tbl)
  local count = 0
  for _, _ in pairs(tbl) do
    count = count + 1
  end
  return count
end

M.depei = vim.fn.expand [[$HOME]] .. '\\DEPEI'
M.nvim_dir = vim.fn.stdpath 'config'

if vim.fn.isdirectory(M.depei) == 0 then vim.fn.mkdir(M.depei) end

function M.get_repos_dir()
  return M.get_dirpath { M.file_parent(M.nvim_dir), 'repos', }.filename
end

function M.get_my_dirs()
  return {
    M.rep_backslash_lower(M.depei),
    M.get_repos_dir(),
    M.rep_backslash_lower(vim.fn.expand [[$HOME]]),
    M.rep_backslash_lower(vim.fn.expand [[$TEMP]]),
    M.rep_backslash_lower(vim.fn.expand [[$LOCALAPPDATA]]),
    M.rep_backslash_lower(vim.fn.stdpath 'config'),
    M.rep_backslash_lower(vim.fn.stdpath 'data'),
    M.rep_backslash_lower(vim.fn.expand [[$VIMRUNTIME]]),
  }
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

function M.is_file_in_filetypes(file, filetypes)
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  filetypes = M.totable(filetypes)
  local ext = string.match(file, '%.([^.]+)$')
  if not filetypes or M.is(vim.tbl_contains(filetypes, ext)) then
    return 1
  end
  return nil
end

-----------------

function M.get_dirs_equal(dname, root_dir, opt)
  if not root_dir then
    root_dir = vim.fn['ProjectRootGet']()
  end
  local default_opt = { hidden = false, depth = 32, add_dirs = true, }
  opt = vim.tbl_deep_extend('force', default_opt, opt)
  local entries = require 'plenary.scandir'.scan_dir(root_dir, opt)
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

function M.deep_compare(t1, t2)
  if type(t1) ~= 'table' or type(t2) ~= 'table' then
    return M.is(t1 == t2)
  end
  for k, v in pairs(t1) do
    if not M.deep_compare(t2[k], v) then
      return nil
    end
  end
  for k, v in pairs(t2) do
    if not M.deep_compare(t1[k], v) then
      return nil
    end
  end
  return 1
end

function M.get_full_name(file)
  return vim.fn.fnamemodify(file, ':p')
end

function M.is_file_in_extensions(extensions, file)
  extensions = M.totable(extensions)
  return M.is(vim.tbl_contains(extensions, string.match(file, '%.([^.]+)$'))) and 1 or nil
end

function M.is_file_opened_buffer(file)
  if vim.fn.index(vim.fn.map(vim.fn.range(1, vim.fn.bufnr '$'), 'bufname(v:val)'), file) ~= -1 then
    return 1
  else
    return nil
  end
end

function M.index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return -1
end

function M.get_root_short(project_root_path)
  local temp__ = vim.fn.tolower(vim.fn.fnamemodify(project_root_path, ':t'))
  if #temp__ >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(temp__, #temp__ - i, #temp__)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(temp__, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  local updir = vim.fn.tolower(vim.fn.fnamemodify(project_root_path, ':h:t'))
  if #updir >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(updir, #updir - i, #updir)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(updir, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return updir .. '/' .. temp__
end

function M.get_fname_short(fname)
  local temp__ = vim.fn.tolower(vim.fn.fnamemodify(fname, ':t'))
  if #temp__ >= 17 then
    local s1 = ''
    local s2 = ''
    for i = 17, 3, -1 do
      s2 = string.sub(temp__, #temp__ - i, #temp__)
      if vim.fn.strdisplaywidth(s2) <= 8 then
        break
      end
    end
    for i = 17, 3, -1 do
      s1 = string.sub(temp__, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 8 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return temp__
end

function M.count_char(str, char)
  local count = 0
  for i = 1, #str do
    if str:sub(i, i) == char then
      count = count + 1
    end
  end
  return count
end

function M.get_hash(file)
  return require 'sha2'.sha256(require 'plenary.path':new(file):_read())
end

function M.is_in_tbl(item, tbl)
  return M.is(vim.tbl_contains(tbl, item))
end

function M.is_in_str(item, str)
  return string.match(str, item)
end

M.source = M.getsource(debug.getinfo(1)['source'])

function M.get_SHGetFolderPath(name)
  local exe_name = 'SHGetFolderPath'
  local SHGetFolderPath_without_ext = M.get_filepath(M.source .. '.c', exe_name).filename
  local SHGetFolderPath_exe = SHGetFolderPath_without_ext .. '.exe'
  if not M.is(vim.fn.filereadable(SHGetFolderPath_exe)) then
    M.system_run('start silent', '%s && gcc %s.c -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O2 -o %s.exe', M.system_cd(SHGetFolderPath_without_ext), exe_name, exe_name)
    M.notify_info 'exe creating, try again later...'
    return {}
  end
  local f = io.popen(SHGetFolderPath_exe .. ' ' .. (name and name or ''))
  if f then
    local dirs = {}
    for dir in string.gmatch(f:read '*a', '([%S ]+)') do
      dir = M.rep_slash(dir)
      if not M.is_in_tbl(dir, dirs) then
        dirs[#dirs + 1] = dir
      end
    end
    f:close()
    return dirs
  end
  return {}
end

function M.wingoto_file_or_open(file)
  local winnr = vim.fn.bufwinnr(vim.fn.bufnr(file))
  if winnr ~= -1 then
    vim.fn.win_gotoid(vim.fn.win_getid(winnr))
    return 1
  end
  vim.cmd 'wincmd s'
  M.cmd('e %s', file)
  return nil
end

M.temp_prefix = 'nvim_temp'

function M.get_temp(filename, extension)
  if #filename > 0 then
    filename = M.temp_prefix .. '_' .. filename
  else
    filename = M.temp_prefix
  end
  return M.getcreate_temp_dirpath { M.temp_prefix .. '_' .. extension, }:joinpath(filename .. '.' .. extension).filename
end

function M.open_temp(filename, extension)
  local nvim_temp = M.get_temp(filename, extension)
  M.wingoto_file_or_open(nvim_temp)
  return nvim_temp
end

function M.write_to_temp(filename, extension)
  local nvim_temp = M.get_temp(filename, extension)
  if M.is_file(nvim_temp) then
    if vim.fn.bufnr(nvim_temp) ~= -1 then
      M.cmd('bw! %s', nvim_temp)
    end
    vim.fn.system(string.format('move "%s" "%s"', nvim_temp, string.match(nvim_temp, '(.+)%.%w+') .. vim.fn.strftime '-%Y%m%d-%H%M%S.' .. extension))
  end
  M.cmd('w! %s', nvim_temp)
  M.cmd('e %s', nvim_temp)
end

function M.get_ignore_files()
  local _proj_root = M.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if not M.is(_proj_root) then
    M.notify_info('not in a project root: ' .. file)
    return {}
  end
  local ignored_files = {}
  local out = vim.fn.system 'git ls-files --exclude-standard --ignored --others'
  for rel in string.gmatch(out, '([^\r\n]+)') do
    ignored_files[#ignored_files + 1] = _proj_root .. '/' .. M.rep_backslash_lower(rel)
  end
  return ignored_files
end

function M.tbl_deep_extend_force(default, opt)
  return vim.tbl_deep_extend('force', default, opt or {})
end

function M.scan_temp(opt)
  local default = { patterns = M.temp_prefix .. '.+\\' .. M.temp_prefix .. '.+', }
  return M.scan_files_deep(M.windows_temp, M.tbl_deep_extend_force(default, opt))
end

function M.delete_file(file)
  M.system_run('start', 'git rm "%s"', file)
  M.system_run('start', 'del /f /q "%s"', file)
end

function M.delete_folder(folder)
  M.system_run('start', 'rd /s /q "%s"', folder)
end

function M.get_cfile(cfile)
  if not cfile then
    cfile = M.normpath(M.format('%s\\%s', vim.fn.expand '%:p:h', vim.fn.expand '<cfile>'))
    if M.is(cfile) then
      return cfile
    else
      cfile = M.normpath(M.format('%s\\%s', vim.fn.expand '%:p:h', string.match(vim.fn.getline '.', '`([^`]+)`')))
      if M.is(cfile) then
        return cfile
      end
    end
    cfile = M.normpath(M.format('%s\\%s', vim.loop.cwd(), vim.fn.expand '<cfile>'))
    if M.is(cfile) then
      return cfile
    else
      cfile = M.normpath(M.format('%s\\%s', vim.loop.cwd(), string.match(vim.fn.getline '.', '`([^`]+)`')))
      if M.is(cfile) then
        return cfile
      end
    end
  end
  cfile = M.normpath(M.format('%s\\%s', vim.fn.expand '%:p:h', cfile))
  if M.is(cfile) then
    return cfile
  end
  return M.normpath(M.format('%s\\%s', vim.loop.cwd(), cfile))
end

function M.system_open_file(str_format, ...)
  M.histadd_en = 1
  M.system_run('start', str_format, ...)
end

function M.system_open_file_silent(str_format, ...)
  M.histadd_en = 1
  M.system_run('start silent', str_format, ...)
end

function M.filter_exclude(tbl, patterns)
  return vim.tbl_filter(function(str)
    if M.match_string_or(str, patterns) then
      return false
    end
    return true
  end, tbl)
end

function M.get_startup_files()
  local all_startup = M.get_SHGetFolderPath 'all_startup'
  if M.is(all_startup) then
    local files = {}
    for _, start_up in ipairs(all_startup) do
      local a = M.scan_files_deep(start_up, { filetypes = { 'lnk', }, })
      files = M.merge_tables(files, a)
    end
    return files
  end
  return {}
end

function M.get_path_files()
  local files = {}
  for programs in string.gmatch(vim.fn.system 'echo %path%', '([^;]+);') do
    local a = M.scan_files_deep(programs, { filetypes = { 'lnk', }, })
    a = M.filter_exclude(a, { '卸载', 'uninst', 'Uninst', })
    files = M.merge_tables(files, a)
  end
  return files
end

function M.get_programs_files()
  local all_programs = M.get_SHGetFolderPath 'all_programs'
  if M.is(all_programs) then
    local files = {}
    for _, programs in ipairs(all_programs) do
      local a = M.scan_files_deep(programs, { filetypes = { 'lnk', }, })
      a = M.filter_exclude(a, { '卸载', 'uninst', 'Uninst', })
      files = M.merge_tables(files, a)
    end
    return files
  end
  return {}
end

function M.normpath(file)
  if not M.file_exists(file) then
    return ''
  end
  vim.g.normpath = file
  vim.cmd [[
    python << EOF
import os
import vim
normpath = os.path.normpath(vim.eval('g:normpath')).replace('\\', '/')
vim.command(f'let g:normpath = "{normpath}"')
EOF
]]
  return vim.g.normpath
end

function M.relpath(file, start)
  if not M.is(file) then
    return
  end
  vim.g.relpath = file
  vim.g.startpath = start and start or ''
  vim.cmd [[
    python << EOF
import os
import vim
try:
  relpath = os.path.relpath(vim.eval('g:relpath'), vim.eval('g:startpath')).replace('\\', '/')
  vim.command(f'let g:relpath = "{relpath}"')
except:
  vim.command(f'let g:relpath = ""')
EOF
]]
  return vim.g.relpath
end

function M.read_table_from_file(file)
  file = require 'plenary.path':new(file)
  if not file:exists() then
    return nil
  end
  local res = file:read()
  if #res > 0 then
    res = loadstring('return ' .. res)()
    if res then
      return res
    end
  end
  return nil
end

function M.write_table_to_file(file, tbl)
  require 'plenary.path':new(file):write(vim.inspect(tbl), 'w')
end

function M.append_line_to_file(file, line)
  require 'plenary.path':new(file):write(vim.fn.trim(line) .. '\n', 'a')
end

function M.findall(patt, str)
  vim.g.patt = patt
  vim.g.str = str
  vim.g.res = {}
  vim.cmd [[
    python << EOF
import re
import vim
try:
  import luadata
except:
  import os
  os.sytem('pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com luadata')
  import luadata
patt = vim.eval('g:patt')
string = vim.eval('g:str')
res = re.findall(patt, string)
if res:
  new_res = eval(str(res).replace('(', '[').replace(')', ']'))
  new_res = luadata.serialize(new_res, encoding='utf-8', indent=' ', indent_level=0)
  vim.command(f"""lua vim.g.res = {new_res}""")
EOF
  ]]
  return vim.g.res
end

function M.get_nvim_qt_exe_pid()
  return vim.loop.os_getppid(vim.fn.getpid())
end

function M.get_shada_file()
  local shada_file = vim.fn.stdpath 'state' .. '\\shada\\main.shada'
  return shada_file
end

function M.get_shada_file_new()
  return vim.fn.stdpath 'state' .. '\\shada\\main.shada.new'
end

function M.stack_item(tbl, item, len)
  local res = {}
  if M.is(tbl) and tbl[#tbl] == item then
    return res
  end
  if #tbl >= len then
    for _ = 1, #tbl - len + 1 do
      res[#res + 1] = table.remove(tbl, 1)
    end
  end
  tbl[#tbl + 1] = item
  return res
end

function M.get_running_executables()
  local exes = {}
  for exe in string.gmatch(vim.fn.system 'tasklist', '([^\n]+.exe)') do
    if not M.is_in_tbl(exe, exes) then
      exes[#exes + 1] = vim.fn.tolower(exe)
    end
  end
  return exes
end

function M.is_sure(str_format, ...)
  local prompt = string.format(str_format, ...)
  local res = vim.fn.input(string.format('%s ? [Y/n]: ', prompt), 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == false then
    return nil
  end
  return 1
end

function M.jump_or_edit(file)
  file = M.rep_slash_lower(file)
  local file_proj = M.rep_slash_lower(vim.fn['ProjectRootGet'](file))
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    local fname = M.rep_slash_lower(vim.api.nvim_buf_get_name(bufnr))
    if M.file_exists(fname) then
      local proj = M.rep_slash_lower(vim.fn['ProjectRootGet'](fname))
      if M.is(proj) and file_proj == proj then
        vim.fn.win_gotoid(vim.fn.win_getid(winnr))
        break
      end
    end
  end
  M.cmd('e %s', file)
end

function M.get_git_remote_url(proj)
  local remote = ''
  if proj then
    remote = vim.fn.system(string.format('cd %s && git remote -v', proj))
  else
    remote = vim.fn.system 'git remote -v'
  end
  local res = M.findall('.*git@([^:]+):([^/]+)/(.+)\\.git.*', remote)
  local urls = {}
  local type = nil
  if #res == 0 then
    res = M.findall('https://([^ ]+)', remote)
    for _, r in ipairs(res) do
      local url = r
      if not M.is_in_tbl(url, urls) then
        urls[#urls + 1] = url
        type = 'https'
      end
    end
  else
    for _, r in ipairs(res) do
      local url = string.format('%s/%s/%s', unpack(r))
      if not M.is_in_tbl(url, urls) then
        urls[#urls + 1] = url
        type = 'ssh'
      end
    end
  end
  if #urls > 0 then
    return type, string.format('%s', urls[1])
  end
  return type, ''
end

function M.get_head_dir()
  local fname = M.rep_slash_lower(vim.api.nvim_buf_get_name(0))
  if M.is(fname) and M.file_exists(fname) then
    return M.file_parent(fname)
  end
  return vim.loop.cwd()
end

function M.toggle_value(val)
  if val == true then
    return false
  elseif val == false then
    return true
  elseif val == 1 then
    return 0
  elseif val == 0 then
    return 1
  end
end

return M
