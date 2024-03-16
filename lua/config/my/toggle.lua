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

function M._wrap_en()
  if B.is_in_tbl(vim.o.ft, M.donot_change_fts) then
    return
  end
  vim.o.wrap = 1
end

M.wrap = function()
  local winid = vim.fn.win_getid()
  if vim.o.wrap == true then
    vim.cmd 'windo set nowrap'
  else
    vim.cmd "windo lua require 'config.my.toggle'._wrap_en()"
  end
  print('vim.o.wrap:', vim.o.wrap)
  vim.fn.win_gotoid(winid)
end

M.donot_change_fts = {
  'NvimTree',
  'aerial',
  'qf',
  'fugitive',
}

M._renu_en = function()
  if B.is_in_tbl(vim.o.ft, M.donot_change_fts) then
    return
  end
  if B.is(vim.o.number) then
    vim.o.relativenumber = 1
  end
end

M._renu_dis = function()
  if B.is_in_tbl(vim.o.ft, M.donot_change_fts) then
    return
  end
  if B.is(vim.o.number) then
    vim.o.relativenumber = 0
  end
end

M.renu = function()
  local winid = vim.fn.win_getid()
  if B.is(vim.o.relativenumber) then
    vim.cmd "windo lua require 'config.my.toggle'._renu_dis()"
  else
    vim.cmd "windo lua require 'config.my.toggle'._renu_en()"
  end
  print('vim.o.relativenumber:', vim.o.relativenumber)
  vim.fn.win_gotoid(winid)
end

function M._nu_dis()
  if B.is_in_tbl(vim.o.ft, M.donot_change_fts) then
    return
  end
  if B.is(vim.o.relativenumber) then
    vim.o.relativenumber = 0
    vim.g.relativenumber = 1
  else
    vim.g.relativenumber = 0
  end
  vim.o.number = 0
end

function M._nu_en()
  if B.is_in_tbl(vim.o.ft, M.donot_change_fts) then
    return
  end
  if B.is(vim.o.relativenumber) then
    vim.o.relativenumber = 1
    vim.g.relativenumber = 0
  else
    vim.g.relativenumber = 1
  end
  vim.o.number = 1
end

M.nu = function()
  local winid = vim.fn.win_getid()
  if B.is(vim.o.number) then
    vim.cmd "windo lua require 'config.my.toggle'._nu_dis()"
  else
    vim.cmd "windo lua require 'config.my.toggle'._nu_en()"
  end
  print('vim.o.number:', vim.o.number)
  vim.fn.win_gotoid(winid)
end

M.signcolumn = function()
  local winid = vim.fn.win_getid()
  if vim.o.signcolumn == 'no' then
    vim.cmd 'windo set signcolumn=auto:1'
  else
    vim.cmd 'windo set signcolumn=no'
  end
  print('vim.o.signcolumn:', vim.o.signcolumn)
  vim.fn.win_gotoid(winid)
end

M.conceallevel = function()
  local winid = vim.fn.win_getid()
  if vim.o.conceallevel == 0 then
    vim.cmd 'windo set conceallevel=3'
  else
    vim.cmd 'windo set conceallevel=0'
  end
  print('vim.o.conceallevel:', vim.o.conceallevel)
  vim.fn.win_gotoid(winid)
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

return M
