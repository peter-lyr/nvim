-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/09 18:38:25 星期六

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])

M.py_dir = B.getcreate_dir(M.source .. '.py')

M.py_files = require 'plenary.scandir'.scan_dir(M.py_dir, { hidden = true, depth = 64, add_dirs = false, })

function M.cmdline_enter(py_file)
  local head = vim.fn.fnamemodify(py_file, ':h')
  local tail = vim.fn.fnamemodify(py_file, ':t')
  local args = vim.fn.input(string.format('python %s ', tail))
  B.system_run('start', '%s && python %s %s', B.system_cd(head), py_file, args)
end

function M.sel_run_py()
  if #M.py_files == 0 then
    return
  elseif #M.py_files == 1 then
    M.cmdline_enter(M.py_files[1])
  else
    B.ui_sel(M.py_files, 'sel run py', function(py_file)
      M.cmdline_enter(py_file)
    end)
  end
end

return M
