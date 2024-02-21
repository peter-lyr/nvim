-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/02/19 21:31:04 Monday

local M = {}

local B = require 'base'

function M.change_language(lang)
  vim.g.lang = lang
  vim.g.res = 1
  vim.cmd [[
    python << EOF
import win32api
import win32gui
from win32con import WM_INPUTLANGCHANGEREQUEST
LANG = {
  "ZH": 0x0804,
  "EN": 0x0409
}
try:
  hwnd = win32gui.GetForegroundWindow()
  language = LANG[vim.eval('g:lang')]
  result = win32api.SendMessage(hwnd, WM_INPUTLANGCHANGEREQUEST, 0, language)
  vim.command(f'let g:res = {result}')
except Exception as e:
  print('change_language - Exception:', e)
EOF
  ]]
  if vim.g.res ~= 0 then
    B.notify_error 'change language error'
  end
end

B.aucmd({ 'InsertEnter', }, 'my.neuims.InsertEnter', {
  callback = function()
    -- local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    -- if buftype == 'prompt' then
    --   return
    -- end
    M.change_language 'ZH'
  end,
})

B.aucmd({ 'InsertLeave', }, 'my.neuims.InsertLeave', {
  callback = function()
    -- local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    -- if buftype == 'prompt' then
    --   return
    -- end
    M.change_language 'EN'
  end,
})

return M
