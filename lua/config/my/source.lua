local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

function M.main(file)
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  local lua = B.getlua(file)
  package.loaded[lua] = nil
  B.cmd('source %s', file)
end

B.create_user_command_with_M(M, 'Source')

return M
