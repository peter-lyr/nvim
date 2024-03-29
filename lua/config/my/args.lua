local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.operate_files_py = B.getcreate_filepath(M.source .. '.py', 'operate_files.py').filename

----------------------
-- two files
----------------------
M.file1 = ''
M.file2 = ''

function M.stack_file1() M.file1 = B.buf_get_name_0() end

function M.stack_file2() M.file2 = B.buf_get_name_0() end

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
M.copy_or_move = 'move'

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
  local files1 = vim.fn.getbufline(buffers[1], 1, '$')
  local files2 = vim.fn.getbufline(buffers[2], 1, '$')
  if #files1 ~= #files2 then
    B.notify_error(string.format('files number is not equal: %d ~= %d', #files1, #files2))
    return
  end
  if not B.deep_compare(M.files, files1) then
    B.notify_error 'source files changed!'
    return
  end
  local temp = {}
  for _, file2 in ipairs(files2) do
    if vim.tbl_contains(temp, file2) == true then
      B.notify_error('same target detected: ' .. file2)
      return
    else
      local last_char = string.sub(file2, #file2, #file2)
      if vim.tbl_contains({ '/', '\\', }, last_char) == false then
        temp[#temp + 1] = file2
      end
    end
  end
  local temp_args_dir = B.getcreate_temp_dirpath 'args'.filename
  local temp_path = B.getcreate_filepath(temp_args_dir, 'a.txt')
  temp_path:write('', 'w')
  local ok = nil
  for i = 1, #files1 do
    local file1 = files1[i]
    local file2 = files2[i]
    if file1 ~= file2 then
      temp_path:write(string.format('%s->%s\r\n', file1, file2), 'a')
      ok = 1
    end
  end
  if ok then B.system_run('start silent', 'chcp 65001 && %s && python "%s" "%s" "%s"', B.system_cd(vim.loop.cwd()), M.operate_files_py, temp_path.filename, M.copy_or_move) end
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

function M._operate_files_do()
  if #M.files == 0 then
    B.notify_info 'M.files empty'
    return
  end
  local buffers = {
    M._ro_buffer(M.files),
    M._ma_buffer(M.files),
  }
  M._wait_close_buffer(buffers)
end

function M._operate_files()
  M.files = {}
  for _, v in ipairs(require 'nvim-tree.marks'.get_marks()) do
    M.files[#M.files + 1] = v['absolute_path']
  end
  require 'nvim-tree.marks'.clear_marks()
  if #M.files == 0 then
    M._stack_files_from_qflist()
  end
  M._operate_files_do()
end

function M.copy_files()
  M.copy_or_move = 'copy'
  M._operate_files()
end

function M.move_files()
  M.copy_or_move = 'move'
  M._operate_files()
end

return M
