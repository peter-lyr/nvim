-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/01/05 00:25:13 星期五

local M = {}

local B = require 'base'

function M.tortoisesvn(params)
  if not params or #params < 3 then
    return
  end
  local cmd, cmd1, cmd2, root, yes = unpack(params)
  if #params == 3 then
    cmd, root, yes = unpack(params)
  elseif #params == 4 then
    cmd1, cmd2, root, yes = unpack(params)
    cmd = cmd1 .. ' ' .. cmd2
  end
  if not cmd then
    return
  end
  local abspath = (root == 'root') and vim.fn['projectroot#get'](B.buf_get_name_0()) or B.buf_get_name_0()
  if yes == 'yes' or vim.tbl_contains({ 'y', 'Y', }, vim.fn.trim(vim.fn.input('Sure to update? [Y/n]: ', 'Y'))) == true then
    vim.fn.execute(string.format('silent !%s && start tortoiseproc.exe /command:%s /path:\"%s\"',
      B.system_cd(abspath),
      cmd, abspath))
  end
end

return M
