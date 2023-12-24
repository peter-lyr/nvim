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

-- mapping
B.del_map({ 'n', 'v', }, '<leader><c-3>')

require 'which-key'.register { ['<leader><c-3>'] = { name = 'my.box', }, }

B.lazy_map {
  { '<leader><c-3>r',     function() M.restart_nvim_qt() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.box: restart_nvim_qt', },
  { '<leader><c-3>s',     function() M.start_new_nvim_qt() end, mode = { 'n', 'v', }, silent = true, desc = 'my.box: start_new_nvim_qt', },
  { '<leader><c-3>q',     function() M.quit_nvim_qt() end,      mode = { 'n', 'v', }, silent = true, desc = 'my.box: quit_nvim_qt', },
  { '<leader><c-3><c-s>', function() M.source() end,            mode = { 'n', 'v', }, silent = true, desc = 'my.box: source', },
}

vim.cmd [[
  aunmenu PopUp
  vnoremenu PopUp.Cut                         "+x
  vnoremenu PopUp.Copy                        "+y
  anoremenu PopUp.Paste                       "+gP
  vnoremenu PopUp.Paste                       "+P
  vnoremenu PopUp.Delete                      "_x
  nnoremenu PopUp.Select\ All                 ggVG
  vnoremenu PopUp.Select\ All                 gg0oG$
  inoremenu PopUp.Select\ All                 <C-Home><C-O>VG
  nnoremenu PopUp.Run\ Cur\ File              :silent !start %:p<cr>
  vnoremenu PopUp.Run\ Cur\ File              :<C-U>silent !start %:p<cr>
  inoremenu PopUp.Run\ Cur\ File              <C-O>:<C-u>silent !start %:p<cr>
]]

return M
