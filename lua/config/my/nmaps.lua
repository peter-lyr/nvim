local M = {}

local function lazy_map(tbls)
  for _, tbl in ipairs(tbls) do
    local opt = {}
    for k, v in pairs(tbl) do
      if type(k) == 'string' and k ~= 'mode' then
        opt[k] = v
      end
    end
    vim.keymap.set(tbl['mode'], tbl[1], tbl[2], opt)
  end
end

lazy_map {
  -- cmdline
  { '<leader>;',           ':',                   mode = { 'n', 'v', }, silent = false, desc = 'my.maps: cmdline', },
  { '<leader><c-;>',       ':lua ',               mode = { 'n', 'v', }, silent = false, desc = 'my.maps: cmdline, lua', },
  -- record
  { 'q',                   '<cmd>WhichKey q<cr>', mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: <nop>', },
  { 'Q',                   'q',                   mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: q', },
  -- cd
  { 'c.',                  '<cmd>cd %:h<cr>',     mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: cd %:h', },
  { 'cu',                  '<cmd>cd ..<cr>',      mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: cd ..', },
  -- undo
  { 'U',                   '<c-r>',               mode = { 'n', },      silent = true,  desc = 'my.maps: redo', },
  -- scroll horizontally
  { '<S-ScrollWheelDown>', '10zl',                mode = { 'n', 'v', }, silent = false, desc = 'my.maps: scroll right horizontally', },
  { '<S-ScrollWheelUp>',   '10zh',                mode = { 'n', 'v', }, silent = false, desc = 'my.maps: scroll left horizontally', },
  -- e!
  { 'qq',                  '<cmd>e!<cr>',         mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: e!', },
  -- cursor
  { '<c-j>',               '5j',                  mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: 5j', },
  { '<c-k>',               '5k',                  mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: 5k', },
  -- copy_paste
  { '<a-y>',               '"+y',                 mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: "+y', },
  { '<a-d>',               '"+d',                 mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: "+d', },
  { '<a-c>',               '"+c',                 mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: "+c', },
  { '<a-p>',               '"+p',                 mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: "+p', },
  { '<a-s-p>',             '"+P',                 mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: "+P', },
  -- for youdao dict
  { '<c-c>',               '"+y',                 mode = { 'v', },      silent = true,  desc = 'my.maps: "+y', },
  -- tab
  { '<c-f7>',              'gT',                  mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: gT', },
  { '<c-f8>',              'gt',                  mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: gt', },
  { '<c-f6>',              '<c-tab>',             mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: <c-tab>', },
}

lazy_map {
  { 'q.', function() vim.cmd 'silent !start "" "%:p:h"' end,                     mode = { 'n', 'v', }, silent = true, desc = 'my.maps: explorer %:h', },
  { 'qw', function() vim.cmd('silent !start "" "' .. vim.loop.cwd() .. '"') end, mode = { 'n', 'v', }, silent = true, desc = 'my.maps: explorer cwd', },
  { 'qs', function() vim.cmd 'silent !start "" "%:p"' end,                       mode = { 'n', 'v', }, silent = true, desc = 'my.maps: start %:h', },
}

lazy_map {
  { 'qr', function()
    local B = require 'base'
    local telescope = require 'config.nvim.telescope'
    local dir = telescope.cur_root[B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))]
    if dir then
      B.cmd('silent !start "" "%s"', dir)
    end
  end, mode = { 'n', 'v', }, silent = true, desc = 'my.maps: explorer cur_root', },
}

function M.yank(feedkeys)
  local B = require 'base'
  local save_cursor = vim.fn.getcurpos()
  B.cmd('norm %s', feedkeys)
  if B.is_in_str('y', feedkeys) then
    local temp = ''
    vim.fn.setpos('.', save_cursor)
    local head = 'yank to '
    if B.is_in_str('+', feedkeys) then
      temp = vim.fn.getreg '+'
      head = head .. '+'
    else
      temp = vim.fn.getreg '"'
      head = head .. '"'
    end
    B.notify_info_append { head, temp, }
  end
end

lazy_map {
  { 'vw',     function() M.yank 'viw' end,   mode = { 'n', }, silent = true, desc = 'my.maps: viw', },
  { 'v<c-w>', function() M.yank 'viW' end,   mode = { 'n', }, silent = true, desc = 'my.maps: viW', },
  { 'yw',     function() M.yank 'yiw' end,   mode = { 'n', }, silent = true, desc = 'my.maps: yiw', },
  { 'y<c-w>', function() M.yank 'yiW' end,   mode = { 'n', }, silent = true, desc = 'my.maps: yiW', },
  { 'y<a-w>', function() M.yank '"+yiw' end, mode = { 'n', }, silent = true, desc = 'my.maps: "+yiw', },
  { 'yW',     function() M.yank '"+yiW' end, mode = { 'n', }, silent = true, desc = 'my.maps: "+yiW', },
}

vim.cmd [[
  aunmenu PopUp
  vnoremenu PopUp.Cut             "+x
  vnoremenu PopUp.Copy            "+y
  anoremenu PopUp.Paste           "+gP
  vnoremenu PopUp.Paste           "+P
  vnoremenu PopUp.Delete          "_x
  nnoremenu PopUp.Select\ All     ggVG
  vnoremenu PopUp.Select\ All     gg0oG$
  inoremenu PopUp.Select\ All     <C-Home><C-O>VG
  anoremenu PopUp.-1-             <Nop>
  nnoremenu PopUp.Open\ Cur\ File :silent !cmd /c start "" "%:p"<cr>
  vnoremenu PopUp.Open\ Cur\ File :<C-U>silent !cmd /c start "" "%:p"<cr>
  inoremenu PopUp.Open\ Cur\ File <C-O>:<C-u>silent !cmd /c start "" "%:p"<cr>
]]

-- 只保留第二列数据
-- %s/[^,]\+,\([^,]*\),.*/\=submatch(1)
