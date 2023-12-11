local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.cmake_dir = B.getcreate_dir(M.source .. '.py')

M.c2cmake_py = B.get_filepath(M.cmake_dir, 'c2cmake.py').filename
M.cbp2cmake_py = B.get_filepath(M.cmake_dir, 'cbp2cmake.py').filename

function M._get_cbps(file)
  local cbps = {}
  local path = require 'plenary.path':new(file)
  local entries = require 'plenary.scandir'.scan_dir(path.filename, { hidden = false, depth = 18, add_dirs = false, })
  for _, entry in ipairs(entries) do
    local entry_path_name = B.rep_slash_lower(entry)
    if string.match(entry_path_name, '%.([^%.]+)$') == 'cbp' then
      if vim.tbl_contains(cbps, entry_path_name) == false then
        table.insert(cbps, entry_path_name)
      end
    end
  end
  return cbps
end

function M._to_cmake_do(proj)
  local fname = B.rep_backslash_lower(vim.api.nvim_buf_get_name(0))
  proj = B.rep_backslash_lower(proj)
  if #proj == 0 then
    B.notify_info('not in a project: ' .. fname)
    return
  end
  local cbps = M._get_cbps(proj)
  if #cbps < 1 then
    B.notify_info 'c2cmake...'
    B.system_run('start', 'chcp 65001 && %s && python "%s" "%s"', B.system_cd(proj), M.c2cmake_py, proj)
  else
    B.notify_info 'cbp2cmake...'
    B.system_run('start', 'chcp 65001 && %s && python "%s" "%s"', B.system_cd(proj), M.cbp2cmake_py, proj)
  end
end

function M.cmake(cwd)
  if #vim.call 'ProjectRootGet' == 0 then
    B.notify_info 'not in a git repo'
    return
  end
  if cwd then
    M._to_cmake_do(B.rep_slash_lower(vim.call 'ProjectRootGet'))
  else
    B.ui_sel(B.get_file_dirs_till_git(), 'which dir to cmake', function(proj)
      M._to_cmake_do(proj)
    end)
  end
end

B.create_user_command_string_args(B.get_functions_of_M_exclude_(M), M.lua, 'CMake')

return M
