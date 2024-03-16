-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 10:20:04 星期六

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.yank_reg_dir_path = B.getcreate_stddata_dirpath 'yank-reg'
M.yank_reg_txt_path = M.yank_reg_dir_path:joinpath 'yank-reg.txt'
M.yank_reg_list_txt_path = M.yank_reg_dir_path:joinpath 'yank-reg-list.txt'

if not M.yank_reg_txt_path:exists() then
  M.yank_reg_txt_path:write(vim.inspect {}, 'w')
end

if not M.yank_reg_list_txt_path:exists() then
  M.yank_reg_list_txt_path:write(vim.inspect {}, 'w')
end

M.reg = B.read_table_from_file(M.yank_reg_txt_path.filename)
M.reg_list = B.read_table_from_file(M.yank_reg_list_txt_path.filename)

B.aucmd({ 'VimLeave', }, 'my.yank.reg', {
  callback = function()
    M.yank_reg_txt_path:write(vim.inspect(M.reg), 'w')
    M.yank_reg_list_txt_path:write(vim.inspect(vim.tbl_keys(M.reg)), 'w')
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
  for _, key in pairs(M.reg_list) do
    local content = M.reg[key]
    info[#info + 1] = string.format('%s[[%d]]: %s', key, #content, M.get_short(content))
  end
  B.notify_info(info)
end

function M.yank(reg, mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  M.reg[reg] = vim.fn.getreg '"'
  B.stack_item_uniq(M.reg_list, reg)
  M.reg_show()
end

function M.paste(reg, mode)
  local back = vim.fn.getreg '"'
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
  table.remove(M.reg_list, B.index_of(reg))
end

function M.clipboard(reg)
  vim.fn.setreg('+', M.reg[reg])
end

-----------------------------------------------------------------------

M.yank_pool_dir_path = B.getcreate_stddata_dirpath 'yank-pool'
M.yank_pool_txt_path = M.yank_pool_dir_path:joinpath 'yank-pool.txt'

if not M.yank_pool_txt_path:exists() then
  M.yank_pool_txt_path:write(vim.inspect {}, 'w')
end

M.pool = B.read_table_from_file(M.yank_pool_txt_path.filename)

B.aucmd({ 'VimLeave', }, 'my.yank.pool', {
  callback = function()
    M.yank_pool_txt_path:write(vim.inspect(M.pool), 'w')
  end,
})

function M.pool_show()
  local info = { tostring(#M.pool) .. ' item(s)', }
  for c, content in ipairs(M.pool) do
    info[#info + 1] = string.format('%2s. [[%d]]: %s', c, #content, M.get_short(content))
  end
  B.notify_info(info)
end

function M.stack(mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  B.stack_item_uniq(M.pool, vim.fn.getreg '"')
  M.pool_show()
end

function M.paste_from_stack_do(pool, mode)
  B.ui_sel(pool, 'sel to "', function(_, idx)
    local text = M.pool[idx]
    if B.is(text) then
      vim.fn.setreg('"', text)
      if mode == 'i' then
        vim.cmd [[call feedkeys("\<esc>p")]]
      elseif mode == 't' then
        if vim.fn.mode() == 't' then
          vim.cmd [[call feedkeys("\<c-\>\<c-n>pi")]]
        else
          vim.cmd [[call feedkeys("pi")]]
        end
      elseif mode == 'c' then
        vim.cmd [[call feedkeys(":\<up>")]]
        B.notify_info('copied to ": ' .. string.gsub(M.get_short(text), '\n', '\\n'))
      else
        vim.cmd [[call feedkeys("p")]]
      end
    end
  end)
end

function M.paste_from_stack(mode)
  local pool = {}
  for _, t in ipairs(M.pool) do
    pool[#pool + 1] = string.gsub(M.get_short(t), '\n', '\\n')
  end
  if mode == 't' then
    vim.cmd [[call feedkeys("\<c-\>\<c-n>")]]
    B.set_timeout(100, function()
      M.paste_from_stack_do(pool, mode)
    end)
  else
    M.paste_from_stack_do(pool, mode)
  end
end

function M.clipboard_from_pool()
  local pool = {}
  for _, t in ipairs(M.pool) do
    pool[#pool + 1] = string.gsub(M.get_short(t), '\n', '\\n')
  end
  B.ui_sel(pool, 'sel to +', function(_, idx)
    local text = M.pool[idx]
    if B.is(text) then
      vim.fn.setreg('+', text)
    end
  end)
end

function M.delete_pool()
  M.pool = {}
end

return M
