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
  local abspath = (root == 'root') and vim.fn['projectroot#get'](vim.api.nvim_buf_get_name(0)) or vim.api.nvim_buf_get_name(0)
  if yes == 'yes' or vim.tbl_contains({ 'y', 'Y', }, vim.fn.trim(vim.fn.input('Sure to update? [Y/n]: ', 'Y'))) == true then
    vim.fn.execute(string.format('silent !%s && start tortoiseproc.exe /command:%s /path:\"%s\"',
      B.system_cd(abspath),
      cmd, abspath))
  end
end

vim.api.nvim_create_user_command('TortoiseSVN', function(params)
  M.tortoisesvn(params['fargs'])
end, { nargs = '*', })

-- mapping
B.del_map({ 'n', 'v', }, '<leader>v')

require 'base'.whichkey_register({ 'n', 'v', }, '<leader>v', 'my.svn')

B.lazy_map {
  { '<leader>vo', '<cmd>TortoiseSVN settings cur yes<cr>',     mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN settings cur yes<cr>', },
  { '<leader>vd', '<cmd>TortoiseSVN diff cur yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN diff cur yes<cr>', },
  { '<leader>vf', '<cmd>TortoiseSVN diff root yes<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN diff root yes<cr>', },
  { '<leader>vb', '<cmd>TortoiseSVN blame cur yes<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN blame cur yes<cr>', },
  { '<leader>vw', '<cmd>TortoiseSVN repobrowser cur yes<cr>',  mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repobrowser cur yes<cr>', },
  { '<leader>ve', '<cmd>TortoiseSVN repobrowser root yes<cr>', mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repobrowser root yes<cr>', },
  { '<leader>vv', '<cmd>TortoiseSVN revert root yes<cr>',      mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN revert root yes<cr>', },
  { '<leader>va', '<cmd>TortoiseSVN add root yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN add root yes<cr>', },
  { '<leader>vc', '<cmd>TortoiseSVN commit root yes<cr>',      mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN commit root yes<cr>', },
  { '<leader>vu', '<cmd>TortoiseSVN update /rev root yes<cr>', mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN update /rev root yes<cr>', },
  { '<leader>vl', '<cmd>TortoiseSVN log cur yes<cr>',          mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN log cur yes<cr>', },
  { '<leader>v;', '<cmd>TortoiseSVN log root yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN log root yes<cr>', },
  { '<leader>vk', '<cmd>TortoiseSVN checkout root yes<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN checkout root yes<cr>', },
}

return M
