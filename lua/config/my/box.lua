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

-- mapping
B.del_map({ 'n', 'v', }, '<leader><c-3>')

require 'which-key'.register { ['<leader><c-3>'] = { name = 'my.box', }, }

B.lazy_map {
  { '<leader><c-3>r',       function() M.restart_nvim_qt() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.box: restart_nvim_qt', },
  { '<leader><c-3>s',       function() M.start_new_nvim_qt() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.box: start_new_nvim_qt', },
  { '<leader><c-3>q',       function() M.quit_nvim_qt() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.box: quit_nvim_qt', },
  { '<leader><c-3><c-s>',   function() M.source() end,              mode = { 'n', 'v', }, silent = true, desc = 'my.box: source', },
  { '<leader><c-3>e',       function() M.type_execute_output() end, mode = { 'n', 'v', }, silent = true, desc = 'my.box: type_execute_output', },
  { '<leader><c-3><c-e>',   function() M.sel_open_temp() end,       mode = { 'n', 'v', }, silent = true, desc = 'my.box: sel_open_temp', },
  { '<leader><c-3><c-w>',   function() M.sel_write_to_temp() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.box: sel_write_to_temp', },
  { '<leader><c-3><c-s-e>', function() M.mes_clear() end,           mode = { 'n', 'v', }, silent = true, desc = 'my.box: mes_clear', },
}

return M
