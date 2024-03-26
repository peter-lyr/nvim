-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 10:20:04 星期六

--[[
┌────────────┬────────┬─────────────────────┬─────────────┬─────╮
│  reg       │  pool  │  clipboard history  │  clipboard  │  "  │
│  a,s,d,f,  │        │                     │             │     │
│  z,x,c,v,  │        │                     │             │     │
├────────────┴────────┴─────────────────────┴─────────────┼─────┤
│                     paste                                     │
└───────────────────────────────────────────────────────────────╯
]]

local M = {}

local B = require 'base'

M.yank_dir_path = B.getcreate_stddata_dirpath 'yank'
M.yank_reg_txt_path = M.yank_dir_path:joinpath 'yank-reg.txt'
M.clipboard_history_txt_path = M.yank_dir_path:joinpath 'clipboard-history.txt'
M.yank_pool_txt_path = M.yank_dir_path:joinpath 'yank-pool.txt'

if not M.yank_reg_txt_path:exists() then
  M.yank_reg_txt_path:write(vim.inspect {}, 'w')
end

if not M.clipboard_history_txt_path:exists() then
  M.clipboard_history_txt_path:write(vim.inspect {}, 'w')
end

if not M.yank_pool_txt_path:exists() then
  M.yank_pool_txt_path:write(vim.inspect {}, 'w')
end

M.yank_reg = B.read_table_from_file(M.yank_reg_txt_path.filename)
M.clipboard_history = B.read_table_from_file(M.clipboard_history_txt_path.filename)
M.yank_pool = B.read_table_from_file(M.yank_pool_txt_path.filename)

B.aucmd({ 'VimLeave', }, 'yank.vimleave', {
  callback = function()
    M.yank_reg_txt_path:write(vim.inspect(M.yank_reg), 'w')
    M.yank_pool_txt_path:write(vim.inspect(M.yank_pool), 'w')
    M.clipboard_history_txt_path:write(vim.inspect(M.clipboard_history), 'w')
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
  local info = { tostring(#vim.tbl_keys(M.yank_reg)) .. ' reg(s)', }
  for key, _ in pairs(M.yank_reg) do
    local content = M.yank_reg[key]
    info[#info + 1] = string.format('%s[[%d]]: %s', key, #content, M.get_short(content))
  end
  B.notify_info(info)
end

function M.yank(reg, mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  M.yank_reg[reg] = vim.fn.getreg '"'
  M.reg_show()
end

function M.paste(reg, mode)
  local back = vim.fn.getreg '"'
  vim.fn.setreg('"', M.yank_reg[reg])
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

function M.yank_reg_to_clipboard(reg)
  if M.yank_reg[reg] then
    vim.fn.setreg('+', M.yank_reg[reg])
  end
end

-----------------------------------------------------------------------

function M.pool_show()
  local info = { tostring(#M.yank_pool) .. ' item(s)', }
  for c, content in ipairs(M.yank_pool) do
    info[#info + 1] = string.format('%2s. [[%d]]: %s', c, #content, M.get_short(content))
  end
  B.notify_info(info)
end

function M.stack(mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  B.stack_item_uniq(M.yank_pool, vim.fn.getreg '"')
  M.pool_show()
end

function M.paste_from_stack_do(pool, mode)
  B.ui_sel(pool, 'sel paste from pool', function(_, idx)
    local text = M.yank_pool[idx]
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

function M.paste_from_yank_pool(mode)
  local pool = {}
  for _, t in ipairs(M.yank_pool) do
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

function M.paste_from_clipboard_history_do(clipboard_history, mode)
  B.ui_sel(clipboard_history, 'sel paste from clipboard_history', function(_, idx)
    local text = M.clipboard_history[idx]
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

function M.paste_from_clipboard_history(mode)
  local clipboard_history = {}
  for _, t in ipairs(M.clipboard_history) do
    clipboard_history[#clipboard_history + 1] = string.gsub(M.get_short(t), '\n', '\\n')
  end
  if mode == 't' then
    vim.cmd [[call feedkeys("\<c-\>\<c-n>")]]
    B.set_timeout(100, function()
      M.paste_from_clipboard_history_do(clipboard_history, mode)
    end)
  else
    M.paste_from_clipboard_history_do(clipboard_history, mode)
  end
end

function M.clipboard_from_pool()
  local pool = {}
  for _, t in ipairs(M.yank_pool) do
    pool[#pool + 1] = string.gsub(M.get_short(t), '\n', '\\n')
  end
  B.ui_sel(pool, 'sel to +', function(_, idx)
    local text = M.yank_pool[idx]
    if B.is(text) then
      vim.fn.setreg('+', text)
    end
  end)
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
  local text = vim.fn.getreg '+'
  if B.is(text) then
    B.stack_item_uniq(M.clipboard_history, text)
  end
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
    ['<F9>c']     = { function() M.yank('c', 'n', 'w') end, '<cword> to c', mode = { 'n', }, silent = true, },
    ['<F9>d']     = { function() M.yank('d', 'n', 'w') end, '<cword> to d', mode = { 'n', }, silent = true, },
    ['<F9>f']     = { function() M.yank('f', 'n', 'w') end, '<cword> to f', mode = { 'n', }, silent = true, },
    ['<F9>s']     = { function() M.yank('s', 'n', 'w') end, '<cword> to s', mode = { 'n', }, silent = true, },
    ['<F9>v']     = { function() M.yank('v', 'n', 'w') end, '<cword> to v', mode = { 'n', }, silent = true, },
    ['<F9>x']     = { function() M.yank('x', 'n', 'w') end, '<cword> to x', mode = { 'n', }, silent = true, },
    ['<F9>z']     = { function() M.yank('z', 'n', 'w') end, '<cword> to z', mode = { 'n', }, silent = true, },
    ['<F9><a-a>'] = { function() M.yank('a', 'n', 'W') end, '<cWORD> to a', mode = { 'n', }, silent = true, },
    ['<F9><a-c>'] = { function() M.yank('c', 'n', 'W') end, '<cWORD> to c', mode = { 'n', }, silent = true, },
    ['<F9><a-d>'] = { function() M.yank('d', 'n', 'W') end, '<cWORD> to d', mode = { 'n', }, silent = true, },
    ['<F9><a-f>'] = { function() M.yank('f', 'n', 'W') end, '<cWORD> to f', mode = { 'n', }, silent = true, },
    ['<F9><a-s>'] = { function() M.yank('s', 'n', 'W') end, '<cWORD> to s', mode = { 'n', }, silent = true, },
    ['<F9><a-v>'] = { function() M.yank('v', 'n', 'W') end, '<cWORD> to v', mode = { 'n', }, silent = true, },
    ['<F9><a-x>'] = { function() M.yank('x', 'n', 'W') end, '<cWORD> to x', mode = { 'n', }, silent = true, },
    ['<F9><a-z>'] = { function() M.yank('z', 'n', 'W') end, '<cWORD> to z', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.yank('a', 'v') end, 'sel to a', mode = { 'v', }, silent = true, },
    ['<F9>c'] = { function() M.yank('c', 'v') end, 'sel to c', mode = { 'v', }, silent = true, },
    ['<F9>d'] = { function() M.yank('d', 'v') end, 'sel to d', mode = { 'v', }, silent = true, },
    ['<F9>f'] = { function() M.yank('f', 'v') end, 'sel to f', mode = { 'v', }, silent = true, },
    ['<F9>s'] = { function() M.yank('s', 'v') end, 'sel to s', mode = { 'v', }, silent = true, },
    ['<F9>v'] = { function() M.yank('v', 'v') end, 'sel to v', mode = { 'v', }, silent = true, },
    ['<F9>x'] = { function() M.yank('x', 'v') end, 'sel to x', mode = { 'v', }, silent = true, },
    ['<F9>z'] = { function() M.yank('z', 'v') end, 'sel to z', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste('a', 'i') end, 'paste from a', mode = { 'i', }, silent = true, },
    ['<F9>c'] = { function() M.paste('c', 'i') end, 'paste from c', mode = { 'i', }, silent = true, },
    ['<F9>d'] = { function() M.paste('d', 'i') end, 'paste from d', mode = { 'i', }, silent = true, },
    ['<F9>f'] = { function() M.paste('f', 'i') end, 'paste from f', mode = { 'i', }, silent = true, },
    ['<F9>s'] = { function() M.paste('s', 'i') end, 'paste from s', mode = { 'i', }, silent = true, },
    ['<F9>v'] = { function() M.paste('v', 'i') end, 'paste from v', mode = { 'i', }, silent = true, },
    ['<F9>x'] = { function() M.paste('x', 'i') end, 'paste from x', mode = { 'i', }, silent = true, },
    ['<F9>z'] = { function() M.paste('z', 'i') end, 'paste from z', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste('a', 'c') end, 'paste from a', mode = { 'c', }, silent = true, },
    ['<F9>c'] = { function() M.paste('c', 'c') end, 'paste from c', mode = { 'c', }, silent = true, },
    ['<F9>d'] = { function() M.paste('d', 'c') end, 'paste from d', mode = { 'c', }, silent = true, },
    ['<F9>f'] = { function() M.paste('f', 'c') end, 'paste from f', mode = { 'c', }, silent = true, },
    ['<F9>s'] = { function() M.paste('s', 'c') end, 'paste from s', mode = { 'c', }, silent = true, },
    ['<F9>v'] = { function() M.paste('v', 'c') end, 'paste from v', mode = { 'c', }, silent = true, },
    ['<F9>x'] = { function() M.paste('x', 'c') end, 'paste from x', mode = { 'c', }, silent = true, },
    ['<F9>z'] = { function() M.paste('z', 'c') end, 'paste from z', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste('a', 't') end, 'paste from a', mode = { 't', }, silent = true, },
    ['<F9>c'] = { function() M.paste('c', 't') end, 'paste from c', mode = { 't', }, silent = true, },
    ['<F9>d'] = { function() M.paste('d', 't') end, 'paste from d', mode = { 't', }, silent = true, },
    ['<F9>f'] = { function() M.paste('f', 't') end, 'paste from f', mode = { 't', }, silent = true, },
    ['<F9>s'] = { function() M.paste('s', 't') end, 'paste from s', mode = { 't', }, silent = true, },
    ['<F9>v'] = { function() M.paste('v', 't') end, 'paste from v', mode = { 't', }, silent = true, },
    ['<F9>x'] = { function() M.paste('x', 't') end, 'paste from x', mode = { 't', }, silent = true, },
    ['<F9>z'] = { function() M.paste('z', 't') end, 'paste from z', mode = { 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>A'] = { function() M.paste('a', 'n') end, 'paste from a', mode = { 'n', 'v', }, silent = true, },
    ['<F9>C'] = { function() M.paste('c', 'n') end, 'paste from c', mode = { 'n', 'v', }, silent = true, },
    ['<F9>D'] = { function() M.paste('d', 'n') end, 'paste from d', mode = { 'n', 'v', }, silent = true, },
    ['<F9>F'] = { function() M.paste('f', 'n') end, 'paste from f', mode = { 'n', 'v', }, silent = true, },
    ['<F9>S'] = { function() M.paste('s', 'n') end, 'paste from s', mode = { 'n', 'v', }, silent = true, },
    ['<F9>V'] = { function() M.paste('v', 'n') end, 'paste from v', mode = { 'n', 'v', }, silent = true, },
    ['<F9>X'] = { function() M.paste('x', 'n') end, 'paste from x', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Z'] = { function() M.paste('z', 'n') end, 'paste from z', mode = { 'n', 'v', }, silent = true, },
  }
  -- yank_reg to clipboard
  require 'which-key'.register {
    ['<F9><leader>'] = { name = 'yank_reg to clipboard', },
    ['<F9><leader>a'] = { function() M.yank_reg_to_clipboard 'a' end, 'reg a to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>c'] = { function() M.yank_reg_to_clipboard 'c' end, 'reg c to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>d'] = { function() M.yank_reg_to_clipboard 'd' end, 'reg d to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>f'] = { function() M.yank_reg_to_clipboard 'f' end, 'reg f to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>s'] = { function() M.yank_reg_to_clipboard 's' end, 'reg s to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>v'] = { function() M.yank_reg_to_clipboard 'v' end, 'reg v to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>x'] = { function() M.yank_reg_to_clipboard 'x' end, 'reg x to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>z'] = { function() M.yank_reg_to_clipboard 'z' end, 'reg z to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader><leader>'] = { function() M.clipboard_from_pool() end, 'sel from pool to system clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  -- pool
  require 'which-key'.register {
    ['<F9>,'] = { function() M.stack('n', 'w') end, '<cword> to pool', mode = { 'n', }, silent = true, },
    ['<F9>.'] = { function() M.stack('n', 'W') end, '<cWORD> to pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>,'] = { function() M.stack('v', 'w') end, '<cword> to pool', mode = { 'v', }, silent = true, },
    ['<F9>.'] = { function() M.stack('v', 'W') end, '<cWORD> to pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>/'] = { function() M.paste_from_yank_pool 'n' end, 'paste from yank_pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>/'] = { function() M.paste_from_yank_pool 'v' end, 'paste from yank_pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>/'] = { function() M.paste_from_yank_pool 'i' end, 'paste from yank_pool', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>/'] = { function() M.paste_from_yank_pool 'c' end, 'paste from yank_pool', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>/'] = { function() M.paste_from_yank_pool 't' end, 'paste from yank_pool', mode = { 't', }, silent = true, },
  }
  -- from clipboard
  require 'which-key'.register {
    ['<F9>;'] = { function() M.paste_from_clipboard_history 'n' end, 'paste from clipboard_history', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>;'] = { function() M.paste_from_clipboard_history 'v' end, 'paste from clipboard_history', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>;'] = { function() M.paste_from_clipboard_history 'i' end, 'paste from clipboard_history', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>;'] = { function() M.paste_from_clipboard_history 'c' end, 'paste from clipboard_history', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>;'] = { function() M.paste_from_clipboard_history 't' end, 'paste from clipboard_history', mode = { 't', }, silent = true, },
  }
end

L(M, M.map)

return M
