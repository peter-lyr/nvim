-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 20:10:17 星期六

local M = {}

local start_time = vim.fn.reltime()

local r = require 'which-key'.register

function M.all_commands()
  local B = require 'base'
  if #B.commands == 0 then
    B.create_user_command_with_M {
      ['Drag'] = require 'config.my.drag',
      ['Args'] = require 'config.my.args',
      ['Py'] = require 'config.my.py',
      ['C'] = require 'config.my.c',
      ['Gui'] = require 'config.my.gui',
    }
  end
  B.all_commands()
end

r {
  ['<c-;>'] = { M.all_commands, 'base: all commands', mode = { 'n', 'v', }, silent = true, },
}

local end_time = vim.fn.reltimefloat(vim.fn.reltime(start_time))
local startup_time = string.format('maps time: %.3f ms', end_time * 1000)
print(startup_time)

return M
