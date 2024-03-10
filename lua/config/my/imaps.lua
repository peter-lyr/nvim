local M = {}

local B = require 'base'

B.lazy_map {
  { 'xxt',  function() return vim.fn.strftime '%H%M%S-' end,        mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: xxt', },
  { 'xxd',  function() return vim.fn.strftime '%y%m%d-' end,        mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: xxd', },
  { 'xxa',  function() return vim.fn.strftime '%y%m%d-%Hh%Mm-' end, mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: xxa', },
  { 'xxt',  function() return vim.fn.strftime '%H%M%S' end,         mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: xxt', },
  { 'xxd',  function() return vim.fn.strftime '%y%m%d' end,         mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: xxd', },
  { 'xxa',  function() return vim.fn.strftime '%y%m%d-%Hh%Mm' end,  mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: xxa', },
  { 'xxpx', function() return 'sort' end,                           mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: xxpx', },
  { 'xxqc', function() return [[g/^\(.*\)$\n\1$/d]] end,            mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: xxqc', },
  { 'xxpq', function() return [[sort\|g/^\(.*\)$\n\1$/d]] end,      mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: xxpq', },
}

B.lazy_map {
  { '<c-/>', '-', mode = { 'c', }, silent = false, desc = 'test.nvim: <c-/> to -', },
}

vim.fn.setreg('e', 'reg e empty')
vim.fn.setreg('4', 'reg 4 empty')

vim.g.single_quote = ''  -- ''
vim.g.double_quote = ''  -- ""
vim.g.back_quote = ''    -- ``
vim.g.parentheses = ''   -- ()
vim.g.bracket = ''       -- []
vim.g.brace = ''         -- {}
vim.g.angle_bracket = '' -- <>
vim.g.curline = ''

function M.setreg()
  local bak = vim.fn.getreg '"'
  local save_cursor = vim.fn.getpos '.'
  local line = vim.fn.trim(vim.fn.getline '.')
  vim.g.curline = line
  if string.match(line, [[%']]) then
    vim.cmd "silent norm yi'"
    vim.g.single_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%"]]) then
    vim.cmd 'silent norm yi"'
    vim.g.double_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%`]]) then
    vim.cmd 'silent norm yi`'
    vim.g.back_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%)]]) then
    vim.cmd 'silent norm yi)'
    vim.g.parentheses = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, '%]') then
    vim.cmd 'silent norm yi]'
    vim.g.bracket = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%}]]) then
    vim.cmd 'silent norm yi}'
    vim.g.brace = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%>]]) then
    vim.cmd 'silent norm yi>'
    vim.g.angle_bracket = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  vim.fn.setreg('"', bak)
end

B.aucmd({ 'BufLeave', 'CmdlineEnter', }, 'my.insertenter: CmdlineEnter', {
  callback = function()
    local word = vim.fn.expand '<cword>'
    if #word > 0 then vim.fn.setreg('e', word) end
    local Word = vim.fn.expand '<cWORD>'
    if #Word > 0 then vim.fn.setreg('4', Word) end
    if vim.g.telescope_entered or B.is_buf_fts { 'NvimTree', 'TelescopePrompt', 'DiffviewFileHistory', } then return end
    M.setreg()
  end,
})

B.lazy_map {
  -- reg
  { '<c-e>',   '<c-r>e',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste <cword>', },
  { '<c-4>',   '<c-r>4',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste <cWORD>', },

  { '<c-t>',   '<c-r>=expand("%:t")<cr>',              mode = { 'c', 'i', },      desc = 'my.insertenter: paste %:t', },
  { '<c-b>',   '<c-r>=bufname()<cr>',                  mode = { 'c', 'i', },      desc = 'my.insertenter: paste bufname()', },
  { '<c-g>',   '<c-r>=nvim_buf_get_name(0)<cr>',       mode = { 'c', 'i', },      desc = 'my.insertenter: paste nvim_buf_get_name', },
  { '<c-d>',   '<c-r>=getcwd()<cr>',                   mode = { 'c', 'i', },      desc = 'my.insertenter: paste cwd', },

  { '<c-l>',   '<c-r>=g:curline<cr>',                  mode = { 'c', 'i', },      desc = 'my.insertenter: paste cur line', },
  { "<c-'>",   '<c-r>=g:single_quote<cr>',             mode = { 'c', 't', },      desc = "my.insertenter: paste in ''", },
  { "<c-s-'>", '<c-r>=g:double_quote<cr>',             mode = { 'c', 't', },      desc = 'my.insertenter: paste in ""', },
  { '<c-0>',   '<c-r>=g:parentheses<cr>',              mode = { 'c', 't', },      desc = 'my.insertenter: paste in ()', },
  { '<c-]>',   '<c-r>=g:bracket<cr>',                  mode = { 'c', 't', },      desc = 'my.insertenter: paste in []', },
  { '<c-s-]>', '<c-r>=g:brace<cr>',                    mode = { 'c', 't', },      desc = 'my.insertenter: paste in {}', },
  { '<c-`>',   '<c-r>=g:back_quote<cr>',               mode = { 'c', 't', },      desc = 'my.insertenter: paste in ``', },
  { '<c-s-.>', '<c-r>=g:angle_bracket<cr>',            mode = { 'c', 't', },      desc = 'my.insertenter: paste in <>', },

  { '<c-s>',   '<c-r>"',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste "', },
  { '<c-s>',   '<c-\\><c-n>pi',                        mode = { 't', },           desc = 'my.insertenter: paste "', },

  { '<c-v>',   '<c-r>+',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste +', },
  { '<c-v>',   '<c-\\><c-n>"+pi',                      mode = { 't', },           desc = 'my.insertenter: paste +', },

  -- cursor
  { 'k',       "(v:count == 0 && &wrap) ? 'gk' : 'k'", mode = { 'n', 'v', },      desc = 'my.insertenter: k',                       silent = true, expr = true, },
  { 'j',       "(v:count == 0 && &wrap) ? 'gj' : 'j'", mode = { 'n', 'v', },      desc = 'my.insertenter: j',                       silent = true, expr = true, },

  { '<a-k>',   '<UP>',                                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: up', },
  { '<a-j>',   '<DOWN>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: down', },

  { '<a-s-k>', '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up', },
  { '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down', },
  { '<c-k>',   '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up', },
  { '<c-j>',   '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down', },
  { '<c-s-k>', '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up', },
  { '<c-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down', },

  { '<a-i>',   '<HOME>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: home', },
  { '<a-s-i>', '<HOME>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: home', },
  { '<a-o>',   '<END>',                                mode = { 't', 'c', 'i', }, desc = 'my.insertenter: end', },
  { '<a-s-o>', '<END>',                                mode = { 't', 'c', 'i', }, desc = 'my.insertenter: end', },

  { '<a-l>',   '<RIGHT>',                              mode = { 't', 'c', 'i', }, desc = 'my.insertenter: right', },
  { '<a-h>',   '<LEFT>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: left', },
  { '<a-s-l>', '<c-RIGHT>',                            mode = { 't', 'c', 'i', }, desc = 'my.insertenter: ctrl right', },
  { '<a-s-h>', '<c-LEFT>',                             mode = { 't', 'c', 'i', }, desc = 'my.insertenter: ctrl left', },

  { '<c-f11>', 'gf',                                   mode = { 'n', 'v', },      desc = 'my.insertenter: gf',                      silent = true, },

  -- esc
  { '<esc>',   '<c-\\><c-n>',                          mode = { 't', },           desc = 'my.insertenter: esc', },

  -- cr
  { '<c-;>',   '<cr>',                                 mode = { 'c', },           desc = 'my.insertenter: cr', },
  -- 见`neuims.lua`:
  -- { '<c-;>',   '<esc>o',                               mode = { 'i', },           desc = 'my.insertenter: cr', },
}

B.lazy_map {
  { "<c-'>", '<esc>a<c-r>=getline(line(".")-1)<CR><esc>0<c-a>WC', mode = { 'i', }, desc = 'my.insertenter: up line', },
}

B.lazy_map {
  { '<ScrollWheelUp>',   '<UP>',   mode = { 't', }, desc = 'my.insertenter: up', },
  { '<ScrollWheelDown>', '<DOWN>', mode = { 't', }, desc = 'my.insertenter: down', },
}

return M
