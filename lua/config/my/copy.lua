local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

function M._copy(content)
  vim.fn.setreg('+', content)
  B.notify_info(content)
end

function M._get_full_name()
  return B.rep_slash(vim.api.nvim_buf_get_name(0))
end

function M._get_rela_name()
  return B.rep_slash(vim.fn.bufname())
end

function M.full_name()
  M._copy(M._get_full_name())
end

function M.full_head()
  M._copy(vim.fn.fnamemodify(M._get_full_name(), ':h'))
end

function M.full_tail()
  M._copy(vim.fn.fnamemodify(M._get_full_name(), ':t'))
end

function M.copy_cwd()
  M._copy(vim.loop.cwd())
end

function M.rela_name()
  M._copy(M._get_rela_name())
end

function M.rela_head()
  M._copy(vim.fn.fnamemodify(M._get_rela_name(), ':h'))
end

-- mappings
B.del_map({ 'n', 'v', }, '<leader>y')

require 'which-key'.register { ['<leader>y'] = { name = 'my.yank', }, }
require 'which-key'.register { ['<leader>yf'] = { name = 'my.yank.full', }, }
require 'which-key'.register { ['<leader>yr'] = { name = 'my.yank.rela', }, }

B.lazy_map {
  { '<leader>yff', M.full_name, mode = { 'n', 'v', }, silent = true, desc = 'my.yank: full_name', },
  { '<leader>yft', M.full_tail, mode = { 'n', 'v', }, silent = true, desc = 'my.yank: full_tail', },
  { '<leader>yfh', M.full_head, mode = { 'n', 'v', }, silent = true, desc = 'my.yank: full_head', },
  { '<leader>yrr', M.rela_name, mode = { 'n', 'v', }, silent = true, desc = 'my.yank: rela_name', },
  { '<leader>yrh', M.rela_head, mode = { 'n', 'v', }, silent = true, desc = 'my.yank: rela_head', },
}

return M
