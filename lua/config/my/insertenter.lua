local M = {}

local B = require 'base'

vim.fn.setreg('e', 'reg e empty')
vim.fn.setreg('3', 'reg 3 empty')

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
    if #Word > 0 then vim.fn.setreg('3', Word) end
    if vim.g.telescope_entered or B.is_buf_fts { 'NvimTree', 'DiffviewFileHistory', } then return end
    M.setreg()
  end,
})

B.lazy_map {
  -- reg
  { '<c-e>',   '<c-r>e',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste <cword>',           silent = true, },
  { '<c-3>',   '<c-r>3',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste <cWORD>',           silent = true, },

  { '<c-t>',   '<c-r>=expand("%:t")<cr>',              mode = { 'c', 'i', },      desc = 'my.insertenter: paste %:t',               silent = true, },
  { '<c-b>',   '<c-r>=bufname()<cr>',                  mode = { 'c', 'i', },      desc = 'my.insertenter: paste bufname()',         silent = true, },
  { '<c-f>',   '<c-r>=nvim_buf_get_name(0)<cr>',       mode = { 'c', 'i', },      desc = 'my.insertenter: paste nvim_buf_get_name', silent = true, },
  { '<c-d>',   '<c-r>=getcwd()<cr>',                   mode = { 'c', 'i', },      desc = 'my.insertenter: paste cwd',               silent = true, },

  { '<c-l>',   '<c-r>=g:curline<cr>',                  mode = { 'c', 'i', },      desc = 'my.insertenter: paste cur line',          silent = true, },

  { "<c-'>",   '<c-r>=g:single_quote<cr>',             mode = { 'c', 't', },      desc = "my.insertenter: <c-'>",                   silent = true, },
  { "<c-s-'>", '<c-r>=g:double_quote<cr>',             mode = { 'c', 't', },      desc = 'my.insertenter: <c-">',                   silent = true, },
  { '<c-0>',   '<c-r>=g:parentheses<cr>',              mode = { 'c', 't', },      desc = 'my.insertenter: <c-)>',                   silent = true, },
  { '<c-]>',   '<c-r>=g:bracket<cr>',                  mode = { 'c', 't', },      desc = 'my.insertenter: <c-]>',                   silent = true, },
  { '<c-s-]>', '<c-r>=g:brace<cr>',                    mode = { 'c', 't', },      desc = 'my.insertenter: <c->',                    silent = true, },
  { '<c-`>',   '<c-r>=g:back_quote<cr>',               mode = { 'c', 't', },      desc = 'my.insertenter: <c-`>',                   silent = true, },
  { '<c-s-.>', '<c-r>=g:angle_bracket<cr>',            mode = { 'c', 't', },      desc = 'my.insertenter: <c->>',                   silent = true, },

  { '<c-s>',   '<c-r>"',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste "',                 silent = true, },
  { '<c-s>',   '<c-\\><c-n>pi',                        mode = { 't', },           desc = 'my.insertenter: paste "',                 silent = true, },

  { '<c-v>',   '<c-r>+',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste +',                 silent = true, },
  { '<c-v>',   '<c-\\><c-n>"+pi',                      mode = { 't', },           desc = 'my.insertenter: paste +',                 silent = true, },

  -- cursor
  { 'k',       "(v:count == 0 && &wrap) ? 'gk' : 'k'", mode = { 'n', 'v', },      desc = 'my.insertenter: k',                       silent = true, expr = true, },
  { 'j',       "(v:count == 0 && &wrap) ? 'gj' : 'j'", mode = { 'n', 'v', },      desc = 'my.insertenter: j',                       silent = true, expr = true, },

  { '<a-k>',   '<UP>',                                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: up',                      silent = true, },
  { '<a-j>',   '<DOWN>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: down',                    silent = true, },

  { '<a-s-k>', '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up',                    silent = true, },
  { '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down',                  silent = true, },
  { '<c-k>',   '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up',                    silent = true, },
  { '<c-j>',   '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down',                  silent = true, },
  { '<c-s-k>', '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up',                    silent = true, },
  { '<c-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down',                  silent = true, },

  { '<a-i>',   '<HOME>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: home',                    silent = true, },
  { '<a-s-i>', '<HOME>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: home',                    silent = true, },
  { '<a-o>',   '<END>',                                mode = { 't', 'c', 'i', }, desc = 'my.insertenter: end',                     silent = true, },
  { '<a-s-o>', '<END>',                                mode = { 't', 'c', 'i', }, desc = 'my.insertenter: end',                     silent = true, },

  { '<a-l>',   '<RIGHT>',                              mode = { 't', 'c', 'i', }, desc = 'my.insertenter: right',                   silent = true, },
  { '<a-h>',   '<LEFT>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: left',                    silent = true, },
  { '<a-s-l>', '<c-RIGHT>',                            mode = { 't', 'c', 'i', }, desc = 'my.insertenter: ctrl right',              silent = true, },
  { '<a-s-h>', '<c-LEFT>',                             mode = { 't', 'c', 'i', }, desc = 'my.insertenter: ctrl left',               silent = true, },

  { '<c-f11>', 'gf',                                   mode = { 'n', 'v', },      desc = 'my.insertenter: gf',                      silent = true, },

  -- esc
  { '<esc>',   '<c-\\><c-n>',                          mode = { 't', },           desc = 'my.insertenter: esc',                     silent = true, },
}
