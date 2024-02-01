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

function M.start_new_nvim_qt()
  local _restart_nvim_qt_bat_path = B.getcreate_filepath(B.getcreate_stddata_dirpath 'restart_nvim_qt'.filename, 'restart_nvim_qt.bat')
  local rtp = vim.fn.expand(string.match(vim.fn.execute 'set rtp', ',([^,]+)\\share\\nvim\\runtime'))
  _restart_nvim_qt_bat_path:write(string.format([[
@echo off
REM sleep 1
cd %s\bin
start /d %s nvim-qt.exe
exit
]],
    rtp, vim.loop.cwd()), 'w')
  vim.cmd(string.format([[silent !start /b /min %s]], _restart_nvim_qt_bat_path.filename))
end

function M.restart_nvim_qt()
  vim.cmd 'SessionsSave'
  M.start_new_nvim_qt()
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

function M.proxy_on()
  B.system_run('start silent', [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f]])
  B.notify_info 'proxy_on'
end

function M.proxy_off()
  B.system_run('start silent', [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f]])
  B.notify_info 'proxy_off'
end

function M.open_path() B.system_run('start silent', 'start rundll32 sysdm.cpl,EditEnvironmentVariables') end

function M.open_sound() B.system_run('start silent', 'mmsys.cpl') end

function M.sel_open_programs_file()
  local programs_files = B.get_programs_files()
  B.ui_sel(programs_files, 'sel_open_programs_file', function(programs_file)
    if programs_file then
      B.system_open_file_silent(programs_file)
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

function M._filesize()
  local file = vim.fn.expand '%:p'
  if file == nil or #file == 0 then
    return ''
  end
  local size = vim.fn.getfsize(file)
  if size <= 0 then
    return ''
  end
  local suffixes = { 'B', 'K', 'M', 'G', }
  local i = 1
  while size > 1024 and i < #suffixes do
    size = size / 1024
    i = i + 1
  end
  local format = i == 1 and '%d%s' or '%.1f%s'
  return string.format(format, size, suffixes[i])
end

function M.show_info()
  local temp = {
    { 'cwd',          vim.loop.cwd(), },
    { 'fname',        vim.fn.bufname(), },
    { 'mem',          string.format('%dM', vim.loop.resident_set_memory() / 1024 / 1024), },
    { 'fsize',        M._filesize(), },
    { 'datetime',     vim.fn.strftime '%Y-%m-%d %H:%M:%S %A', },
    { 'fileencoding', vim.opt.fileencoding:get(), },
    { 'fileformat',   vim.bo.fileformat, },
    { 'gitbranch',    vim.fn['gitbranch#name'](), },
  }
  local items = {}
  local width = 0
  for _, v in ipairs(temp) do
    if width < #v[1] then
      width = #v[1]
    end
  end
  local str = '# %d. [%' .. width .. 's]: %s'
  for k, v in ipairs(temp) do
    items[#items + 1] = string.format(str, k, unpack(v))
  end
  B.notify_info(vim.fn.join(items, '\n'))
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

-- mapping
B.del_map({ 'n', 'v', }, '<leader><c-3>')

require 'which-key'.register { ['<leader><c-3>'] = { name = 'my.box', }, }

require 'which-key'.register { ['<leader><c-3>o'] = { name = 'my.box.open', }, }
require 'which-key'.register { ['<leader><c-3>m'] = { name = 'my.box.monitor', }, }
require 'which-key'.register { ['<leader><c-3>p'] = { name = 'my.box.proxy', }, }
require 'which-key'.register { ['<leader><c-3>s'] = { name = 'my.box.sel/nvim-qt', }, }
require 'which-key'.register { ['<leader><c-3>g'] = { name = 'my.box.git', }, }

B.lazy_map {
  { '<leader><c-3>sr',        function() M.restart_nvim_qt() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.box.nvim-qt: restart_nvim_qt', },
  { '<leader><c-3>s<leader>', function() M.start_new_nvim_qt() end,      mode = { 'n', 'v', }, silent = true, desc = 'my.box.nvim-qt: start_new_nvim_qt', },
  { '<leader><c-3>sq',        function() M.quit_nvim_qt() end,           mode = { 'n', 'v', }, silent = true, desc = 'my.box.nvim-qt: quit_nvim_qt', },
  { '<leader><c-3><c-s>',     function() M.source() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.box: source', },
  { '<leader><c-3>e',         function() M.type_execute_output() end,    mode = { 'n', 'v', }, silent = true, desc = 'my.box: type_execute_output', },
  { '<leader><c-3><c-e>',     function() M.sel_open_temp() end,          mode = { 'n', 'v', }, silent = true, desc = 'my.box: sel_open_temp', },
  { '<leader><c-3><c-w>',     function() M.sel_write_to_temp() end,      mode = { 'n', 'v', }, silent = true, desc = 'my.box: sel_write_to_temp', },
  { '<leader><c-3><c-s-e>',   function() M.mes_clear() end,              mode = { 'n', 'v', }, silent = true, desc = 'my.box: mes_clear', },
  { '<leader><c-3>op',        function() M.open_path() end,              mode = { 'n', 'v', }, silent = true, desc = 'my.box.open: open_path', },
  { '<leader><c-3>os',        function() M.open_sound() end,             mode = { 'n', 'v', }, silent = true, desc = 'my.box.open: open_sound', },
  { '<leader><c-3>m1',        function() M.monitor_1min() end,           mode = { 'n', 'v', }, silent = true, desc = 'my.box.monitor: monitor_1min', },
  { '<leader><c-3>m3',        function() M.monitor_30min() end,          mode = { 'n', 'v', }, silent = true, desc = 'my.box.monitor: monitor_30min', },
  { '<leader><c-3>po',        function() M.proxy_on() end,               mode = { 'n', 'v', }, silent = true, desc = 'my.box.proxy: proxy_on', },
  { '<leader><c-3>pf',        function() M.proxy_off() end,              mode = { 'n', 'v', }, silent = true, desc = 'my.box.proxy: proxy_off', },
  { '<leader><c-3>sp',        function() M.sel_open_programs_file() end, mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_open_programs_file', },
  { '<leader><c-3>ss',        function() M.sel_open_startup_file() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: sel_open_startup_file', },
  { '<leader><c-3>gm',        function() M.git_init_and_cmake() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: git_init_and_cmake', },
  { '<leader><c-3>qu',        function() M.qfmakeconv2utf8() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: qfmakeconv2utf8', },
  { '<leader><c-3>q9',        function() M.qfmakeconv2cp936() end,       mode = { 'n', 'v', }, silent = true, desc = 'my.box.sel: qfmakeconv2cp936', },
}

return M
