local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

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
  vim.cmd 'wqall'
end

function M.quit_nvim_qt()
  vim.cmd 'wqall'
end

-- mapping
B.del_map({ 'n', 'v', }, '<leader><c-t>')

require 'which-key'.register { ['<leader><c-t>'] = { name = 'my.test', }, }

B.lazy_map {
  { '<leader><c-t>r', function() require 'config.my.test'.restart_nvim_qt() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.test: restart_nvim_qt', },
  { '<leader><c-t>s', function() require 'config.my.test'.start_new_nvim_qt() end, mode = { 'n', 'v', }, silent = true, desc = 'my.test: start_new_nvim_qt', },
  { '<leader><c-t>q', function() require 'config.my.test'.quit_nvim_qt() end,      mode = { 'n', 'v', }, silent = true, desc = 'my.test: quit_nvim_qt', },
}

return M
