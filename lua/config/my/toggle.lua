local M = {}

local B = require 'base'

M.diff = function()
  if vim.o.diff == false then
    vim.cmd 'diffthis'
  else
    local winid = vim.fn.win_getid()
    vim.cmd 'windo diffoff'
    vim.fn.win_gotoid(winid)
  end
  print('vim.o.diff:', vim.o.diff)
end

M.wrap = function()
  if vim.o.wrap == true then
    vim.cmd 'set nowrap'
  else
    vim.cmd 'set wrap'
  end
  print('vim.o.wrap:', vim.o.wrap)
end

M.renu = function()
  if vim.o.relativenumber == true then
    vim.cmd 'set norelativenumber'
  else
    vim.cmd 'set relativenumber'
  end
  print('vim.o.relativenumber:', vim.o.relativenumber)
end

M.signcolumn = function()
  if vim.o.signcolumn == 'no' then
    vim.cmd 'set signcolumn=auto:1'
  else
    vim.cmd 'set signcolumn=no'
  end
  print('vim.o.signcolumn:', vim.o.signcolumn)
end

M.conceallevel = function()
  if vim.o.conceallevel == 0 then
    vim.cmd 'set conceallevel=3'
  else
    vim.cmd 'set conceallevel=0'
  end
  print('vim.o.conceallevel:', vim.o.conceallevel)
end

M.iskeyword_bak = nil

M.iskeyword = function()
  if vim.o.iskeyword == '@,48-57,_,192-255' and M.iskeyword_bak then
    vim.o.iskeyword = M.iskeyword_bak
  else
    M.iskeyword_bak = vim.o.iskeyword
    vim.o.iskeyword = '@,48-57,_,192-255'
  end
  print(vim.o.iskeyword)
end

-- mapping
B.del_map({ 'n', 'v', }, '<leader>t')

require 'which-key'.register { ['<leader>t'] = { name = 'my.toggle', }, }

B.lazy_map {
  { '<leader>td', function() M.diff() end,         mode = { 'n', 'v', }, silent = true, desc = 'my.toggle: diff', },
  { '<leader>tw', function() M.wrap() end,         mode = { 'n', 'v', }, silent = true, desc = 'my.toggle: wrap', },
  { '<leader>tr', function() M.renu() end,         mode = { 'n', 'v', }, silent = true, desc = 'my.toggle: renu', },
  { '<leader>ts', function() M.signcolumn() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.toggle: signcolumn', },
  { '<leader>tc', function() M.conceallevel() end, mode = { 'n', 'v', }, silent = true, desc = 'my.toggle: conceallevel', },
  { '<leader>tk', function() M.iskeyword() end,    mode = { 'n', 'v', }, silent = true, desc = 'my.toggle: iskeyword', },
}


return M
