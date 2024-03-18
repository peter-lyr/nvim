-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/02/19 21:31:04 Monday

local M = {}

local B = require 'base'

function M.change_language(lang)
  vim.g.lang = lang
  vim.g.res = 1
  vim.g.neuims_txt = B.depei .. '\\neuims.txt'
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
  neuims_txt = vim.eval('g:neuims_txt')
  result = win32api.SendMessage(hwnd, WM_INPUTLANGCHANGEREQUEST, 0, language)
  vim.command(f'let g:res = {result}')
  import time
  with open(neuims_txt, 'ab') as f:
    f.write((f"{vim.eval('g:lang')}: {time.time()}\n").encode('utf-8'))
except Exception as e:
  print('change_language - Exception:', e)
EOF
  ]]
  if vim.g.res ~= 0 then
    B.notify_error 'change language error'
  end
  if lang == 'EN' then
    M.lang = 'EN'
  else
    M.lang = 'ZH'
  end
end

M.enable = 1
M.lang = nil

B.aucmd('ModeChanged', 'my.neuims.ModeChanged', {
  callback = function()
    if M.enable then
      B.set_timeout(200, function()
        if B.is_in_tbl(vim.fn.mode(), { 'c', 'i', 't', 'r', 'R', }) then
          M.change_language 'ZH'
        else
          M.change_language 'EN'
        end
      end)
    end
  end,
})

function M.i_enter()
  M.enable = nil
  vim.cmd [[call feedkeys("\<esc>o")]]
  B.set_timeout(100, function() M.enable = 1 end)
end

function M.toggle_lang_in_cmdline()
  if M.lang == 'EN' then
    M.change_language 'ZH'
  else
    M.change_language 'EN'
  end
end

return M
