-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/09 18:38:25 星期六

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.py_dir = B.getcreate_dir(M.source .. '.py')
M.py_files = require 'plenary.scandir'.scan_dir(M.py_dir, { hidden = true, depth = 64, add_dirs = false, })

function M._cmdline_enter(py_file)
  local head = vim.fn.fnamemodify(py_file, ':h')
  local tail = vim.fn.fnamemodify(py_file, ':t')
  local args = vim.fn.input(string.format('python %s ', tail))
  B.histadd_en = 1
  B.system_run('asyncrun', '%s && python %s %s', B.system_cd(head), tail, args)
end

function M.sel_run_py()
  if #M.py_files == 0 then
    return
  elseif #M.py_files == 1 then
    M._cmdline_enter(M.py_files[1])
  else
    B.ui_sel(M.py_files, 'sel run py', function(py_file)
      M._cmdline_enter(py_file)
    end)
  end
end

function M.map()
  require 'which-key'.register {
    ['<leader>r'] = { name = 'Run Py/Find & Replace', },
    ['<leader>rp'] = { function() M.sel_run_py() end, 'Run Py(sel)', mode = { 'n', 'v', }, silent = true, },
  }
end

L(M, M.map)

return M
