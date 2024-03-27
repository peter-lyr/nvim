local M = {}

local B = require 'base'

vim.cmd 'Lazy load vim-gitbranch'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

function M.source_file(file)
  if not file then file = B.buf_get_name_0() end
  package.loaded[B.getlua(B.rep_backslash(file))] = nil
  B.print('source %s', file)
  B.cmd('source %s', file)
end

M.nvim_qt_start_flag_socket_txt = vim.fn.expand [[$HOME]] .. '\\DEPEI\\nvim_qt_start_flag_socket.txt'

function M.restart_new_nvim_qt(sessionsload)
  if sessionsload then
    vim.fn.writefile({ '1', }, M.nvim_qt_start_flag_socket_txt)
  else
    vim.fn.writefile({ '3', }, M.nvim_qt_start_flag_socket_txt)
  end
  local _restart_nvim_qt_py_path = B.getcreate_filepath(B.getcreate_stddata_dirpath 'restart_nvim_qt'.filename, 'restart_nvim_qt.py')
  local rtp = vim.fn.expand(string.match(vim.fn.execute 'set rtp', ',([^,]+)\\share\\nvim\\runtime'))
  _restart_nvim_qt_py_path:write(string.format([[
import os
import time
try:
  import psutil
except:
  os.system("pip install psutil -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host mirrors.aliyun.com")
  import psutil
start = time.time()
while 1:
  # if `require 'base'.get_nvim_qt_exe_pid()` not in psutil.pids():
  #   break
  with open(r'%s', 'rb') as f:
    if f.read().strip() in [b'2', b'4']:
      break
  if time.time() - start > 2:
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

function M.start_new_nvim_qt_cfile()
  vim.fn.writefile({ B.buf_get_name_0(), }, M.nvim_qt_start_flag_socket_txt)
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

function M.restart_nvim_qt(sessionsload)
  vim.cmd 'SessionsSave'
  M.restart_new_nvim_qt(sessionsload)
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

function M.type_execute_output()
  vim.ui.input({ prompt = 'type command, execute output to and open file: ', default = 'mes', completion = 'command', }, function(input)
    if B.is(input) then
      M.execute_output(input)
    end
  end)
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
    B.jump_or_split(file)
  end
end

function M.prepare_sessions()
  if '1' == vim.fn.trim(vim.fn.join(vim.fn.readfile(M.nvim_qt_start_flag_socket_txt), '')) then
    vim.fn.writefile({ '2', }, M.nvim_qt_start_flag_socket_txt)
  elseif '3' == vim.fn.trim(vim.fn.join(vim.fn.readfile(M.nvim_qt_start_flag_socket_txt), '')) then
    vim.fn.writefile({ '4', }, M.nvim_qt_start_flag_socket_txt)
  end
end

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
        B.cmd('norm %dgg%d|v%dgg%d|"vp', M.line_1, M.col_1, M.line_2, M.col_2)
        B.cmd('norm %dgg%d|v%dgg%d|"bp', M.line_3, M.col_3, M.line_4, M.col_4)
      elseif M.line_3 > M.line_2 or M.line_3 == M.line_2 and M.col_3 > M.col_2 then
        vim.cmd 'norm gv"bp'
        B.cmd('norm %dgg%d|v%dgg%d|"vp', M.line_1, M.col_1, M.line_2, M.col_2)
      end
    else
      vim.cmd 'norm gv"bp'
      B.cmd('b%d', M.bufnr)
      B.cmd('norm %dgg%d|v%dgg%d|"vp', M.line_1, M.col_1, M.line_2, M.col_2)
    end
  end)
end

function M.map()
  require 'which-key'.register {
    ['<leader>a'] = { name = 'my.box', },
  }
  require 'which-key'.register {
    ['<F2>'] = { function() M.replace_two_words 'v' end, 'switch two words prepare', mode = { 'v', }, silent = true, },
    ['<F3>'] = { function() M.replace_two_words_2 'v' end, 'switch two words do', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F2>'] = { function() M.replace_two_words 'n' end, 'switch two words prepare', mode = { 'n', }, silent = true, },
    ['<F3>'] = { function() M.replace_two_words_2 'n' end, 'switch two words do', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>as'] = { name = 'nvim-qt/programs', },
    ['<leader>as;'] = { function() M.start_new_nvim_qt_cfile() end, 'start new nvim-qt and open <cfile>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>as<c-p>'] = { function() M.sel_open_programs_file_force() end, 'sel open programs file force', mode = { 'n', 'v', }, silent = true, },
    ['<leader>as<c-k>'] = { function() M.sel_kill_programs_file_force() end, 'sel kill programs file force', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ass'] = { function() M.sel_open_startup_file() end, 'sel open startup file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aa'] = { function() M.source_file() end, 'source file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ax'] = { function() M.type_execute_output() end, 'execute output to and open file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ac'] = { function() M.mes_clear() end, 'mes clear', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>ao'] = { name = 'open', },
    ['<leader>aop'] = { function() M.open_path() end, 'open path', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aos'] = { function() M.open_sound() end, 'open sound', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aof'] = { function() M.open_file() end, 'open file in clipboard', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>am'] = { name = 'monitor', },
    ['<leader>am1'] = { function() M.monitor_1min() end, 'monitor 1 min', mode = { 'n', 'v', }, silent = true, },
    ['<leader>am3'] = { function() M.monitor_30min() end, 'monitor 30 min', mode = { 'n', 'v', }, silent = true, },
    ['<leader>am5'] = { function() M.monitor_5hours() end, 'monitor 5 hours', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>ap'] = { name = 'prx', },
    ['<leader>apo'] = { function() M.proxy_on() end, 'prx on', mode = { 'n', 'v', }, silent = true, },
    ['<leader>apf'] = { function() M.proxy_off() end, 'prx off', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>ag'] = { name = 'git', },
    ['<leader>agm'] = { function() M.git_init_and_cmake() end, 'git init and cmake', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>aq'] = { name = 'qf make conv', },
    ['<leader>aq8'] = { function() M.qfmakeconv2utf8() end, 'qf makeconv 2 utf8', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aq9'] = { function() M.qfmakeconv2cp936() end, 'qf makeconv 2 cp936', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>asr'] = { function() M.restart_nvim_qt(1) end, 'restart nvim-qt and sessionsload', mode = { 'n', 'v', }, silent = true, },
    ['<leader>as<c-r>'] = { function() M.restart_nvim_qt() end, 'restart nvim-qt', mode = { 'n', 'v', }, silent = true, },
    ['<leader>as<leader>'] = { function() M.start_new_nvim_qt() end, 'start new nvim-qt', mode = { 'n', 'v', }, silent = true, },
    ['<leader>asq'] = { function() M.quit_nvim_qt() end, 'quit nvim-qt', mode = { 'n', 'v', }, silent = true, },
    ['<leader>asp'] = { function() M.sel_open_programs_file() end, 'sel open programs file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ask'] = { function() M.sel_kill_programs_file() end, 'sel kill programs file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ae'] = { function() M.sel_open_temp() end, 'sel open temp file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aw'] = { function() M.sel_write_to_temp() end, 'sel write to temp file', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F1>'] = { function() M.show_info() end, 'show info', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ash'] = { function()
      M.show_info()
      require 'which-key'.register {
        ['<F1>'] = { function() M.show_info() end, 'show info', mode = { 'n', 'v', }, silent = true, },
      }
    end, 'show info', mode = { 'n', 'v', }, silent = true, },
  }
end

L(M, M.map)

return M
