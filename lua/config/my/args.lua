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

----------------------
-- multiple files
----------------------
M.files = {}

function M._stack_files_from_qflist()
  M.files = {}
  for _, v in ipairs(vim.fn.getqflist()) do
    local file = vim.api.nvim_buf_get_name(v['bufnr'])
    if vim.tbl_contains(M.files, file) == false then
      M.files[#M.files + 1] = file
    end
  end
end

function M._ro_buffer(lines)
  vim.cmd 'new'
  vim.cmd 'set noro'
  vim.cmd 'set ma'
  vim.cmd 'set ft=c'
  vim.fn.setline(1, lines)
  vim.cmd 'diffthis'
  vim.cmd 'set ro'
  vim.cmd 'set noma'
end

function M._ma_buffer(lines)
  vim.cmd 'vnew'
  vim.cmd 'set noro'
  vim.cmd 'set ma'
  vim.fn.setline(1, lines)
  vim.cmd 'set ft=c'
  vim.cmd 'diffthis'
  vim.keymap.set('n', 'dd', '0D')
  vim.cmd 'call feedkeys("zR$")'
end

function M._prepare_buffer()
  M._ro_buffer(M.files)
  M._ma_buffer(M.files)
end

function M.rename_files()
  M._stack_files_from_qflist()
  if #M.files == 0 then
    B.notify_info 'no files in qflist'
    return
  end
  M._prepare_buffer()
end

B.create_user_command_with_M(M, 'Args')

return M
