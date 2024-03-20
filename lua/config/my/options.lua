-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/05 09:05:51 Tuesday

local M = {}

function HL()
  vim.cmd [[
    "hi CursorLine   guifg=NONE guibg=#64704a
    "hi CursorColumn guifg=NONE guibg=#64704a
    hi Comment      guifg=#6c7086 gui=NONE
    hi @comment     guifg=#6c7086 gui=NONE
    hi @lsp.type.comment guifg=#6c7086  gui=NONE
    hi TabLine     guibg=NONE guifg=#a4a4a4
    hi TabLineSel  guibg=NONE guifg=#a4a4a4
    hi TabLineFill guibg=NONE guifg=#a4a4a4
    hi WinBar      guibg=#442288 guifg=yellow gui=bold
    hi WinBarNC    guibg=#1a1a1a guifg=#999999 gui=bold
    hi StatusLine  guibg=#333333 guifg=brown gui=bold
    hi WinSeparator guibg=#333333 guifg=brown
    hi NvimTreeWinSeparator guibg=#333333 guifg=brown
    hi DiffviewWinSeparator guibg=#333333 guifg=brown
  ]]
end

function Notify(message, timeout)
  vim.cmd 'Lazy load nvim-notify'
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'info', {
    title = title,
    animate = false,
    timeout = timeout * 40,
  })
end

function TimingBegin()
  StartTime = vim.fn.reltime()
end

function TimingEnd(name)
  local end_time = vim.fn.reltimefloat(vim.fn.reltime(StartTime))
  Notify(string.format('%s: %.3f ms', name, end_time * 1000), end_time * 1000)
end

function BaseCommand()
  return {
    ['Drag'] = require 'config.my.drag',
    ['Args'] = require 'config.my.args',
    ['Py'] = require 'config.my.py',
    ['C'] = require 'config.my.c',
    ['Gui'] = require 'config.my.gui',
  }
end

return M
