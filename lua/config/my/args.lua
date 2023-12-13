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

function M._close_buffer(buffers)
  for _, buffer in ipairs(buffers) do
    vim.fn.timer_start(100, function()
      pcall(vim.cmd, tostring(buffer) .. 'bw!')
    end)
  end
end

function M._get_buffer_files(buffers)
  -- local files1 = vim.fn.getbufline(buffers[1], 1, '$')
  -- local files2 = vim.fn.getbufline(buffers[2], 1, '$')
end

function M._wait_close_buffer(buffers)
  M.auids = {}
  for _, buffer in ipairs(buffers) do
    table.insert(M.auids, vim.api.nvim_create_autocmd({ 'BufHidden', 'BufUnload', 'BufDelete', }, {
      buffer = buffer,
      callback = function()
        for _, auid in ipairs(M.auids) do
          pcall(vim.api.nvim_del_autocmd, auid)
        end
        M._get_buffer_files(buffers)
        M._close_buffer(buffers)
      end,
    }))
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
  return vim.fn.bufnr()
end

function M._ma_buffer(lines)
  vim.cmd 'vnew'
  vim.cmd 'set noro'
  vim.cmd 'set ma'
  vim.fn.setline(1, lines)
  vim.cmd 'set ft=c'
  vim.cmd 'diffthis'
  vim.keymap.set('n', 'dd', '0D', { buffer = vim.fn.bufnr(), })
  vim.cmd 'call feedkeys("zR$")'
  return vim.fn.bufnr()
end

function M._prepare_buffer()
  local buffers = {
    M._ro_buffer(M.files),
    M._ma_buffer(M.files),
  }
  M._wait_close_buffer(buffers)
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
