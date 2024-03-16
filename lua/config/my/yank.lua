-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 10:20:04 星期六

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.yank_pool_dir_path = B.getcreate_stddata_dirpath 'yank-pool'
M.yank_pool_txt_path = M.yank_pool_dir_path:joinpath 'yank-pool.txt'

if not M.yank_pool_txt_path:exists() then
  M.yank_pool_txt_path:write(vim.inspect {}, 'w')
end

M.reg = B.read_table_from_file(M.yank_pool_txt_path.filename)

B.aucmd({ 'VimLeave', }, 'nvim.telescope.VimLeave', {
  callback = function()
    M.yank_pool_txt_path:write(vim.inspect(M.reg), 'w')
  end,
})

function M.get_short(content)
  local temp = 50
  if #content >= (temp * 2 - 1) then
    local s1 = ''
    local s2 = ''
    for i = (temp * 2 - 1), 3, -1 do
      s2 = string.sub(content, #content - i, #content)
      if vim.fn.strdisplaywidth(s2) <= temp then
        break
      end
    end
    for i = (temp * 2 - 1), 3, -1 do
      s1 = string.sub(content, 1, i)
      if vim.fn.strdisplaywidth(s1) <= temp then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return content
end

function M.reg_show()
  local info = { tostring(#vim.tbl_keys(M.reg)) .. ' reg(s)', }
  for r, content in pairs(M.reg) do
    info[#info + 1] = M.get_short(string.format('%s[[%d]]: %s', r, #content, content))
  end
  B.notify_info(info)
end

function M.yank(reg, mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  M.reg[reg] = vim.fn.getreg '"'
  M.reg_show()
end

function M.paste(reg, mode)
  local back = vim.fn.getreg('"')
  vim.fn.setreg('"', M.reg[reg])
  if mode == 'i' then
    vim.cmd [[call feedkeys("\<c-o>p")]]
  elseif mode == 't' then
    vim.cmd [[call feedkeys("\<c-\>\<c-n>pi")]]
  elseif mode == 'c' then
    vim.cmd [[call feedkeys("\<c-r>")]]
  else
    vim.cmd [[call feedkeys("p")]]
  end
  vim.fn.setreg('"', back)
end

function M.delete(reg)
  M.reg[reg] = nil
end

return M
