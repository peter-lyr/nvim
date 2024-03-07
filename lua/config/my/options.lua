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
    hi WinBarNC    guibg=#333333 guifg=gray gui=bold
    hi StatusLine  guibg=#daa765 guifg=brown gui=bold
    hi WinSeparator guibg=#daa765 guifg=brown
    hi NvimTreeWinSeparator guibg=#daa765 guifg=brown
    hi DiffviewWinSeparator guibg=#daa765 guifg=brown
  ]]
end

return M
