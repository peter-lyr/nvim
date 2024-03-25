-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 10:20:04 星期六

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.yank_reg_dir_path = B.getcreate_stddata_dirpath 'yank-reg'
M.yank_reg_txt_path = M.yank_reg_dir_path:joinpath 'yank-reg.txt'
M.yank_reg_list_txt_path = M.yank_reg_dir_path:joinpath 'yank-reg-list.txt'
M.clipboard_txt_path = M.yank_reg_dir_path:joinpath 'clipboard.txt'

if not M.yank_reg_txt_path:exists() then
  M.yank_reg_txt_path:write(vim.inspect {}, 'w')
end

if not M.yank_reg_list_txt_path:exists() then
  M.yank_reg_list_txt_path:write(vim.inspect {}, 'w')
end

if not M.clipboard_txt_path:exists() then
  M.clipboard_txt_path:write(vim.inspect {}, 'w')
end

M.reg = B.read_table_from_file(M.yank_reg_txt_path.filename)
M.reg_list = B.read_table_from_file(M.yank_reg_list_txt_path.filename)
M.clipboard_list = B.read_table_from_file(M.clipboard_txt_path.filename)

B.aucmd({ 'VimLeave', }, 'my.yank.reg', {
  callback = function()
    M.yank_reg_txt_path:write(vim.inspect(M.reg), 'w')
    M.yank_reg_list_txt_path:write(vim.inspect(vim.tbl_keys(M.reg)), 'w')
    M.clipboard_txt_path:write(vim.inspect(M.clipboard_list), 'w')
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
    vim.cmd [[call feedkeys("\<c-r>\"")]]
  else
    vim.cmd [[call feedkeys("p")]]
  end
  B.set_timeout(400, function()
    vim.fn.setreg('"', back)
  end)
end

function M.delete(reg)
  M.reg[reg] = nil
  table.remove(M.reg_list, B.index_of(reg))
end

function M.clipboard(reg)
  if M.reg[reg] then
    vim.fn.setreg('+', M.reg[reg])
  end
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

B.aucmd({ 'CursorMoved', 'CursorMovedI', }, 'my.yank.CursorMoved', {
  callback = function()
    if M.timer_cursorhold then
      B.clear_interval(M.timer_cursorhold)
      M.timer_cursorhold = nil
    end
  end,
})

function M.clipboard_check()
  B.stack_item_uniq(M.clipboard_list, vim.fn.getreg '+')
end

B.aucmd({ 'CursorHold', 'CursorHoldI', }, 'my.yank.CursorHold', {
  callback = function()
    if not M.timer_cursorhold then
      M.timer_cursorhold = B.set_timeout(3000, function()
        if M.timer_cursorhold then
          M.timer_cursorhold = nil
          M.clipboard_check()
        end
      end)
    end
  end,
})

B.aucmd({ 'FocusGained', }, 'my.yank.FocusGained', {
  callback = function()
    B.clear_interval(M.timer_focus)
    M.timer_focus = nil
  end,
})

B.aucmd({ 'FocusLost', }, 'my.yank.FocusLost', {
  callback = function()
    B.clear_interval(M.timer_cursorhold)
    M.timer_cursorhold = nil
    M.clipboard_check()
    if not M.timer_focus then
      M.timer_focus = B.set_interval(3000, function()
        if M.timer_focus then
          M.clipboard_check()
        end
      end)
    end
  end,
})

function M.map()
  require 'which-key'.register {
    ['<F9>']      = { name = 'my.yank', },
    ['<F9><F9>']  = { function() M.reg_show() end, 'show all', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9>a']     = { function() M.yank('a', 'n', 'w') end, '<cword> to a', mode = { 'n', }, silent = true, },
    ['<F9>b']     = { function() M.yank('b', 'n', 'w') end, '<cword> to b', mode = { 'n', }, silent = true, },
    ['<F9>c']     = { function() M.yank('c', 'n', 'w') end, '<cword> to c', mode = { 'n', }, silent = true, },
    ['<F9>d']     = { function() M.yank('d', 'n', 'w') end, '<cword> to d', mode = { 'n', }, silent = true, },
    ['<F9>e']     = { function() M.yank('e', 'n', 'w') end, '<cword> to e', mode = { 'n', }, silent = true, },
    ['<F9>f']     = { function() M.yank('f', 'n', 'w') end, '<cword> to f', mode = { 'n', }, silent = true, },
    ['<F9>g']     = { function() M.yank('g', 'n', 'w') end, '<cword> to g', mode = { 'n', }, silent = true, },
    ['<F9>h']     = { function() M.yank('h', 'n', 'w') end, '<cword> to h', mode = { 'n', }, silent = true, },
    ['<F9>i']     = { function() M.yank('i', 'n', 'w') end, '<cword> to i', mode = { 'n', }, silent = true, },
    ['<F9>j']     = { function() M.yank('j', 'n', 'w') end, '<cword> to j', mode = { 'n', }, silent = true, },
    ['<F9>k']     = { function() M.yank('k', 'n', 'w') end, '<cword> to k', mode = { 'n', }, silent = true, },
    ['<F9>l']     = { function() M.yank('l', 'n', 'w') end, '<cword> to l', mode = { 'n', }, silent = true, },
    ['<F9>m']     = { function() M.yank('m', 'n', 'w') end, '<cword> to m', mode = { 'n', }, silent = true, },
    ['<F9>n']     = { function() M.yank('n', 'n', 'w') end, '<cword> to n', mode = { 'n', }, silent = true, },
    ['<F9>o']     = { function() M.yank('o', 'n', 'w') end, '<cword> to o', mode = { 'n', }, silent = true, },
    ['<F9>p']     = { function() M.yank('p', 'n', 'w') end, '<cword> to p', mode = { 'n', }, silent = true, },
    ['<F9>q']     = { function() M.yank('q', 'n', 'w') end, '<cword> to q', mode = { 'n', }, silent = true, },
    ['<F9>r']     = { function() M.yank('r', 'n', 'w') end, '<cword> to r', mode = { 'n', }, silent = true, },
    ['<F9>s']     = { function() M.yank('s', 'n', 'w') end, '<cword> to s', mode = { 'n', }, silent = true, },
    ['<F9>t']     = { function() M.yank('t', 'n', 'w') end, '<cword> to t', mode = { 'n', }, silent = true, },
    ['<F9>u']     = { function() M.yank('u', 'n', 'w') end, '<cword> to u', mode = { 'n', }, silent = true, },
    ['<F9>v']     = { function() M.yank('v', 'n', 'w') end, '<cword> to v', mode = { 'n', }, silent = true, },
    ['<F9>w']     = { function() M.yank('w', 'n', 'w') end, '<cword> to w', mode = { 'n', }, silent = true, },
    ['<F9>x']     = { function() M.yank('x', 'n', 'w') end, '<cword> to x', mode = { 'n', }, silent = true, },
    ['<F9>y']     = { function() M.yank('y', 'n', 'w') end, '<cword> to y', mode = { 'n', }, silent = true, },
    ['<F9>z']     = { function() M.yank('z', 'n', 'w') end, '<cword> to z', mode = { 'n', }, silent = true, },
    ['<F9>,']     = { function() M.yank(',', 'n', 'w') end, '<cword> to ,', mode = { 'n', }, silent = true, },
    ['<F9>.']     = { function() M.yank('.', 'n', 'w') end, '<cword> to .', mode = { 'n', }, silent = true, },
    ['<F9>/']     = { function() M.yank('/', 'n', 'w') end, '<cword> to /', mode = { 'n', }, silent = true, },
    ['<F9>;']     = { function() M.yank(';', 'n', 'w') end, '<cword> to ;', mode = { 'n', }, silent = true, },
    ["<F9>'"]     = { function() M.yank("'", 'n', 'w') end, "<cword> to '", mode = { 'n', }, silent = true, },
    ['<F9>[']     = { function() M.yank('[', 'n', 'w') end, '<cword> to [', mode = { 'n', }, silent = true, },
    ['<F9>]']     = { function() M.yank(']', 'n', 'w') end, '<cword> to ]', mode = { 'n', }, silent = true, },
    ['<F9><a-a>'] = { function() M.yank('a', 'n', 'W') end, '<cWORD> to a', mode = { 'n', }, silent = true, },
    ['<F9><a-b>'] = { function() M.yank('b', 'n', 'W') end, '<cWORD> to b', mode = { 'n', }, silent = true, },
    ['<F9><a-c>'] = { function() M.yank('c', 'n', 'W') end, '<cWORD> to c', mode = { 'n', }, silent = true, },
    ['<F9><a-d>'] = { function() M.yank('d', 'n', 'W') end, '<cWORD> to d', mode = { 'n', }, silent = true, },
    ['<F9><a-e>'] = { function() M.yank('e', 'n', 'W') end, '<cWORD> to e', mode = { 'n', }, silent = true, },
    ['<F9><a-f>'] = { function() M.yank('f', 'n', 'W') end, '<cWORD> to f', mode = { 'n', }, silent = true, },
    ['<F9><a-g>'] = { function() M.yank('g', 'n', 'W') end, '<cWORD> to g', mode = { 'n', }, silent = true, },
    ['<F9><a-h>'] = { function() M.yank('h', 'n', 'W') end, '<cWORD> to h', mode = { 'n', }, silent = true, },
    ['<F9><a-i>'] = { function() M.yank('i', 'n', 'W') end, '<cWORD> to i', mode = { 'n', }, silent = true, },
    ['<F9><a-j>'] = { function() M.yank('j', 'n', 'W') end, '<cWORD> to j', mode = { 'n', }, silent = true, },
    ['<F9><a-k>'] = { function() M.yank('k', 'n', 'W') end, '<cWORD> to k', mode = { 'n', }, silent = true, },
    ['<F9><a-l>'] = { function() M.yank('l', 'n', 'W') end, '<cWORD> to l', mode = { 'n', }, silent = true, },
    ['<F9><a-m>'] = { function() M.yank('m', 'n', 'W') end, '<cWORD> to m', mode = { 'n', }, silent = true, },
    ['<F9><a-n>'] = { function() M.yank('n', 'n', 'W') end, '<cWORD> to n', mode = { 'n', }, silent = true, },
    ['<F9><a-o>'] = { function() M.yank('o', 'n', 'W') end, '<cWORD> to o', mode = { 'n', }, silent = true, },
    ['<F9><a-p>'] = { function() M.yank('p', 'n', 'W') end, '<cWORD> to p', mode = { 'n', }, silent = true, },
    ['<F9><a-q>'] = { function() M.yank('q', 'n', 'W') end, '<cWORD> to q', mode = { 'n', }, silent = true, },
    ['<F9><a-r>'] = { function() M.yank('r', 'n', 'W') end, '<cWORD> to r', mode = { 'n', }, silent = true, },
    ['<F9><a-s>'] = { function() M.yank('s', 'n', 'W') end, '<cWORD> to s', mode = { 'n', }, silent = true, },
    ['<F9><a-t>'] = { function() M.yank('t', 'n', 'W') end, '<cWORD> to t', mode = { 'n', }, silent = true, },
    ['<F9><a-u>'] = { function() M.yank('u', 'n', 'W') end, '<cWORD> to u', mode = { 'n', }, silent = true, },
    ['<F9><a-v>'] = { function() M.yank('v', 'n', 'W') end, '<cWORD> to v', mode = { 'n', }, silent = true, },
    ['<F9><a-w>'] = { function() M.yank('w', 'n', 'W') end, '<cWORD> to w', mode = { 'n', }, silent = true, },
    ['<F9><a-x>'] = { function() M.yank('x', 'n', 'W') end, '<cWORD> to x', mode = { 'n', }, silent = true, },
    ['<F9><a-y>'] = { function() M.yank('y', 'n', 'W') end, '<cWORD> to y', mode = { 'n', }, silent = true, },
    ['<F9><a-z>'] = { function() M.yank('z', 'n', 'W') end, '<cWORD> to z', mode = { 'n', }, silent = true, },
    ['<F9><a-,>'] = { function() M.yank(',', 'n', 'W') end, '<cWORD> to ,', mode = { 'n', }, silent = true, },
    ['<F9><a-.>'] = { function() M.yank('.', 'n', 'W') end, '<cWORD> to .', mode = { 'n', }, silent = true, },
    ['<F9><a-/>'] = { function() M.yank('/', 'n', 'W') end, '<cWORD> to /', mode = { 'n', }, silent = true, },
    ['<F9><a-;>'] = { function() M.yank(';', 'n', 'W') end, '<cWORD> to ;', mode = { 'n', }, silent = true, },
    ["<F9><a-'>"] = { function() M.yank("'", 'n', 'W') end, "<cWORD> to '", mode = { 'n', }, silent = true, },
    ['<F9><a-[>'] = { function() M.yank('[', 'n', 'W') end, '<cWORD> to [', mode = { 'n', }, silent = true, },
    ['<F9><a-]>'] = { function() M.yank(']', 'n', 'W') end, '<cWORD> to ]', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.yank('a', 'v') end, 'sel to a', mode = { 'v', }, silent = true, },
    ['<F9>b'] = { function() M.yank('b', 'v') end, 'sel to b', mode = { 'v', }, silent = true, },
    ['<F9>c'] = { function() M.yank('c', 'v') end, 'sel to c', mode = { 'v', }, silent = true, },
    ['<F9>d'] = { function() M.yank('d', 'v') end, 'sel to d', mode = { 'v', }, silent = true, },
    ['<F9>e'] = { function() M.yank('e', 'v') end, 'sel to e', mode = { 'v', }, silent = true, },
    ['<F9>f'] = { function() M.yank('f', 'v') end, 'sel to f', mode = { 'v', }, silent = true, },
    ['<F9>g'] = { function() M.yank('g', 'v') end, 'sel to g', mode = { 'v', }, silent = true, },
    ['<F9>h'] = { function() M.yank('h', 'v') end, 'sel to h', mode = { 'v', }, silent = true, },
    ['<F9>i'] = { function() M.yank('i', 'v') end, 'sel to i', mode = { 'v', }, silent = true, },
    ['<F9>j'] = { function() M.yank('j', 'v') end, 'sel to j', mode = { 'v', }, silent = true, },
    ['<F9>k'] = { function() M.yank('k', 'v') end, 'sel to k', mode = { 'v', }, silent = true, },
    ['<F9>l'] = { function() M.yank('l', 'v') end, 'sel to l', mode = { 'v', }, silent = true, },
    ['<F9>m'] = { function() M.yank('m', 'v') end, 'sel to m', mode = { 'v', }, silent = true, },
    ['<F9>n'] = { function() M.yank('n', 'v') end, 'sel to n', mode = { 'v', }, silent = true, },
    ['<F9>o'] = { function() M.yank('o', 'v') end, 'sel to o', mode = { 'v', }, silent = true, },
    ['<F9>p'] = { function() M.yank('p', 'v') end, 'sel to p', mode = { 'v', }, silent = true, },
    ['<F9>q'] = { function() M.yank('q', 'v') end, 'sel to q', mode = { 'v', }, silent = true, },
    ['<F9>r'] = { function() M.yank('r', 'v') end, 'sel to r', mode = { 'v', }, silent = true, },
    ['<F9>s'] = { function() M.yank('s', 'v') end, 'sel to s', mode = { 'v', }, silent = true, },
    ['<F9>t'] = { function() M.yank('t', 'v') end, 'sel to t', mode = { 'v', }, silent = true, },
    ['<F9>u'] = { function() M.yank('u', 'v') end, 'sel to u', mode = { 'v', }, silent = true, },
    ['<F9>v'] = { function() M.yank('v', 'v') end, 'sel to v', mode = { 'v', }, silent = true, },
    ['<F9>w'] = { function() M.yank('w', 'v') end, 'sel to w', mode = { 'v', }, silent = true, },
    ['<F9>x'] = { function() M.yank('x', 'v') end, 'sel to x', mode = { 'v', }, silent = true, },
    ['<F9>y'] = { function() M.yank('y', 'v') end, 'sel to y', mode = { 'v', }, silent = true, },
    ['<F9>z'] = { function() M.yank('z', 'v') end, 'sel to z', mode = { 'v', }, silent = true, },
    ['<F9>,'] = { function() M.yank(',', 'v') end, 'sel to ,', mode = { 'v', }, silent = true, },
    ['<F9>.'] = { function() M.yank('.', 'v') end, 'sel to .', mode = { 'v', }, silent = true, },
    ['<F9>/'] = { function() M.yank('/', 'v') end, 'sel to /', mode = { 'v', }, silent = true, },
    ['<F9>;'] = { function() M.yank(';', 'v') end, 'sel to ;', mode = { 'v', }, silent = true, },
    ["<F9>'"] = { function() M.yank("'", 'v') end, "sel to '", mode = { 'v', }, silent = true, },
    ['<F9>['] = { function() M.yank('[', 'v') end, 'sel to [', mode = { 'v', }, silent = true, },
    ['<F9>]'] = { function() M.yank(']', 'v') end, 'sel to ]', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste('a', 'i') end, 'paste from a', mode = { 'i', }, silent = true, },
    ['<F9>b'] = { function() M.paste('b', 'i') end, 'paste from b', mode = { 'i', }, silent = true, },
    ['<F9>c'] = { function() M.paste('c', 'i') end, 'paste from c', mode = { 'i', }, silent = true, },
    ['<F9>d'] = { function() M.paste('d', 'i') end, 'paste from d', mode = { 'i', }, silent = true, },
    ['<F9>e'] = { function() M.paste('e', 'i') end, 'paste from e', mode = { 'i', }, silent = true, },
    ['<F9>f'] = { function() M.paste('f', 'i') end, 'paste from f', mode = { 'i', }, silent = true, },
    ['<F9>g'] = { function() M.paste('g', 'i') end, 'paste from g', mode = { 'i', }, silent = true, },
    ['<F9>h'] = { function() M.paste('h', 'i') end, 'paste from h', mode = { 'i', }, silent = true, },
    ['<F9>i'] = { function() M.paste('i', 'i') end, 'paste from i', mode = { 'i', }, silent = true, },
    ['<F9>j'] = { function() M.paste('j', 'i') end, 'paste from j', mode = { 'i', }, silent = true, },
    ['<F9>k'] = { function() M.paste('k', 'i') end, 'paste from k', mode = { 'i', }, silent = true, },
    ['<F9>l'] = { function() M.paste('l', 'i') end, 'paste from l', mode = { 'i', }, silent = true, },
    ['<F9>m'] = { function() M.paste('m', 'i') end, 'paste from m', mode = { 'i', }, silent = true, },
    ['<F9>n'] = { function() M.paste('n', 'i') end, 'paste from n', mode = { 'i', }, silent = true, },
    ['<F9>o'] = { function() M.paste('o', 'i') end, 'paste from o', mode = { 'i', }, silent = true, },
    ['<F9>p'] = { function() M.paste('p', 'i') end, 'paste from p', mode = { 'i', }, silent = true, },
    ['<F9>q'] = { function() M.paste('q', 'i') end, 'paste from q', mode = { 'i', }, silent = true, },
    ['<F9>r'] = { function() M.paste('r', 'i') end, 'paste from r', mode = { 'i', }, silent = true, },
    ['<F9>s'] = { function() M.paste('s', 'i') end, 'paste from s', mode = { 'i', }, silent = true, },
    ['<F9>t'] = { function() M.paste('t', 'i') end, 'paste from t', mode = { 'i', }, silent = true, },
    ['<F9>u'] = { function() M.paste('u', 'i') end, 'paste from u', mode = { 'i', }, silent = true, },
    ['<F9>v'] = { function() M.paste('v', 'i') end, 'paste from v', mode = { 'i', }, silent = true, },
    ['<F9>w'] = { function() M.paste('w', 'i') end, 'paste from w', mode = { 'i', }, silent = true, },
    ['<F9>x'] = { function() M.paste('x', 'i') end, 'paste from x', mode = { 'i', }, silent = true, },
    ['<F9>y'] = { function() M.paste('y', 'i') end, 'paste from y', mode = { 'i', }, silent = true, },
    ['<F9>z'] = { function() M.paste('z', 'i') end, 'paste from z', mode = { 'i', }, silent = true, },
    ['<F9>,'] = { function() M.paste(',', 'i') end, 'paste from ,', mode = { 'i', }, silent = true, },
    ['<F9>.'] = { function() M.paste('.', 'i') end, 'paste from .', mode = { 'i', }, silent = true, },
    ['<F9>/'] = { function() M.paste('/', 'i') end, 'paste from /', mode = { 'i', }, silent = true, },
    ['<F9>;'] = { function() M.paste(';', 'i') end, 'paste from ;', mode = { 'i', }, silent = true, },
    ["<F9>'"] = { function() M.paste("'", 'i') end, "paste from '", mode = { 'i', }, silent = true, },
    ['<F9>['] = { function() M.paste('[', 'i') end, 'paste from [', mode = { 'i', }, silent = true, },
    ['<F9>]'] = { function() M.paste(']', 'i') end, 'paste from ]', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste('a', 'c') end, 'paste from a', mode = { 'c', }, silent = true, },
    ['<F9>b'] = { function() M.paste('b', 'c') end, 'paste from b', mode = { 'c', }, silent = true, },
    ['<F9>c'] = { function() M.paste('c', 'c') end, 'paste from c', mode = { 'c', }, silent = true, },
    ['<F9>d'] = { function() M.paste('d', 'c') end, 'paste from d', mode = { 'c', }, silent = true, },
    ['<F9>e'] = { function() M.paste('e', 'c') end, 'paste from e', mode = { 'c', }, silent = true, },
    ['<F9>f'] = { function() M.paste('f', 'c') end, 'paste from f', mode = { 'c', }, silent = true, },
    ['<F9>g'] = { function() M.paste('g', 'c') end, 'paste from g', mode = { 'c', }, silent = true, },
    ['<F9>h'] = { function() M.paste('h', 'c') end, 'paste from h', mode = { 'c', }, silent = true, },
    ['<F9>i'] = { function() M.paste('i', 'c') end, 'paste from i', mode = { 'c', }, silent = true, },
    ['<F9>j'] = { function() M.paste('j', 'c') end, 'paste from j', mode = { 'c', }, silent = true, },
    ['<F9>k'] = { function() M.paste('k', 'c') end, 'paste from k', mode = { 'c', }, silent = true, },
    ['<F9>l'] = { function() M.paste('l', 'c') end, 'paste from l', mode = { 'c', }, silent = true, },
    ['<F9>m'] = { function() M.paste('m', 'c') end, 'paste from m', mode = { 'c', }, silent = true, },
    ['<F9>n'] = { function() M.paste('n', 'c') end, 'paste from n', mode = { 'c', }, silent = true, },
    ['<F9>o'] = { function() M.paste('o', 'c') end, 'paste from o', mode = { 'c', }, silent = true, },
    ['<F9>p'] = { function() M.paste('p', 'c') end, 'paste from p', mode = { 'c', }, silent = true, },
    ['<F9>q'] = { function() M.paste('q', 'c') end, 'paste from q', mode = { 'c', }, silent = true, },
    ['<F9>r'] = { function() M.paste('r', 'c') end, 'paste from r', mode = { 'c', }, silent = true, },
    ['<F9>s'] = { function() M.paste('s', 'c') end, 'paste from s', mode = { 'c', }, silent = true, },
    ['<F9>t'] = { function() M.paste('t', 'c') end, 'paste from t', mode = { 'c', }, silent = true, },
    ['<F9>u'] = { function() M.paste('u', 'c') end, 'paste from u', mode = { 'c', }, silent = true, },
    ['<F9>v'] = { function() M.paste('v', 'c') end, 'paste from v', mode = { 'c', }, silent = true, },
    ['<F9>w'] = { function() M.paste('w', 'c') end, 'paste from w', mode = { 'c', }, silent = true, },
    ['<F9>x'] = { function() M.paste('x', 'c') end, 'paste from x', mode = { 'c', }, silent = true, },
    ['<F9>y'] = { function() M.paste('y', 'c') end, 'paste from y', mode = { 'c', }, silent = true, },
    ['<F9>z'] = { function() M.paste('z', 'c') end, 'paste from z', mode = { 'c', }, silent = true, },
    ['<F9>,'] = { function() M.paste(',', 'c') end, 'paste from ,', mode = { 'c', }, silent = true, },
    ['<F9>.'] = { function() M.paste('.', 'c') end, 'paste from .', mode = { 'c', }, silent = true, },
    ['<F9>/'] = { function() M.paste('/', 'c') end, 'paste from /', mode = { 'c', }, silent = true, },
    ['<F9>;'] = { function() M.paste(';', 'c') end, 'paste from ;', mode = { 'c', }, silent = true, },
    ["<F9>'"] = { function() M.paste("'", 'c') end, "paste from '", mode = { 'c', }, silent = true, },
    ['<F9>['] = { function() M.paste('[', 'c') end, 'paste from [', mode = { 'c', }, silent = true, },
    ['<F9>]'] = { function() M.paste(']', 'c') end, 'paste from ]', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste('a', 't') end, 'paste from a', mode = { 't', }, silent = true, },
    ['<F9>b'] = { function() M.paste('b', 't') end, 'paste from b', mode = { 't', }, silent = true, },
    ['<F9>c'] = { function() M.paste('c', 't') end, 'paste from c', mode = { 't', }, silent = true, },
    ['<F9>d'] = { function() M.paste('d', 't') end, 'paste from d', mode = { 't', }, silent = true, },
    ['<F9>e'] = { function() M.paste('e', 't') end, 'paste from e', mode = { 't', }, silent = true, },
    ['<F9>f'] = { function() M.paste('f', 't') end, 'paste from f', mode = { 't', }, silent = true, },
    ['<F9>g'] = { function() M.paste('g', 't') end, 'paste from g', mode = { 't', }, silent = true, },
    ['<F9>h'] = { function() M.paste('h', 't') end, 'paste from h', mode = { 't', }, silent = true, },
    ['<F9>i'] = { function() M.paste('i', 't') end, 'paste from i', mode = { 't', }, silent = true, },
    ['<F9>j'] = { function() M.paste('j', 't') end, 'paste from j', mode = { 't', }, silent = true, },
    ['<F9>k'] = { function() M.paste('k', 't') end, 'paste from k', mode = { 't', }, silent = true, },
    ['<F9>l'] = { function() M.paste('l', 't') end, 'paste from l', mode = { 't', }, silent = true, },
    ['<F9>m'] = { function() M.paste('m', 't') end, 'paste from m', mode = { 't', }, silent = true, },
    ['<F9>n'] = { function() M.paste('n', 't') end, 'paste from n', mode = { 't', }, silent = true, },
    ['<F9>o'] = { function() M.paste('o', 't') end, 'paste from o', mode = { 't', }, silent = true, },
    ['<F9>p'] = { function() M.paste('p', 't') end, 'paste from p', mode = { 't', }, silent = true, },
    ['<F9>q'] = { function() M.paste('q', 't') end, 'paste from q', mode = { 't', }, silent = true, },
    ['<F9>r'] = { function() M.paste('r', 't') end, 'paste from r', mode = { 't', }, silent = true, },
    ['<F9>s'] = { function() M.paste('s', 't') end, 'paste from s', mode = { 't', }, silent = true, },
    ['<F9>t'] = { function() M.paste('t', 't') end, 'paste from t', mode = { 't', }, silent = true, },
    ['<F9>u'] = { function() M.paste('u', 't') end, 'paste from u', mode = { 't', }, silent = true, },
    ['<F9>v'] = { function() M.paste('v', 't') end, 'paste from v', mode = { 't', }, silent = true, },
    ['<F9>w'] = { function() M.paste('w', 't') end, 'paste from w', mode = { 't', }, silent = true, },
    ['<F9>x'] = { function() M.paste('x', 't') end, 'paste from x', mode = { 't', }, silent = true, },
    ['<F9>y'] = { function() M.paste('y', 't') end, 'paste from y', mode = { 't', }, silent = true, },
    ['<F9>z'] = { function() M.paste('z', 't') end, 'paste from z', mode = { 't', }, silent = true, },
    ['<F9>,'] = { function() M.paste(',', 't') end, 'paste from ,', mode = { 't', }, silent = true, },
    ['<F9>.'] = { function() M.paste('.', 't') end, 'paste from .', mode = { 't', }, silent = true, },
    ['<F9>/'] = { function() M.paste('/', 't') end, 'paste from /', mode = { 't', }, silent = true, },
    ['<F9>;'] = { function() M.paste(';', 't') end, 'paste from ;', mode = { 't', }, silent = true, },
    ["<F9>'"] = { function() M.paste("'", 't') end, "paste from '", mode = { 't', }, silent = true, },
    ['<F9>['] = { function() M.paste('[', 't') end, 'paste from [', mode = { 't', }, silent = true, },
    ['<F9>]'] = { function() M.paste(']', 't') end, 'paste from ]', mode = { 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>A'] = { function() M.paste('a', 'n') end, 'paste from a', mode = { 'n', 'v', }, silent = true, },
    ['<F9>B'] = { function() M.paste('b', 'n') end, 'paste from b', mode = { 'n', 'v', }, silent = true, },
    ['<F9>C'] = { function() M.paste('c', 'n') end, 'paste from c', mode = { 'n', 'v', }, silent = true, },
    ['<F9>D'] = { function() M.paste('d', 'n') end, 'paste from d', mode = { 'n', 'v', }, silent = true, },
    ['<F9>E'] = { function() M.paste('e', 'n') end, 'paste from e', mode = { 'n', 'v', }, silent = true, },
    ['<F9>F'] = { function() M.paste('f', 'n') end, 'paste from f', mode = { 'n', 'v', }, silent = true, },
    ['<F9>G'] = { function() M.paste('g', 'n') end, 'paste from g', mode = { 'n', 'v', }, silent = true, },
    ['<F9>H'] = { function() M.paste('h', 'n') end, 'paste from h', mode = { 'n', 'v', }, silent = true, },
    ['<F9>I'] = { function() M.paste('i', 'n') end, 'paste from i', mode = { 'n', 'v', }, silent = true, },
    ['<F9>J'] = { function() M.paste('j', 'n') end, 'paste from j', mode = { 'n', 'v', }, silent = true, },
    ['<F9>K'] = { function() M.paste('k', 'n') end, 'paste from k', mode = { 'n', 'v', }, silent = true, },
    ['<F9>L'] = { function() M.paste('l', 'n') end, 'paste from l', mode = { 'n', 'v', }, silent = true, },
    ['<F9>M'] = { function() M.paste('m', 'n') end, 'paste from m', mode = { 'n', 'v', }, silent = true, },
    ['<F9>N'] = { function() M.paste('n', 'n') end, 'paste from n', mode = { 'n', 'v', }, silent = true, },
    ['<F9>O'] = { function() M.paste('o', 'n') end, 'paste from o', mode = { 'n', 'v', }, silent = true, },
    ['<F9>P'] = { function() M.paste('p', 'n') end, 'paste from p', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Q'] = { function() M.paste('q', 'n') end, 'paste from q', mode = { 'n', 'v', }, silent = true, },
    ['<F9>R'] = { function() M.paste('r', 'n') end, 'paste from r', mode = { 'n', 'v', }, silent = true, },
    ['<F9>S'] = { function() M.paste('s', 'n') end, 'paste from s', mode = { 'n', 'v', }, silent = true, },
    ['<F9>T'] = { function() M.paste('t', 'n') end, 'paste from t', mode = { 'n', 'v', }, silent = true, },
    ['<F9>U'] = { function() M.paste('u', 'n') end, 'paste from u', mode = { 'n', 'v', }, silent = true, },
    ['<F9>V'] = { function() M.paste('v', 'n') end, 'paste from v', mode = { 'n', 'v', }, silent = true, },
    ['<F9>W'] = { function() M.paste('w', 'n') end, 'paste from w', mode = { 'n', 'v', }, silent = true, },
    ['<F9>X'] = { function() M.paste('x', 'n') end, 'paste from x', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Y'] = { function() M.paste('y', 'n') end, 'paste from y', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Z'] = { function() M.paste('z', 'n') end, 'paste from z', mode = { 'n', 'v', }, silent = true, },
    ['<F9><'] = { function() M.paste(',', 'n') end, 'paste from ,', mode = { 'n', 'v', }, silent = true, },
    ['<F9>>'] = { function() M.paste('.', 'n') end, 'paste from .', mode = { 'n', 'v', }, silent = true, },
    ['<F9>?'] = { function() M.paste('/', 'n') end, 'paste from /', mode = { 'n', 'v', }, silent = true, },
    ['<F9>:'] = { function() M.paste(';', 'n') end, 'paste from ;', mode = { 'n', 'v', }, silent = true, },
    ['<F9>"'] = { function() M.paste("'", 'n') end, "paste from '", mode = { 'n', 'v', }, silent = true, },
    ['<F9>{'] = { function() M.paste('[', 'n') end, 'paste from [', mode = { 'n', 'v', }, silent = true, },
    ['<F9>}'] = { function() M.paste(']', 'n') end, 'paste from ]', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><c-s-a>'] = { function() M.delete 'a' end, 'delete from a', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-b>'] = { function() M.delete 'b' end, 'delete from b', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-c>'] = { function() M.delete 'c' end, 'delete from c', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-d>'] = { function() M.delete 'd' end, 'delete from d', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-e>'] = { function() M.delete 'e' end, 'delete from e', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-f>'] = { function() M.delete 'f' end, 'delete from f', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-g>'] = { function() M.delete 'g' end, 'delete from g', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-h>'] = { function() M.delete 'h' end, 'delete from h', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-i>'] = { function() M.delete 'i' end, 'delete from i', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-j>'] = { function() M.delete 'j' end, 'delete from j', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-k>'] = { function() M.delete 'k' end, 'delete from k', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-l>'] = { function() M.delete 'l' end, 'delete from l', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-m>'] = { function() M.delete 'm' end, 'delete from m', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-n>'] = { function() M.delete 'n' end, 'delete from n', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-o>'] = { function() M.delete 'o' end, 'delete from o', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-p>'] = { function() M.delete 'p' end, 'delete from p', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-q>'] = { function() M.delete 'q' end, 'delete from q', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-r>'] = { function() M.delete 'r' end, 'delete from r', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-s>'] = { function() M.delete 's' end, 'delete from s', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-t>'] = { function() M.delete 't' end, 'delete from t', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-u>'] = { function() M.delete 'u' end, 'delete from u', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-v>'] = { function() M.delete 'v' end, 'delete from v', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-w>'] = { function() M.delete 'w' end, 'delete from w', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-x>'] = { function() M.delete 'x' end, 'delete from x', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-y>'] = { function() M.delete 'y' end, 'delete from y', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-z>'] = { function() M.delete 'z' end, 'delete from z', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-,>'] = { function() M.delete ',' end, 'delete from ,', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-.>'] = { function() M.delete '.' end, 'delete from .', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-/>'] = { function() M.delete '/' end, 'delete from /', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-;>'] = { function() M.delete ';' end, 'delete from ;', mode = { 'n', 'v', }, silent = true, },
    ["<F9><c-s-'>"] = { function() M.delete "'" end, "delete from '", mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-[>'] = { function() M.delete '[' end, 'delete from [', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-]>'] = { function() M.delete ']' end, 'delete from ]', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F1>'] = { name = '+my.yank.clipboard', },
    ['<F9><F1>a'] = { function() M.clipboard 'a' end, 'a to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>b'] = { function() M.clipboard 'b' end, 'b to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>c'] = { function() M.clipboard 'c' end, 'c to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>d'] = { function() M.clipboard 'd' end, 'd to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>e'] = { function() M.clipboard 'e' end, 'e to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>f'] = { function() M.clipboard 'f' end, 'f to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>g'] = { function() M.clipboard 'g' end, 'g to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>h'] = { function() M.clipboard 'h' end, 'h to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>i'] = { function() M.clipboard 'i' end, 'i to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>j'] = { function() M.clipboard 'j' end, 'j to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>k'] = { function() M.clipboard 'k' end, 'k to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>l'] = { function() M.clipboard 'l' end, 'l to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>m'] = { function() M.clipboard 'm' end, 'm to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>n'] = { function() M.clipboard 'n' end, 'n to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>o'] = { function() M.clipboard 'o' end, 'o to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>p'] = { function() M.clipboard 'p' end, 'p to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>q'] = { function() M.clipboard 'q' end, 'q to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>r'] = { function() M.clipboard 'r' end, 'r to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>s'] = { function() M.clipboard 's' end, 's to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>t'] = { function() M.clipboard 't' end, 't to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>u'] = { function() M.clipboard 'u' end, 'u to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>v'] = { function() M.clipboard 'v' end, 'v to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>w'] = { function() M.clipboard 'w' end, 'w to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>x'] = { function() M.clipboard 'x' end, 'x to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>y'] = { function() M.clipboard 'y' end, 'y to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>z'] = { function() M.clipboard 'z' end, 'z to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>,'] = { function() M.clipboard ',' end, ', to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>.'] = { function() M.clipboard '.' end, '. to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>/'] = { function() M.clipboard '/' end, '/ to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>;'] = { function() M.clipboard ';' end, '; to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ["<F9><F1>'"] = { function() M.clipboard "'" end, "' to clipboard", mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>['] = { function() M.clipboard '[' end, '[ to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>]'] = { function() M.clipboard ']' end, '] to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F2>'] = { function() M.stack('n', 'w') end, 'yank <cword> to pool', mode = { 'n', }, silent = true, },
    ['<F9><F3>'] = { function() M.stack('n', 'W') end, 'yank <cWORD> to pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F2>'] = { function() M.stack('v', 'w') end, 'yank <cword> to pool', mode = { 'v', }, silent = true, },
    ['<F9><F3>'] = { function() M.stack('v', 'W') end, 'yank <cWORD> to pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() M.paste_from_stack 'n' end, 'sel paste from pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() M.paste_from_stack 'v' end, 'sel paste from pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() M.paste_from_stack 'i' end, 'sel paste from pool', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() M.paste_from_stack 'c' end, 'sel paste from pool', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() M.paste_from_stack 't' end, 'sel paste from pool', mode = { 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F1><F1>'] = { function() M.clipboard_from_pool() end, 'sel from pool to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><c-F4>'] = { function() M.delete_pool() end, 'delete pool', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
end

L(M, M.map)

return M
