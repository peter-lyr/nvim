local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

function M.source(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
  package.loaded[B.getlua(B.rep_backslash(file))] = nil
  B.print('source %s', file)
  B.cmd('source %s', file)
end

M.nvim_qt_start_flag_socket_txt = vim.fn.expand [[$HOME]] .. '\\DEPEI\\nvim_qt_start_flag_socket.txt'

function M.restart_new_nvim_qt()
  vim.fn.writefile({ '1', }, M.nvim_qt_start_flag_socket_txt)
  local _restart_nvim_qt_py_path = B.getcreate_filepath(B.getcreate_stddata_dirpath 'restart_nvim_qt'.filename, 'restart_nvim_qt.py')
  local rtp = vim.fn.expand(string.match(vim.fn.execute 'set rtp', ',([^,]+)\\share\\nvim\\runtime'))
  _restart_nvim_qt_py_path:write(string.format([[
import os
try:
  import psutil
except:
  os.system("pip install psutil -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host mirrors.aliyun.com")
  import psutil
while 1:
  # if `require 'base'.get_nvim_qt_exe_pid()` not in psutil.pids():
  #   break
  with open(r'%s', 'rb') as f:
    if f.read().strip() == b'1':
      break
cmds = [
  r'cd %s\bin',
  r'start /d %s nvim-qt.exe',
  # r'start nvim-qt.exe.lnk,
]
for cmd in cmds:
  os.system(cmd)
]],
    M.nvim_qt_start_flag_socket_txt, rtp, vim.loop.cwd()), 'w')
  B.system_run('start silent', '%s', _restart_nvim_qt_py_path.filename)
end

function M.start_new_nvim_qt()
  local _start_nvim_qt_bat_path = B.getcreate_filepath(B.getcreate_stddata_dirpath 'start_nvim_qt'.filename, 'start_nvim_qt.bat')
  local rtp = vim.fn.expand(string.match(vim.fn.execute 'set rtp', ',([^,]+)\\share\\nvim\\runtime'))
  _start_nvim_qt_bat_path:write(string.format([[
@echo off
cd %s\bin
start /d %s nvim-qt.exe
# start nvim-qt.exe.lnk
exit
]],
    rtp, vim.loop.cwd()), 'w')
  vim.cmd(string.format([[silent !start /b /min %s]], _start_nvim_qt_bat_path.filename))
end

function M.restart_nvim_qt()
  vim.cmd 'SessionsSave'
  M.restart_new_nvim_qt()
  vim.cmd 'qall!'
end

function M.quit_nvim_qt()
  vim.cmd 'qall!'
end

function M.map_buf_close(lhs, buf, cmd)
  if not cmd then
    cmd = 'close!'
  end
  if not buf then
    buf = vim.fn.bufnr()
  end
  local desc = string.format('close buf %d', buf)
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    vim.cmd(cmd)
  end, { buffer = buf, nowait = true, desc = desc, })
end

function M.map_buf_c_q_close(buf, cmd)
  M.map_buf_close('<c-q>', buf, cmd)
end

function M.execute_output(cmd)
  B.open_temp('execute_output', 'txt')
  vim.cmd 'norm ggdG'
  vim.fn.append(vim.fn.line '.', vim.fn.split(vim.fn.execute(cmd), '\n'))
  M.map_buf_c_q_close(vim.fn.bufnr(), 'bwipeout!')
end

M.temp_extensions = {
  'txt', 'md',
  'c', 'py',
}

function M.sel_open_temp()
  local files = B.scan_temp { filetypes = M.temp_extensions, }
  local only_names = {}
  for _, file in ipairs(files) do
    only_names[#only_names + 1] = string.sub(file, #B.windows_temp + 2, #file)
  end
  B.ui_sel(only_names, 'open which', function(_, index)
    if index then
      B.wingoto_file_or_open(files[index])
    end
  end)
end

function M.sel_write_to_temp()
  B.ui_sel(M.temp_extensions, 'save to which', function(extension)
    if extension then
      B.write_to_temp('', extension)
    end
  end)
end

vim.api.nvim_create_user_command('ExecuteOutput', function(params)
  M.execute_output(vim.fn.join(params['fargs'], ' '))
end, { nargs = '*', complete = 'command', })

function M.type_execute_output()
  local cmd = vim.fn.input 'ExecuteOutput: '
  if B.is(cmd) then
    B.cmd('ExecuteOutput %s', cmd)
  end
end

function M.mes_clear()
  vim.cmd 'mes clear'
  vim.cmd 'echo "mes clear"'
end

function M.monitor_1min()
  B.system_run('start silent', 'powercfg -x -monitor-timeout-ac 1')
  B.notify_info 'monitor_1min'
end

function M.monitor_30min()
  B.system_run('start silent', 'powercfg -x -monitor-timeout-ac 30')
  B.notify_info 'monitor_30min'
end

function M.monitor_5hours()
  B.system_run('start silent', 'powercfg -x -monitor-timeout-ac 300')
  B.notify_info 'monitor_5hours'
end

function M.proxy_on()
  B.system_run('start silent', [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f]])
  B.notify_info 'prx_on'
end

function M.proxy_off()
  B.system_run('start silent', [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f]])
  B.notify_info 'prx_off'
end

function M.open_path() B.system_run('start silent', 'start rundll32 sysdm.cpl,EditEnvironmentVariables') end

function M.open_sound() B.system_run('start silent', 'mmsys.cpl') end

function M.get_target_path(lnk_file)
  local ext = string.match(lnk_file, '%.([^.]+)$')
  if not B.is(vim.tbl_contains({ 'url', 'lnk', }, ext)) then
    return lnk_file
  end
  vim.g.lnk_file = lnk_file
  vim.g.target_path = nil
  vim.cmd [[
    python << EOF
try:
  import pythoncom
except:
  import os
  os.system('pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host mirrors.aliyun.com pywin32')
  import pythoncom
from win32com.client import Dispatch
lnk_file = vim.eval('g:lnk_file')
pythoncom.CoInitialize()
shell = Dispatch("WScript.Shell")
try:
  shortcut = shell.CreateShortCut(lnk_file)
  target_path = shortcut.TargetPath
  vim.command(f"""let g:target_path = '{target_path}'""")
except:
  pass
EOF
  ]]
  return vim.g.target_path
end

M.programs_files_dir_path = B.getcreate_stddata_dirpath 'programs-files'
M.programs_files_txt_path = M.programs_files_dir_path:joinpath 'programs-files.txt'

function M.get_programs_files_uniq()
  local programs_files = B.get_programs_files()
  local path_programs_files = B.get_path_files()
  local programs_files_uniq = B.merge_tables(vim.deepcopy(programs_files), vim.deepcopy(path_programs_files))
  local programs_files_uniq_temp = vim.deepcopy(programs_files_uniq)
  for _, programs_file in pairs(programs_files_uniq_temp) do
    programs_file = M.get_target_path(programs_file)
    if not B.is_in_tbl(programs_file, programs_files_uniq) then
      programs_files_uniq[#programs_files_uniq + 1] = programs_file
    end
  end
  B.write_table_to_file(M.programs_files_txt_path.filename, programs_files_uniq)
  return programs_files_uniq
end

function M.sel_open_programs_file()
  local programs_files_uniq = B.read_table_from_file(M.programs_files_txt_path)
  if not B.is(programs_files_uniq) then
    M.sel_open_programs_file_force(1)
    return
  end
  B.ui_sel(programs_files_uniq, 'sel_open_programs_file', function(programs_file)
    if programs_file then
      B.system_open_file_silent(programs_file)
    end
  end)
end

function M.sel_open_programs_file_force(force)
  local programs_files_uniq = {}
  if force then
    programs_files_uniq = M.get_programs_files_uniq()
  else
    local temp = B.read_table_from_file(M.programs_files_txt_path)
    if temp then
      if B.is_sure('%s has %d items, Sure to re run scanning all? It maybe timing a lot', M.programs_files_txt_path, #temp) then
        programs_files_uniq = M.get_programs_files_uniq()
      else
        programs_files_uniq = temp
      end
    end
  end
  B.ui_sel(programs_files_uniq, 'sel_open_programs_file_force', function(programs_file)
    if programs_file then
      B.system_open_file_silent(programs_file)
    end
  end)
end

function M.sel_kill_programs_file()
  local programs_files_uniq = B.read_table_from_file(M.programs_files_txt_path)
  if not programs_files_uniq or not B.is(programs_files_uniq) then
    M.sel_kill_programs_file_force(1)
    return
  end
  local running_executables = B.get_running_executables()
  local exes = {}
  for _, file in ipairs(programs_files_uniq) do
    for _, temp in ipairs(running_executables) do
      if B.is_in_str(temp, vim.fn.tolower(file)) and not B.is_in_tbl(temp, exes) then
        exes[#exes + 1] = temp
        break
      end
    end
  end
  B.ui_sel(exes, 'sel_kill_programs_file', function(exe)
    if exe then
      B.system_run('start silent', 'taskkill /f /im %s', exe)
    end
  end)
end

function M.sel_kill_programs_file_force(force)
  local programs_files_uniq = {}
  if force then
    programs_files_uniq = M.get_programs_files_uniq()
  else
    local temp = B.read_table_from_file(M.programs_files_txt_path)
    if temp then
      if B.is_sure('%s has %d items, Sure to re run scanning all? It maybe timing a lot', M.programs_files_txt_path, #temp) then
        programs_files_uniq = M.get_programs_files_uniq()
      else
        programs_files_uniq = temp
      end
    end
  end
  local running_executables = B.get_running_executables()
  local exes = {}
  for _, file in ipairs(programs_files_uniq) do
    for _, temp in ipairs(running_executables) do
      if B.is_in_str(temp, vim.fn.tolower(file)) and not B.is_in_tbl(temp, exes) then
        exes[#exes + 1] = temp
        break
      end
    end
  end
  B.ui_sel(exes, 'sel_kill_programs_file_force', function(exe)
    if exe then
      B.system_run('start silent', 'taskkill /f /im %s', exe)
    end
  end)
end

function M.sel_open_startup_file()
  local startup_files = B.get_startup_files()
  B.ui_sel(startup_files, 'sel_open_startup_file', function(startup_file)
    if startup_file then
      B.system_open_file_silent(startup_file)
    end
  end)
end

function M.get_human_fsize(fsize)
  local suffixes = { 'B', 'K', 'M', 'G', }
  local i = 1
  while fsize > 1024 and i < #suffixes do
    fsize = fsize / 1024
    i = i + 1
  end
  local format = i == 1 and '%d%s' or '%.1f%s'
  return string.format(format, fsize, suffixes[i])
end

function M.format_(size, human)
  return string.format('%-10s %6s', string.format('%s', size), string.format('`%s`', human))
end

function M._filesize()
  local file = vim.fn.expand '%:p'
  if file == nil or #file == 0 then
    return ''
  end
  local size = vim.fn.getfsize(file)
  if size <= 0 then
    return ''
  end
  return M.format_(size, M.get_human_fsize(size))
end

function M.get_git_added_file_total_fsize()
  local total_fsize = 0
  for fname in string.gmatch(vim.fn.system 'git ls-files', '([^\n]+)') do
    total_fsize = total_fsize + vim.fn.getfsize(fname)
  end
  return M.format_(total_fsize, M.get_human_fsize(total_fsize))
end

function M.get_git_ignore_file_total_fsize()
  local total_fsize = 0
  for fname in string.gmatch(vim.fn.system 'git ls-files -o', '([^\n]+)') do
    total_fsize = total_fsize + vim.fn.getfsize(fname)
  end
  return M.format_(total_fsize, M.get_human_fsize(total_fsize))
end

M.show_info_en = 1

function M.show_info_allow()
  M.show_info_en = 1
end

function M.show_info_do(temp, start_index)
  if not start_index then
    start_index = 0
  end
  local items = {}
  local width = 0
  for _, v in ipairs(temp) do
    if width < #v[1] then
      width = #v[1]
    end
  end
  local str = '# %2d. [%-' .. width .. 's]: %s'
  for k, v in ipairs(temp) do
    local k2, v2 = unpack(v)
    v2 = vim.fn.trim(v2())
    table.insert(items, 1, string.format(str, k + start_index, k2, v2))
  end
  return items
end

function M.show_info_one_do(temp, start_index)
  if not start_index then
    start_index = 0
  end
  local start_time = vim.fn.reltime()
  local items = M.show_info_do(temp, start_index)
  local end_time = vim.fn.reltimefloat(vim.fn.reltime(start_time))
  local timing = string.format('timing: %.3f ms', end_time * 1000)
  if start_index == 0 then
    B.notify_info { timing, vim.fn.join(items, '\n'), }
  else
    B.notify_info_append { timing, vim.fn.join(items, '\n'), }
  end
  return #items
end

function M.show_info_one(temp)
  M.len = M.len + M.show_info_one_do(temp, M.len)
end

function M.show_info()
  if not M.show_info_en then
    B.echo 'please wait'
    return
  end
  M.show_info_en = nil
  B.set_timeout(1000, function()
    M.show_info_en = 1
  end)
  M.len = 0
  M.show_info_one {
    { 'cwd',          function() return string.format('`%s`', vim.loop.cwd()) end, },
    { 'datetime',     function() return vim.fn.strftime '%Y-%m-%d %H:%M:%S `%a`' end, },
    { 'fileencoding', function() return string.format('`%s`', vim.opt.fileencoding:get()) end, },
    { 'fileformat',   function() return string.format('%s', vim.bo.fileformat) end, },
    { 'fname',        function() return string.format('`%s`', vim.fn.bufname()) end, },
    { 'mem',          function() return string.format('%dM', vim.loop.resident_set_memory() / 1024 / 1024) end, },
    { 'startuptime',  function() return string.format('`%.3f` ms', vim.g.end_time * 1000) end, },
  }
  M.show_info_one {
    { 'fsize',            M._filesize, },
    { 'git added fsize',  M.get_git_added_file_total_fsize, },
    { 'git ignore fsize', M.get_git_ignore_file_total_fsize, },
  }
  M.show_info_one {
    { 'git branch name',  vim.fn['gitbranch#name'], },
    { 'git commit count', function() return '`' .. vim.fn.trim(vim.fn.system 'git rev-list --count HEAD') .. '` commits' end, },
    { 'git added  files', function() return '`' .. vim.fn.trim(vim.fn.system 'git ls-files | wc -l') .. '` files added' end, },
    { 'git ignore files', function() return '`' .. vim.fn.trim(vim.fn.system 'git ls-files -o | wc -l') .. '` files ignored' end, },
  }
end

function M.git_init_and_cmake()
  local dirs = B.get_file_dirs()
  dirs = B.merge_tables({ vim.loop.cwd(), }, dirs)
  B.ui_sel(dirs, 'git_init_and_cmake', function(dir)
    if dir then
      require 'config.my.git'.init_do(dir)
      require 'config.my.c'._cmake_do(dir, 1)
    end
  end)
end

function M.qfmakeconv2utf8()
  B.qfmakeconv('cp936', 'utf-8')
end

function M.qfmakeconv2cp936()
  B.qfmakeconv('utf-8', 'cp936')
end

function M.open_file()
  local file = vim.fn.getreg '+'
  if B.is_file(file) then
    B.jump_or_edit(file)
  end
end

function M.prepare_sessions()
  if '1' == vim.fn.trim(vim.fn.join(vim.fn.readfile(M.nvim_qt_start_flag_socket_txt), '')) then
    vim.fn.writefile({ '2', }, M.nvim_qt_start_flag_socket_txt)
  end
end

-- mapping
B.del_map({ 'n', 'v', }, '<leader>a')
B.del_map({ 'n', 'v', }, '<F4>')

require 'base'.whichkey_register({ 'n', 'v', }, '<leader>a', 'my.box')
require 'base'.whichkey_register({ 'n', 'v', }, '<F4>', 'my.box')

require 'base'.whichkey_register({ 'n', 'v', }, '<leader>ao', 'my.box.open')
require 'base'.whichkey_register({ 'n', 'v', }, '<leader>am', 'my.box.monitor')
require 'base'.whichkey_register({ 'n', 'v', }, '<leader>ap', 'my.box.proxy')
require 'base'.whichkey_register({ 'n', 'v', }, '<leader>as', 'my.box.sel/nvim-qt')
require 'base'.whichkey_register({ 'n', 'v', }, '<leader>ag', 'my.box.git')
require 'base'.whichkey_register({ 'n', 'v', }, '<leader>aq', 'my.box.qf')

B.lazy_map {
  { '<leader>asr',        function() M.restart_nvim_qt() end,              mode = { 'n', 'v', }, silent = true, desc = 'my.box.nvim-qt: restart_nvim_qt', },
  { '<leader>as<leader>', function() M.start_new_nvim_qt() end,            mode = { 'n', 'v', }, silent = true, desc = 'my.box.nvim-qt: start_new_nvim_qt', },
  { '<leader>asq',        function() M.quit_nvim_qt() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.box.nvim-qt: quit_nvim_qt', },
  { '<leader>aa',         function() M.source() end,                       mode = { 'n', 'v', }, silent = true, desc = 'my.box: source', },
  { '<leader>ax',         function() M.type_execute_output() end,          mode = { 'n', 'v', }, silent = true, desc = 'my.box: type_execute_output', },
  { '<leader>ae',         function() M.sel_open_temp() end,                mode = { 'n', 'v', }, silent = true, desc = 'my.box: sel_open_temp', },
  { '<leader>aw',         function() M.sel_write_to_temp() end,            mode = { 'n', 'v', }, silent = true, desc = 'my.box: sel_write_to_temp', },
  { '<leader>a<c-e>',     function() M.mes_clear() end,                    mode = { 'n', 'v', }, silent = true, desc = 'my.box: mes_clear', },
  { '<leader>aop',        function() M.open_path() end,                    mode = { 'n', 'v', }, silent = true, desc = 'my.box.open: open_path', },
  { '<leader>aos',        function() M.open_sound() end,                   mode = { 'n', 'v', }, silent = true, desc = 'my.box.open: open_sound', },
  { '<leader>am1',        function() M.monitor_1min() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.box.monitor: monitor_1min', },
  { '<leader>am3',        function() M.monitor_30min() end,                mode = { 'n', 'v', }, silent = true, desc = 'my.box.monitor: monitor_30min', },
  { '<leader>am5',        function() M.monitor_5hours() end,               mode = { 'n', 'v', }, silent = true, desc = 'my.box.monitor: monitor_5hours', },
  { '<leader>apo',        function() M.proxy_on() end,                     mode = { 'n', 'v', }, silent = true, desc = 'my.box.proxy: proxy_on', },
  { '<leader>apf',        function() M.proxy_off() end,                    mode = { 'n', 'v', }, silent = true, desc = 'my.box.proxy: proxy_off', },
  { '<leader>asp',        function() M.sel_open_programs_file() end,       mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_open_programs_file', },
  { '<leader>as<c-p>',    function() M.sel_open_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_open_programs_file_force', },
  { '<leader>ask',        function() M.sel_kill_programs_file() end,       mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_kill_programs_file', },
  { '<leader>as<c-k>',    function() M.sel_kill_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_kill_programs_file_force', },
  { '<leader>ass',        function() M.sel_open_startup_file() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_open_startup_file', },
  { '<leader>agm',        function() M.git_init_and_cmake() end,           mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: git_init_and_cmake', },
  { '<leader>aq8',        function() M.qfmakeconv2utf8() end,              mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: qfmakeconv2utf8', },
  { '<leader>aq9',        function() M.qfmakeconv2cp936() end,             mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: qfmakeconv2cp936', },
  { '<leader>aof',        function() M.open_file() end,                    mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: open_file', },
}

if not M.reg then
  M.reg = {}
end

function M.yank(reg, mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  M.reg[reg] = vim.fn.getreg '"'
  print('vim.inspect(M.reg):', vim.inspect(M.reg))
end

B.lazy_map {
  { '<F4>a',     function() M.yank('a', 'n', 'w') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cword> to a', },
  { '<F4><c-a>', function() M.yank('a', 'n', 'W') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cWORD> to a', },
  { '<F4>a',     function() M.yank('a', 'v') end,      mode = { 'v', }, silent = true, desc = 'my.box.yank: sel to a', },
  { '<F4>b',     function() M.yank('b', 'n', 'w') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cword> to b', },
  { '<F4><c-b>', function() M.yank('b', 'n', 'W') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cWORD> to b', },
  { '<F4>b',     function() M.yank('b', 'v') end,      mode = { 'v', }, silent = true, desc = 'my.box.yank: sel to b', },
  { '<F4>c',     function() M.yank('c', 'n', 'w') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cword> to c', },
  { '<F4><c-c>', function() M.yank('c', 'n', 'W') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cWORD> to c', },
  { '<F4>c',     function() M.yank('c', 'v') end,      mode = { 'v', }, silent = true, desc = 'my.box.yank: sel to c', },
  { '<F4>d',     function() M.yank('d', 'n', 'w') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cword> to d', },
  { '<F4><c-d>', function() M.yank('d', 'n', 'W') end, mode = { 'n', }, silent = true, desc = 'my.box.yank: <cWORD> to d', },
  { '<F4>d',     function() M.yank('d', 'v') end,      mode = { 'v', }, silent = true, desc = 'my.box.yank: sel to d', },
}

function M.replace_two_words(mode)
  if mode == 'n' then
    vim.cmd 'norm viw'
  end
  vim.cmd 'norm "by'
  vim.fn.setreg('b', vim.fn.trim(vim.fn.getreg 'b'))
  B.set_timeout(20, function()
    M.bufnr = vim.fn.bufnr()
    local temp
    temp = vim.fn.getpos "'<"
    _, M.line_1, M.col_1, _ = unpack(temp)
    temp = vim.fn.getpos "'>"
    _, M.line_2, M.col_2, _ = unpack(temp)
  end)
end

function M.replace_two_words_2(mode)
  if mode == 'n' then
    vim.cmd 'norm viw'
  end
  vim.cmd 'norm "vy'
  vim.fn.setreg('v', vim.fn.trim(vim.fn.getreg 'v'))
  B.set_timeout(20, function()
    if vim.fn.bufnr() == M.bufnr then
      M.bufnr_2 = vim.fn.bufnr()
      local temp
      temp = vim.fn.getpos "'<"
      _, M.line_3, M.col_3, _ = unpack(temp)
      temp = vim.fn.getpos "'>"
      _, M.line_4, M.col_4, _ = unpack(temp)
      if M.line_1 > M.line_4 or M.line_1 == M.line_4 and M.col_1 > M.col_4 then
        B.cmd('norm %dgg%d|v%dgg%d|h"vp', M.line_1, M.col_1, M.line_2, M.col_2)
        B.cmd('norm %dgg%d|v%dgg%d|h"bp', M.line_3, M.col_3, M.line_4, M.col_4)
      elseif M.line_3 > M.line_2 or M.line_3 == M.line_2 and M.col_3 > M.col_2 then
        vim.cmd 'norm gv"bp'
        B.cmd('norm %dgg%d|v%dgg%d|h"vp', M.line_1, M.col_1, M.line_2, M.col_2)
      end
    else
      vim.cmd 'norm gv"bp'
      B.cmd('b%d', M.bufnr)
      B.cmd('norm %dgg%d|v%dgg%d|h"vp', M.line_1, M.col_1, M.line_2, M.col_2)
    end
  end)
end

return M
