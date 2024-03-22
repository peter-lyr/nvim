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

vim.api.nvim_create_user_command('TortoiseSVN', function(params)
  M.tortoisesvn(params['fargs'])
end, { nargs = '*', })

function M.map()
  require 'which-key'.register {
    ['<leader>v'] = { name = 'svn', },
    ['<leader>vu'] = { '<cmd>TortoiseSVN update /rev root yes<cr>', 'TortoiseSVN update /rev root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vf'] = { '<cmd>TortoiseSVN diff root yes<cr>', 'TortoiseSVN diff root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>v;'] = { '<cmd>TortoiseSVN log root yes<cr>', 'TortoiseSVN log root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vo'] = { '<cmd>TortoiseSVN settings cur yes<cr>', 'TortoiseSVN settings cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vd'] = { '<cmd>TortoiseSVN diff cur yes<cr>', 'TortoiseSVN diff cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vb'] = { '<cmd>TortoiseSVN blame cur yes<cr>', 'TortoiseSVN blame cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vw'] = { '<cmd>TortoiseSVN repobrowser cur yes<cr>', 'TortoiseSVN repobrowser cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ve'] = { '<cmd>TortoiseSVN repobrowser root yes<cr>', 'TortoiseSVN repobrowser root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vv'] = { '<cmd>TortoiseSVN revert root yes<cr>', 'TortoiseSVN revert root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>va'] = { '<cmd>TortoiseSVN add root yes<cr>', 'TortoiseSVN add root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vc'] = { '<cmd>TortoiseSVN commit root yes<cr>', 'TortoiseSVN commit root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vl'] = { '<cmd>TortoiseSVN log cur yes<cr>', 'TortoiseSVN log cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vk'] = { '<cmd>TortoiseSVN checkout root yes<cr>', 'TortoiseSVN checkout root yes<cr>', mode = { 'n', 'v', }, silent = true, },
  }
end

L(M, M.map)

return M
