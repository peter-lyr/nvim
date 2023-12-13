local M = {}

local B = require 'base'

M.lua = B.getlua(debug.getinfo(1)['source'])

M.args = {
  ['1'] = '',
  ['2'] = '',
}

function M.put_1_cur_file(file)
  if not file then
    M.args['1'] = vim.api.nvim_buf_get_name(0)
  end
end

function M.put_2_cur_file(file)
  if not file then
    M.args['2'] = vim.api.nvim_buf_get_name(0)
  end
end

function M.print_args()
  local info = ''
  for k, v in pairs(M.args) do
    info = info .. string.format('%d: %s\n', k, v)
  end
  B.notify_info(info)
end

function M.start_bcomp_cur()
  M.put_2_cur_file()
  if #M.args['1'] > 0 then
    B.system_run('start silent', 'bcomp "%s" "%s"', M.args['1'], M.args['2'])
  else
    B.notify_info 'Please put_1_cur_file first.'
  end
end

function M.start_bcomp_last()
  if #M.args['1'] == 0 then
    B.notify_info 'Please put_1_cur_file first.'
    return
  end
  if #M.args['2'] == 0 then
    B.notify_info 'Please put_2_cur_file first.'
    return
  end
  B.system_run('start silent', 'bcomp "%s" "%s"', M.args['1'], M.args['2'])
end

B.create_user_command_with_M(M, 'Args')

return M
