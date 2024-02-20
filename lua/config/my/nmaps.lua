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
  { "<leader>'",           ':lua ',               mode = { 'n', 'v', }, silent = false, desc = 'my.maps: cmdline, lua', },
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
  { '<c-s-i>',             'gT',                  mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: gT', },
  { '<c-s-o>',             'gt',                  mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: gt', },
  { '<c-s-u>',             '<c-tab>',             mode = { 'n', 'v', }, silent = true,  desc = 'my.maps: <c-tab>', },
}

lazy_map {
  { 'q.', function() vim.cmd 'silent !start "" %:p:h' end,               mode = { 'n', 'v', }, silent = true, desc = 'my.maps: explorer %:h', },
  { 'qw', function() vim.cmd('silent !start "" ' .. vim.loop.cwd()) end, mode = { 'n', 'v', }, silent = true, desc = 'my.maps: explorer cwd', },
  { 'qs', function() vim.cmd 'silent !cmd /c start "" %:p' end,          mode = { 'n', 'v', }, silent = true, desc = 'my.maps: start %:h', },
}

vim.cmd [[
cab xpx sort
cab xqc g/^\(.*\)$\n\1$/d
cab xpq sort\|g/^\(.*\)$\n\1$/d
iab tm <c-r>=strftime('%Hh%Mm')<cr>
]]

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
  nnoremenu PopUp.Open\ Cur\ File :silent !cmd /c start "" %:p<cr>
  vnoremenu PopUp.Open\ Cur\ File :<C-U>silent !cmd /c start "" %:p<cr>
  inoremenu PopUp.Open\ Cur\ File <C-O>:<C-u>silent !cmd /c start "" %:p<cr>
]]

-- 只保留第二列数据
-- %s/[^,]\+,\([^,]*\),.*/\=submatch(1)
