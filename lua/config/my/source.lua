local M = {}

local B = require 'base'

function M.main(file)
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  package.loaded[B.getlua(file)] = nil
  B.cmd('source %s', file)
end

B.create_user_command_with_M(M, 'Source')

return M
