local M = {}

local B = require 'base'

M.lua = B.getlua(debug.getinfo(1)['source'])

----------------------
-- two files
----------------------
M.file1 = ''
M.file2 = ''

function M.stack_file1() M.file1 = vim.api.nvim_buf_get_name(0) end

function M.stack_file2() M.file2 = vim.api.nvim_buf_get_name(0) end

function M.start_bcomp_cur()
  M.stack_file2()
  if #M.file1 > 0 then
    B.system_run('start silent', 'bcomp "%s" "%s"', M.file1, M.file2)
  else
    B.notify_info 'Please stack_file1 first.'
  end
end

function M.start_bcomp_last()
  if #M.file1 == 0 then
    B.notify_info 'Please stack_file1 first.'
    return
  end
  if #M.file2 == 0 then
    B.notify_info 'Please stack_file2 first.'
    return
  end
  B.system_run('start silent', 'bcomp "%s" "%s"', M.file1, M.file2)
end

B.create_user_command_with_M(M, 'Args')

return M
