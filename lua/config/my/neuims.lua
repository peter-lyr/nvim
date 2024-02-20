-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/02/19 21:31:04 Monday

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

local win_ims_exe = B.get_filepath(B.getcreate_dir(M.source .. '.exe'), 'win_ims.exe').filename

B.aucmd({ 'InsertEnter', }, 'my.neuims.InsertEnter', {
  callback = function(ev)
    -- local filetype = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    if buftype == 'prompt' then
      return
    end
    B.system_run('start silent', '%s 1', win_ims_exe)
    -- local info = string.format('%s 1 [%s] %s, %s', win_ims_exe, vim.fn.bufname(ev.buf), filetype, buftype)
    -- B.notify_info_append(info)
  end,
})

B.aucmd({ 'InsertLeave', }, 'my.neuims.InsertLeave', {
  callback = function(ev)
    -- local filetype = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    if buftype == 'prompt' then
      return
    end
    B.system_run('start silent', '%s 0', win_ims_exe)
    -- local info = string.format('%s 0 [%s] %s, %s', win_ims_exe, vim.fn.bufname(ev.buf), filetype, buftype)
    -- B.notify_info_append(info)
  end,
})

return M
