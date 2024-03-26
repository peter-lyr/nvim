-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 10:20:04 星期六

--[[
┌────────────┬────────┬─────────────────────┬─────────────┬─────╮
│  reg       │  pool  │  clipboard_history  │  clipboard  │  "  │
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

function M.show_yank_reg()
  local info = { tostring(#vim.tbl_keys(M.yank_reg)) .. ' item(s) yank reg', }
  for key, _ in pairs(M.yank_reg) do
    local content = M.yank_reg[key]
    info[#info + 1] = string.format('%s[[%d]]: %s', key, #content, M.get_short(content))
  end
  B.notify_info(info)
end

function M.yank_to_reg(reg, mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  M.yank_reg[reg] = vim.fn.getreg '"'
  M.show_yank_reg()
end

function M.paste_from_reg(reg, mode)
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

function M.show_clipboard_history()
  local info = { tostring(#vim.tbl_keys(M.clipboard_history)) .. ' item(s) clipboard history', }
  for idx, content in ipairs(M.clipboard_history) do
    info[#info + 1] = string.format('%d[[%d]]: %s', idx, #content, M.get_short(content))
  end
  B.notify_info(info)
end

-----------------------------------------------------------------------

function M.show_yank_pool()
  local info = { tostring(#M.yank_pool) .. ' item(s) yank pool', }
  for c, content in ipairs(M.yank_pool) do
    info[#info + 1] = string.format('%2s. [[%d]]: %s', c, #content, M.get_short(content))
  end
  B.notify_info(info)
end

function M.yank_to_pool(mode, word)
  if mode == 'n' then
    B.cmd('norm vi%s', word)
  end
  vim.cmd 'norm y'
  B.stack_item_uniq(M.yank_pool, vim.fn.getreg '"')
  M.show_yank_pool()
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

function M.pool_to_clipboard()
  local pool = {}
  for _, t in ipairs(M.yank_pool) do
    pool[#pool + 1] = string.gsub(M.get_short(t), '\n', '\\n')
  end
  B.ui_sel(pool, 'sel from yank pool to clipboard', function(_, idx)
    local text = M.yank_pool[idx]
    if B.is(text) then
      vim.fn.setreg('+', text)
    end
  end)
end

function M.history_to_clipboard()
  local pool = {}
  for _, t in ipairs(M.clipboard_history) do
    pool[#pool + 1] = string.gsub(M.get_short(t), '\n', '\\n')
  end
  B.ui_sel(pool, 'sel from clipboard history to clipboard', function(_, idx)
    local text = M.clipboard_history[idx]
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

function M.map_yank_to_reg()
  -- yank to reg
  require 'which-key'.register {
    ['<F9>']      = { name = 'yank', },
    ['<F9>q']  = { function() M.show_yank_reg() end, 'show_yank_reg', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9>a']     = { function() M.yank_to_reg('a', 'n', 'w') end, 'yank <cword> to reg a', mode = { 'n', }, silent = true, },
    ['<F9>c']     = { function() M.yank_to_reg('c', 'n', 'w') end, 'yank <cword> to reg c', mode = { 'n', }, silent = true, },
    ['<F9>d']     = { function() M.yank_to_reg('d', 'n', 'w') end, 'yank <cword> to reg d', mode = { 'n', }, silent = true, },
    ['<F9>f']     = { function() M.yank_to_reg('f', 'n', 'w') end, 'yank <cword> to reg f', mode = { 'n', }, silent = true, },
    ['<F9>s']     = { function() M.yank_to_reg('s', 'n', 'w') end, 'yank <cword> to reg s', mode = { 'n', }, silent = true, },
    ['<F9>v']     = { function() M.yank_to_reg('v', 'n', 'w') end, 'yank <cword> to reg v', mode = { 'n', }, silent = true, },
    ['<F9>x']     = { function() M.yank_to_reg('x', 'n', 'w') end, 'yank <cword> to reg x', mode = { 'n', }, silent = true, },
    ['<F9>z']     = { function() M.yank_to_reg('z', 'n', 'w') end, 'yank <cword> to reg z', mode = { 'n', }, silent = true, },
    ['<F9><a-a>'] = { function() M.yank_to_reg('a', 'n', 'W') end, 'yank <cWORD> to reg a', mode = { 'n', }, silent = true, },
    ['<F9><a-c>'] = { function() M.yank_to_reg('c', 'n', 'W') end, 'yank <cWORD> to reg c', mode = { 'n', }, silent = true, },
    ['<F9><a-d>'] = { function() M.yank_to_reg('d', 'n', 'W') end, 'yank <cWORD> to reg d', mode = { 'n', }, silent = true, },
    ['<F9><a-f>'] = { function() M.yank_to_reg('f', 'n', 'W') end, 'yank <cWORD> to reg f', mode = { 'n', }, silent = true, },
    ['<F9><a-s>'] = { function() M.yank_to_reg('s', 'n', 'W') end, 'yank <cWORD> to reg s', mode = { 'n', }, silent = true, },
    ['<F9><a-v>'] = { function() M.yank_to_reg('v', 'n', 'W') end, 'yank <cWORD> to reg v', mode = { 'n', }, silent = true, },
    ['<F9><a-x>'] = { function() M.yank_to_reg('x', 'n', 'W') end, 'yank <cWORD> to reg x', mode = { 'n', }, silent = true, },
    ['<F9><a-z>'] = { function() M.yank_to_reg('z', 'n', 'W') end, 'yank <cWORD> to reg z', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.yank_to_reg('a', 'v') end, 'yank to reg a', mode = { 'v', }, silent = true, },
    ['<F9>c'] = { function() M.yank_to_reg('c', 'v') end, 'yank to reg c', mode = { 'v', }, silent = true, },
    ['<F9>d'] = { function() M.yank_to_reg('d', 'v') end, 'yank to reg d', mode = { 'v', }, silent = true, },
    ['<F9>f'] = { function() M.yank_to_reg('f', 'v') end, 'yank to reg f', mode = { 'v', }, silent = true, },
    ['<F9>s'] = { function() M.yank_to_reg('s', 'v') end, 'yank to reg s', mode = { 'v', }, silent = true, },
    ['<F9>v'] = { function() M.yank_to_reg('v', 'v') end, 'yank to reg v', mode = { 'v', }, silent = true, },
    ['<F9>x'] = { function() M.yank_to_reg('x', 'v') end, 'yank to reg x', mode = { 'v', }, silent = true, },
    ['<F9>z'] = { function() M.yank_to_reg('z', 'v') end, 'yank to reg z', mode = { 'v', }, silent = true, },
  }
end

function M.map_yank_to_pool()
  -- yank to pool
  require 'which-key'.register {
    ['<F9>w']  = { function() M.show_yank_pool() end, 'show_yank_pool', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9>i'] = { function() M.yank_to_pool('n', 'w') end, 'yank <cword> to pool', mode = { 'n', }, silent = true, },
    ['<F9>o'] = { function() M.yank_to_pool('n', 'W') end, 'yank <cWORD> to pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>i'] = { function() M.yank_to_pool('v', 'w') end, 'yank <cword> to pool', mode = { 'v', }, silent = true, },
    ['<F9>o'] = { function() M.yank_to_pool('v', 'W') end, 'yank <cWORD> to pool', mode = { 'v', }, silent = true, },
  }
end

function M.map_yank_reg_pool_to_clipboard()
  -- yank_reg/pool to clipboard
  require 'which-key'.register {
    ['<F9><leader>'] = { name = 'yank_reg/pool to clipboard', },
    ['<F9><leader>a'] = { function() M.yank_reg_to_clipboard 'a' end, 'reg a to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>c'] = { function() M.yank_reg_to_clipboard 'c' end, 'reg c to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>d'] = { function() M.yank_reg_to_clipboard 'd' end, 'reg d to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>f'] = { function() M.yank_reg_to_clipboard 'f' end, 'reg f to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>s'] = { function() M.yank_reg_to_clipboard 's' end, 'reg s to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>v'] = { function() M.yank_reg_to_clipboard 'v' end, 'reg v to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>x'] = { function() M.yank_reg_to_clipboard 'x' end, 'reg x to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>z'] = { function() M.yank_reg_to_clipboard 'z' end, 'reg z to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>p'] = { function() M.pool_to_clipboard() end, 'pool to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><leader>h'] = { function() M.history_to_clipboard() end, 'clipboard history to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
end

function M.map_paste_from_reg()
  -- paste from reg
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste_from_reg('a', 'i') end, 'paste from reg a', mode = { 'i', }, silent = true, },
    ['<F9>c'] = { function() M.paste_from_reg('c', 'i') end, 'paste from reg c', mode = { 'i', }, silent = true, },
    ['<F9>d'] = { function() M.paste_from_reg('d', 'i') end, 'paste from reg d', mode = { 'i', }, silent = true, },
    ['<F9>f'] = { function() M.paste_from_reg('f', 'i') end, 'paste from reg f', mode = { 'i', }, silent = true, },
    ['<F9>s'] = { function() M.paste_from_reg('s', 'i') end, 'paste from reg s', mode = { 'i', }, silent = true, },
    ['<F9>v'] = { function() M.paste_from_reg('v', 'i') end, 'paste from reg v', mode = { 'i', }, silent = true, },
    ['<F9>x'] = { function() M.paste_from_reg('x', 'i') end, 'paste from reg x', mode = { 'i', }, silent = true, },
    ['<F9>z'] = { function() M.paste_from_reg('z', 'i') end, 'paste from reg z', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste_from_reg('a', 'c') end, 'paste from reg a', mode = { 'c', }, silent = true, },
    ['<F9>c'] = { function() M.paste_from_reg('c', 'c') end, 'paste from reg c', mode = { 'c', }, silent = true, },
    ['<F9>d'] = { function() M.paste_from_reg('d', 'c') end, 'paste from reg d', mode = { 'c', }, silent = true, },
    ['<F9>f'] = { function() M.paste_from_reg('f', 'c') end, 'paste from reg f', mode = { 'c', }, silent = true, },
    ['<F9>s'] = { function() M.paste_from_reg('s', 'c') end, 'paste from reg s', mode = { 'c', }, silent = true, },
    ['<F9>v'] = { function() M.paste_from_reg('v', 'c') end, 'paste from reg v', mode = { 'c', }, silent = true, },
    ['<F9>x'] = { function() M.paste_from_reg('x', 'c') end, 'paste from reg x', mode = { 'c', }, silent = true, },
    ['<F9>z'] = { function() M.paste_from_reg('z', 'c') end, 'paste from reg z', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() M.paste_from_reg('a', 't') end, 'paste from reg a', mode = { 't', }, silent = true, },
    ['<F9>c'] = { function() M.paste_from_reg('c', 't') end, 'paste from reg c', mode = { 't', }, silent = true, },
    ['<F9>d'] = { function() M.paste_from_reg('d', 't') end, 'paste from reg d', mode = { 't', }, silent = true, },
    ['<F9>f'] = { function() M.paste_from_reg('f', 't') end, 'paste from reg f', mode = { 't', }, silent = true, },
    ['<F9>s'] = { function() M.paste_from_reg('s', 't') end, 'paste from reg s', mode = { 't', }, silent = true, },
    ['<F9>v'] = { function() M.paste_from_reg('v', 't') end, 'paste from reg v', mode = { 't', }, silent = true, },
    ['<F9>x'] = { function() M.paste_from_reg('x', 't') end, 'paste from reg x', mode = { 't', }, silent = true, },
    ['<F9>z'] = { function() M.paste_from_reg('z', 't') end, 'paste from reg z', mode = { 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>A'] = { function() M.paste_from_reg('a', 'n') end, 'paste from reg a', mode = { 'n', 'v', }, silent = true, },
    ['<F9>C'] = { function() M.paste_from_reg('c', 'n') end, 'paste from reg c', mode = { 'n', 'v', }, silent = true, },
    ['<F9>D'] = { function() M.paste_from_reg('d', 'n') end, 'paste from reg d', mode = { 'n', 'v', }, silent = true, },
    ['<F9>F'] = { function() M.paste_from_reg('f', 'n') end, 'paste from reg f', mode = { 'n', 'v', }, silent = true, },
    ['<F9>S'] = { function() M.paste_from_reg('s', 'n') end, 'paste from reg s', mode = { 'n', 'v', }, silent = true, },
    ['<F9>V'] = { function() M.paste_from_reg('v', 'n') end, 'paste from reg v', mode = { 'n', 'v', }, silent = true, },
    ['<F9>X'] = { function() M.paste_from_reg('x', 'n') end, 'paste from reg x', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Z'] = { function() M.paste_from_reg('z', 'n') end, 'paste from reg z', mode = { 'n', 'v', }, silent = true, },
  }
end

function M.map_paste_from_pool()
  -- paste from pool
  require 'which-key'.register {
    ['<F9>p'] = { function() M.paste_from_yank_pool 'n' end, 'paste from pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>p'] = { function() M.paste_from_yank_pool 'v' end, 'paste from pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>p'] = { function() M.paste_from_yank_pool 'i' end, 'paste from pool', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>p'] = { function() M.paste_from_yank_pool 'c' end, 'paste from pool', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>p'] = { function() M.paste_from_yank_pool 't' end, 'paste from pool', mode = { 't', }, silent = true, },
  }
end

function M.map_paste_from_clipboard_history()
  -- paste from clipboard_history
  require 'which-key'.register {
    ['<F9>e']  = { function() M.show_clipboard_history() end, 'show_clipboard_history', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9>h'] = { function() M.paste_from_clipboard_history 'n' end, 'paste from clipboard_history', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>h'] = { function() M.paste_from_clipboard_history 'v' end, 'paste from clipboard_history', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>h'] = { function() M.paste_from_clipboard_history 'i' end, 'paste from clipboard_history', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>h'] = { function() M.paste_from_clipboard_history 'c' end, 'paste from clipboard_history', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>h'] = { function() M.paste_from_clipboard_history 't' end, 'paste from clipboard_history', mode = { 't', }, silent = true, },
  }
end

function M.map()
  M.map_yank_to_reg()
  M.map_yank_to_pool()
  M.map_yank_reg_pool_to_clipboard()
  M.map_paste_from_reg()
  M.map_paste_from_pool()
  M.map_paste_from_clipboard_history()
end

L(M, M.map)

return M
