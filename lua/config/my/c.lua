local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

--------------------------------------------
-- make
--------------------------------------------

-- make
M.cores = 1
M.remake_en = nil
M.runnow_en = nil

local f = io.popen 'wmic cpu get NumberOfCores'
if f then
  for dir in string.gmatch(f:read '*a', '([%S ]+)') do
    local NumberOfCores = vim.fn.str2nr(vim.fn.trim(dir))
    if NumberOfCores > 0 then
      M.cores = NumberOfCores
    end
  end
  f:close()
end

function M._cmake_exe(dir)
  local CMakeLists = require 'plenary.path':new(dir):joinpath 'CMakeLists.txt'.filename
  local c = io.open(CMakeLists)
  if c then
    local res = c:read '*a'
    local exe = string.match(res, 'set%(PROJECT_NAME ([^%)]+)%)')
    if exe then
      return exe
    end
    c:close()
  end
  return nil
end

function M._make_do(runway, build_dir)
  if #B.scan_files(build_dir) > 0 then
    local pause = ''
    if runway == 'start' then
      pause = '& pause'
    end
    local run = ''
    if M.runnow_en then
      local exe_name = M._cmake_exe(vim.fn.fnamemodify(build_dir, ':h'))
      if exe_name then
        exe_name = exe_name .. '.exe'
        run = '& ' .. string.format(
          [[cd %s && copy /y %s ..\%s && cd .. && strip -s %s & upx -qq --best %s & echo ==============RUN============== & %s]],
          build_dir, exe_name, exe_name, exe_name, exe_name, exe_name)
      end
    end
    if M.remake_en then
      B.notify_info 'remake...'
      B.system_run(runway, [[cd %s && mingw32-make -B -j%d %s %s]], build_dir, M.cores, run, pause)
    else
      B.notify_info 'make...'
      B.system_run(runway, [[cd %s && mingw32-make -j%d %s %s]], build_dir, M.cores, run, pause)
    end
  else
    B.notify_info 'build dir is empty, cmake...'
    require 'config.my.cmake'.cmake()
  end
  M.remake_en = nil
  M.runnow_en = nil
end

function M._make(runway)
  if #vim.call 'ProjectRootGet' == 0 then
    B.notify_info 'not in a git repo'
    return
  end
  if not runway then
    runway = 'asyncrun'
  end
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    M._make_do(runway, build_dirs[1])
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      M._make_do(runway, build_dir)
    end)
  else
    B.notify_info 'no build dirs, cmake...'
    require 'config.my.cmake'.cmake()
  end
end

function M.asyncrun_remake()
  M.remake_en = 1
  M._make 'asyncrun'
end

function M.start_remake()
  M.remake_en = 1
  M._make 'start'
end

function M.asyncrun_make_run()
  M.runnow_en = 1
  M._make 'asyncrun'
end

function M.start_make_run()
  M.runnow_en = 1
  M._make 'start'
end

function M.asyncrun_remake_run()
  M.remake_en = 1
  M.runnow_en = 1
  M._make 'asyncrun'
end

function M.start_remake_run()
  M.remake_en = 1
  M.runnow_en = 1
  M._make 'start'
end

-- clean

M.delete_all = 'delete all above'
M.deleting = 'deleting build dir'

function M._clean_do(build_dir)
  if #B.scan_files(build_dir) > 0 then
    B.del_dir(build_dir)
    B.notify_info { M.deleting, build_dir, }
  else
    B.notify_info { 'build dir is empty', build_dir, }
  end
end

function M.clean()
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    M._clean_do(build_dirs[1])
  elseif #build_dirs > 1 then
    table.insert(build_dirs, 1, M.delete_all)
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      if build_dir == M.delete_all then
        for _, dir in ipairs(build_dirs) do
          B.del_dir(dir)
        end
        table.insert(build_dirs, 1, M.deleting)
        B.notify_info(build_dirs)
      else
        M._clean_do(build_dir)
      end
    end)
  else
    B.notify_info 'no build dirs, clean stopping...'
  end
end

-- run

function M._get_exes(dir)
  local exes = {}
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = false, depth = 32, add_dirs = false, })
  for _, entry in ipairs(entries) do
    local file = B.rep_backslash_lower(entry)
    if string.match(file, 'build/[^/]+%.([^%.]+)$') == 'exe' then
      if vim.tbl_contains(exes, file) == false then
        exes[#exes + 1] = file
      end
    end
  end
  return exes
end

function M._copy_exe_outside_build_dir_and_run(runway, build_dir, exe_name)
  B.system_run(runway,
    [[cd %s && copy /y %s ..\%s && cd .. && strip -s %s & upx -qq --best %s & echo ==============RUN============== & %s & pause]],
    build_dir, exe_name, exe_name, exe_name, exe_name, exe_name
  )
end

function M._run_do(build_dir, runway)
  if not runway then
    runway = 'asyncrun'
  end
  local exes = M._get_exes(build_dir)
  if #exes == 1 then
    M._copy_exe_outside_build_dir_and_run(runway, build_dir, B.get_only_name(exes[1]))
  elseif #exes > 1 then
    B.ui_sel(exes, 'run which exe', function(exe)
      M._copy_exe_outside_build_dir_and_run(runway, build_dir, B.get_only_name(exe))
    end)
  end
end

function M._run(runway)
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    B.notify_info 'make running...'
    M._run_do(build_dirs[1], runway)
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in which build dir', function(build_dir)
      if build_dir then
        B.notify_info 'make running...'
        M._run_do(build_dir, runway)
      else
        B.notify_info 'not build dirs, not running...'
      end
    end)
  else
    B.notify_info 'not build dirs, not running...'
  end
end

function M.asyncrun_run()
  M._run 'asyncrun'
end

function M.start_run()
  M._run 'start'
end

function M._gcc_do(run_way, cur_file, fname, exe_name)
  B.system_run(run_way,
    [[%s && gcc %s -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O2 -o %s & strip -s %s & upx -qq --best %s & %s & pause]],
    B.system_cd(cur_file), fname, exe_name, exe_name, exe_name, exe_name)
end

function M.gcc_start()
  local cur_file = B.rep_slash_lower(vim.api.nvim_buf_get_name(0))
  local fname = B.get_only_name(cur_file)
  local exe = string.sub(fname, 1, #fname - 2) .. '.exe'
  local exe_name = B.get_only_name(exe)
  M._gcc_do('start', cur_file, fname, exe_name)
end

function M.gcc_start_silent()
  local cur_file = B.rep_slash_lower(vim.api.nvim_buf_get_name(0))
  local fname = B.get_only_name(cur_file)
  local exe = string.sub(fname, 1, #fname - 2) .. '.exe'
  local exe_name = B.get_only_name(exe)
  M._gcc_do('start silent', cur_file, fname, exe_name)
end

function M.gcc_asyncrun()
  local cur_file = B.rep_slash_lower(vim.api.nvim_buf_get_name(0))
  local fname = B.get_only_name(cur_file)
  local exe = string.sub(fname, 1, #fname - 2) .. '.exe'
  local exe_name = B.get_only_name(exe)
  M._gcc_do('asyncrun', cur_file, fname, exe_name)
end

-- please add to PATH:
-- INCLUDE: mingw64\x86_64-w64-mingw32\include

--------------------------------------------
-- cmake
--------------------------------------------

M.cmake_dir = B.getcreate_dir(M.source .. '.py')
M.clang_format_dir = B.getcreate_dir(M.source .. '.clang-format')

M.c2cmake_py = B.get_filepath(M.cmake_dir, 'c2cmake.py').filename
M.cbp2cmake_py = B.get_filepath(M.cmake_dir, 'cbp2cmake.py').filename
M._clang_format = B.get_filepath(M.clang_format_dir, '.clang-format').filename

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
  proj = B.rep_backslash_lower(proj)
  if #proj == 0 then
    B.notify_info('not in a project: ' .. B.rep_backslash_lower(vim.api.nvim_buf_get_name(0)))
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
  B.system_run('start silent', 'copy /y "%s" "%s"', B.rep_slash(M._clang_format), B.rep_slash(require 'plenary.path':new(proj):joinpath '.clang-format'.filename))
end

function M.cmake()
  if #vim.call 'ProjectRootGet' == 0 then
    B.notify_info 'cmake: not in a git repo'
    return
  end
  B.ui_sel(B.get_file_dirs_till_git(), 'which dir to cmake', function(proj)
    if proj then
      M._to_cmake_do(proj)
    end
  end)
end

B.create_user_command_with_M(M, 'C')

return M
