-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 20:10:17 星期六

local M = {}

function M.base()
  TimingBegin()
  require 'which-key'.register {
    ['<c-;>'] = { function()
      local B = require 'base'
      if not B.commands then
        B.create_user_command_with_M(BaseCommand())
      end
      B.all_commands()
    end, 'base: all commands', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M._m(items)
  for _, item in ipairs(items) do
    local lhs = table.remove(item, 1)
    if not item['name'] then
      item[#item + 1] = item['desc']
    end
    require 'which-key'.register { [lhs] = item, }
  end
end

function M.yank()
  TimingBegin()
  require 'which-key'.register {
    ['<F9>']      = { name = 'my.yank', },
    ['<F9><F9>']  = { function() require 'config.my.yank'.reg_show() end, 'show all', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9>a']     = { function() require 'config.my.yank'.yank('a', 'n', 'w') end, '<cword> to a', mode = { 'n', }, silent = true, },
    ['<F9>b']     = { function() require 'config.my.yank'.yank('b', 'n', 'w') end, '<cword> to b', mode = { 'n', }, silent = true, },
    ['<F9>c']     = { function() require 'config.my.yank'.yank('c', 'n', 'w') end, '<cword> to c', mode = { 'n', }, silent = true, },
    ['<F9>d']     = { function() require 'config.my.yank'.yank('d', 'n', 'w') end, '<cword> to d', mode = { 'n', }, silent = true, },
    ['<F9>e']     = { function() require 'config.my.yank'.yank('e', 'n', 'w') end, '<cword> to e', mode = { 'n', }, silent = true, },
    ['<F9>f']     = { function() require 'config.my.yank'.yank('f', 'n', 'w') end, '<cword> to f', mode = { 'n', }, silent = true, },
    ['<F9>g']     = { function() require 'config.my.yank'.yank('g', 'n', 'w') end, '<cword> to g', mode = { 'n', }, silent = true, },
    ['<F9>h']     = { function() require 'config.my.yank'.yank('h', 'n', 'w') end, '<cword> to h', mode = { 'n', }, silent = true, },
    ['<F9>i']     = { function() require 'config.my.yank'.yank('i', 'n', 'w') end, '<cword> to i', mode = { 'n', }, silent = true, },
    ['<F9>j']     = { function() require 'config.my.yank'.yank('j', 'n', 'w') end, '<cword> to j', mode = { 'n', }, silent = true, },
    ['<F9>k']     = { function() require 'config.my.yank'.yank('k', 'n', 'w') end, '<cword> to k', mode = { 'n', }, silent = true, },
    ['<F9>l']     = { function() require 'config.my.yank'.yank('l', 'n', 'w') end, '<cword> to l', mode = { 'n', }, silent = true, },
    ['<F9>m']     = { function() require 'config.my.yank'.yank('m', 'n', 'w') end, '<cword> to m', mode = { 'n', }, silent = true, },
    ['<F9>n']     = { function() require 'config.my.yank'.yank('n', 'n', 'w') end, '<cword> to n', mode = { 'n', }, silent = true, },
    ['<F9>o']     = { function() require 'config.my.yank'.yank('o', 'n', 'w') end, '<cword> to o', mode = { 'n', }, silent = true, },
    ['<F9>p']     = { function() require 'config.my.yank'.yank('p', 'n', 'w') end, '<cword> to p', mode = { 'n', }, silent = true, },
    ['<F9>q']     = { function() require 'config.my.yank'.yank('q', 'n', 'w') end, '<cword> to q', mode = { 'n', }, silent = true, },
    ['<F9>r']     = { function() require 'config.my.yank'.yank('r', 'n', 'w') end, '<cword> to r', mode = { 'n', }, silent = true, },
    ['<F9>s']     = { function() require 'config.my.yank'.yank('s', 'n', 'w') end, '<cword> to s', mode = { 'n', }, silent = true, },
    ['<F9>t']     = { function() require 'config.my.yank'.yank('t', 'n', 'w') end, '<cword> to t', mode = { 'n', }, silent = true, },
    ['<F9>u']     = { function() require 'config.my.yank'.yank('u', 'n', 'w') end, '<cword> to u', mode = { 'n', }, silent = true, },
    ['<F9>v']     = { function() require 'config.my.yank'.yank('v', 'n', 'w') end, '<cword> to v', mode = { 'n', }, silent = true, },
    ['<F9>w']     = { function() require 'config.my.yank'.yank('w', 'n', 'w') end, '<cword> to w', mode = { 'n', }, silent = true, },
    ['<F9>x']     = { function() require 'config.my.yank'.yank('x', 'n', 'w') end, '<cword> to x', mode = { 'n', }, silent = true, },
    ['<F9>y']     = { function() require 'config.my.yank'.yank('y', 'n', 'w') end, '<cword> to y', mode = { 'n', }, silent = true, },
    ['<F9>z']     = { function() require 'config.my.yank'.yank('z', 'n', 'w') end, '<cword> to z', mode = { 'n', }, silent = true, },
    ['<F9>,']     = { function() require 'config.my.yank'.yank(',', 'n', 'w') end, '<cword> to ,', mode = { 'n', }, silent = true, },
    ['<F9>.']     = { function() require 'config.my.yank'.yank('.', 'n', 'w') end, '<cword> to .', mode = { 'n', }, silent = true, },
    ['<F9>/']     = { function() require 'config.my.yank'.yank('/', 'n', 'w') end, '<cword> to /', mode = { 'n', }, silent = true, },
    ['<F9>;']     = { function() require 'config.my.yank'.yank(';', 'n', 'w') end, '<cword> to ;', mode = { 'n', }, silent = true, },
    ["<F9>'"]     = { function() require 'config.my.yank'.yank("'", 'n', 'w') end, "<cword> to '", mode = { 'n', }, silent = true, },
    ['<F9>[']     = { function() require 'config.my.yank'.yank('[', 'n', 'w') end, '<cword> to [', mode = { 'n', }, silent = true, },
    ['<F9>]']     = { function() require 'config.my.yank'.yank(']', 'n', 'w') end, '<cword> to ]', mode = { 'n', }, silent = true, },
    ['<F9><a-a>'] = { function() require 'config.my.yank'.yank('a', 'n', 'W') end, '<cWORD> to a', mode = { 'n', }, silent = true, },
    ['<F9><a-b>'] = { function() require 'config.my.yank'.yank('b', 'n', 'W') end, '<cWORD> to b', mode = { 'n', }, silent = true, },
    ['<F9><a-c>'] = { function() require 'config.my.yank'.yank('c', 'n', 'W') end, '<cWORD> to c', mode = { 'n', }, silent = true, },
    ['<F9><a-d>'] = { function() require 'config.my.yank'.yank('d', 'n', 'W') end, '<cWORD> to d', mode = { 'n', }, silent = true, },
    ['<F9><a-e>'] = { function() require 'config.my.yank'.yank('e', 'n', 'W') end, '<cWORD> to e', mode = { 'n', }, silent = true, },
    ['<F9><a-f>'] = { function() require 'config.my.yank'.yank('f', 'n', 'W') end, '<cWORD> to f', mode = { 'n', }, silent = true, },
    ['<F9><a-g>'] = { function() require 'config.my.yank'.yank('g', 'n', 'W') end, '<cWORD> to g', mode = { 'n', }, silent = true, },
    ['<F9><a-h>'] = { function() require 'config.my.yank'.yank('h', 'n', 'W') end, '<cWORD> to h', mode = { 'n', }, silent = true, },
    ['<F9><a-i>'] = { function() require 'config.my.yank'.yank('i', 'n', 'W') end, '<cWORD> to i', mode = { 'n', }, silent = true, },
    ['<F9><a-j>'] = { function() require 'config.my.yank'.yank('j', 'n', 'W') end, '<cWORD> to j', mode = { 'n', }, silent = true, },
    ['<F9><a-k>'] = { function() require 'config.my.yank'.yank('k', 'n', 'W') end, '<cWORD> to k', mode = { 'n', }, silent = true, },
    ['<F9><a-l>'] = { function() require 'config.my.yank'.yank('l', 'n', 'W') end, '<cWORD> to l', mode = { 'n', }, silent = true, },
    ['<F9><a-m>'] = { function() require 'config.my.yank'.yank('m', 'n', 'W') end, '<cWORD> to m', mode = { 'n', }, silent = true, },
    ['<F9><a-n>'] = { function() require 'config.my.yank'.yank('n', 'n', 'W') end, '<cWORD> to n', mode = { 'n', }, silent = true, },
    ['<F9><a-o>'] = { function() require 'config.my.yank'.yank('o', 'n', 'W') end, '<cWORD> to o', mode = { 'n', }, silent = true, },
    ['<F9><a-p>'] = { function() require 'config.my.yank'.yank('p', 'n', 'W') end, '<cWORD> to p', mode = { 'n', }, silent = true, },
    ['<F9><a-q>'] = { function() require 'config.my.yank'.yank('q', 'n', 'W') end, '<cWORD> to q', mode = { 'n', }, silent = true, },
    ['<F9><a-r>'] = { function() require 'config.my.yank'.yank('r', 'n', 'W') end, '<cWORD> to r', mode = { 'n', }, silent = true, },
    ['<F9><a-s>'] = { function() require 'config.my.yank'.yank('s', 'n', 'W') end, '<cWORD> to s', mode = { 'n', }, silent = true, },
    ['<F9><a-t>'] = { function() require 'config.my.yank'.yank('t', 'n', 'W') end, '<cWORD> to t', mode = { 'n', }, silent = true, },
    ['<F9><a-u>'] = { function() require 'config.my.yank'.yank('u', 'n', 'W') end, '<cWORD> to u', mode = { 'n', }, silent = true, },
    ['<F9><a-v>'] = { function() require 'config.my.yank'.yank('v', 'n', 'W') end, '<cWORD> to v', mode = { 'n', }, silent = true, },
    ['<F9><a-w>'] = { function() require 'config.my.yank'.yank('w', 'n', 'W') end, '<cWORD> to w', mode = { 'n', }, silent = true, },
    ['<F9><a-x>'] = { function() require 'config.my.yank'.yank('x', 'n', 'W') end, '<cWORD> to x', mode = { 'n', }, silent = true, },
    ['<F9><a-y>'] = { function() require 'config.my.yank'.yank('y', 'n', 'W') end, '<cWORD> to y', mode = { 'n', }, silent = true, },
    ['<F9><a-z>'] = { function() require 'config.my.yank'.yank('z', 'n', 'W') end, '<cWORD> to z', mode = { 'n', }, silent = true, },
    ['<F9><a-,>'] = { function() require 'config.my.yank'.yank(',', 'n', 'W') end, '<cWORD> to ,', mode = { 'n', }, silent = true, },
    ['<F9><a-.>'] = { function() require 'config.my.yank'.yank('.', 'n', 'W') end, '<cWORD> to .', mode = { 'n', }, silent = true, },
    ['<F9><a-/>'] = { function() require 'config.my.yank'.yank('/', 'n', 'W') end, '<cWORD> to /', mode = { 'n', }, silent = true, },
    ['<F9><a-;>'] = { function() require 'config.my.yank'.yank(';', 'n', 'W') end, '<cWORD> to ;', mode = { 'n', }, silent = true, },
    ["<F9><a-'>"] = { function() require 'config.my.yank'.yank("'", 'n', 'W') end, "<cWORD> to '", mode = { 'n', }, silent = true, },
    ['<F9><a-[>'] = { function() require 'config.my.yank'.yank('[', 'n', 'W') end, '<cWORD> to [', mode = { 'n', }, silent = true, },
    ['<F9><a-]>'] = { function() require 'config.my.yank'.yank(']', 'n', 'W') end, '<cWORD> to ]', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() require 'config.my.yank'.yank('a', 'v') end, 'sel to a', mode = { 'v', }, silent = true, },
    ['<F9>b'] = { function() require 'config.my.yank'.yank('b', 'v') end, 'sel to b', mode = { 'v', }, silent = true, },
    ['<F9>c'] = { function() require 'config.my.yank'.yank('c', 'v') end, 'sel to c', mode = { 'v', }, silent = true, },
    ['<F9>d'] = { function() require 'config.my.yank'.yank('d', 'v') end, 'sel to d', mode = { 'v', }, silent = true, },
    ['<F9>e'] = { function() require 'config.my.yank'.yank('e', 'v') end, 'sel to e', mode = { 'v', }, silent = true, },
    ['<F9>f'] = { function() require 'config.my.yank'.yank('f', 'v') end, 'sel to f', mode = { 'v', }, silent = true, },
    ['<F9>g'] = { function() require 'config.my.yank'.yank('g', 'v') end, 'sel to g', mode = { 'v', }, silent = true, },
    ['<F9>h'] = { function() require 'config.my.yank'.yank('h', 'v') end, 'sel to h', mode = { 'v', }, silent = true, },
    ['<F9>i'] = { function() require 'config.my.yank'.yank('i', 'v') end, 'sel to i', mode = { 'v', }, silent = true, },
    ['<F9>j'] = { function() require 'config.my.yank'.yank('j', 'v') end, 'sel to j', mode = { 'v', }, silent = true, },
    ['<F9>k'] = { function() require 'config.my.yank'.yank('k', 'v') end, 'sel to k', mode = { 'v', }, silent = true, },
    ['<F9>l'] = { function() require 'config.my.yank'.yank('l', 'v') end, 'sel to l', mode = { 'v', }, silent = true, },
    ['<F9>m'] = { function() require 'config.my.yank'.yank('m', 'v') end, 'sel to m', mode = { 'v', }, silent = true, },
    ['<F9>n'] = { function() require 'config.my.yank'.yank('n', 'v') end, 'sel to n', mode = { 'v', }, silent = true, },
    ['<F9>o'] = { function() require 'config.my.yank'.yank('o', 'v') end, 'sel to o', mode = { 'v', }, silent = true, },
    ['<F9>p'] = { function() require 'config.my.yank'.yank('p', 'v') end, 'sel to p', mode = { 'v', }, silent = true, },
    ['<F9>q'] = { function() require 'config.my.yank'.yank('q', 'v') end, 'sel to q', mode = { 'v', }, silent = true, },
    ['<F9>r'] = { function() require 'config.my.yank'.yank('r', 'v') end, 'sel to r', mode = { 'v', }, silent = true, },
    ['<F9>s'] = { function() require 'config.my.yank'.yank('s', 'v') end, 'sel to s', mode = { 'v', }, silent = true, },
    ['<F9>t'] = { function() require 'config.my.yank'.yank('t', 'v') end, 'sel to t', mode = { 'v', }, silent = true, },
    ['<F9>u'] = { function() require 'config.my.yank'.yank('u', 'v') end, 'sel to u', mode = { 'v', }, silent = true, },
    ['<F9>v'] = { function() require 'config.my.yank'.yank('v', 'v') end, 'sel to v', mode = { 'v', }, silent = true, },
    ['<F9>w'] = { function() require 'config.my.yank'.yank('w', 'v') end, 'sel to w', mode = { 'v', }, silent = true, },
    ['<F9>x'] = { function() require 'config.my.yank'.yank('x', 'v') end, 'sel to x', mode = { 'v', }, silent = true, },
    ['<F9>y'] = { function() require 'config.my.yank'.yank('y', 'v') end, 'sel to y', mode = { 'v', }, silent = true, },
    ['<F9>z'] = { function() require 'config.my.yank'.yank('z', 'v') end, 'sel to z', mode = { 'v', }, silent = true, },
    ['<F9>,'] = { function() require 'config.my.yank'.yank(',', 'v') end, 'sel to ,', mode = { 'v', }, silent = true, },
    ['<F9>.'] = { function() require 'config.my.yank'.yank('.', 'v') end, 'sel to .', mode = { 'v', }, silent = true, },
    ['<F9>/'] = { function() require 'config.my.yank'.yank('/', 'v') end, 'sel to /', mode = { 'v', }, silent = true, },
    ['<F9>;'] = { function() require 'config.my.yank'.yank(';', 'v') end, 'sel to ;', mode = { 'v', }, silent = true, },
    ["<F9>'"] = { function() require 'config.my.yank'.yank("'", 'v') end, "sel to '", mode = { 'v', }, silent = true, },
    ['<F9>['] = { function() require 'config.my.yank'.yank('[', 'v') end, 'sel to [', mode = { 'v', }, silent = true, },
    ['<F9>]'] = { function() require 'config.my.yank'.yank(']', 'v') end, 'sel to ]', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() require 'config.my.yank'.paste('a', 'i') end, 'paste from a', mode = { 'i', }, silent = true, },
    ['<F9>b'] = { function() require 'config.my.yank'.paste('b', 'i') end, 'paste from b', mode = { 'i', }, silent = true, },
    ['<F9>c'] = { function() require 'config.my.yank'.paste('c', 'i') end, 'paste from c', mode = { 'i', }, silent = true, },
    ['<F9>d'] = { function() require 'config.my.yank'.paste('d', 'i') end, 'paste from d', mode = { 'i', }, silent = true, },
    ['<F9>e'] = { function() require 'config.my.yank'.paste('e', 'i') end, 'paste from e', mode = { 'i', }, silent = true, },
    ['<F9>f'] = { function() require 'config.my.yank'.paste('f', 'i') end, 'paste from f', mode = { 'i', }, silent = true, },
    ['<F9>g'] = { function() require 'config.my.yank'.paste('g', 'i') end, 'paste from g', mode = { 'i', }, silent = true, },
    ['<F9>h'] = { function() require 'config.my.yank'.paste('h', 'i') end, 'paste from h', mode = { 'i', }, silent = true, },
    ['<F9>i'] = { function() require 'config.my.yank'.paste('i', 'i') end, 'paste from i', mode = { 'i', }, silent = true, },
    ['<F9>j'] = { function() require 'config.my.yank'.paste('j', 'i') end, 'paste from j', mode = { 'i', }, silent = true, },
    ['<F9>k'] = { function() require 'config.my.yank'.paste('k', 'i') end, 'paste from k', mode = { 'i', }, silent = true, },
    ['<F9>l'] = { function() require 'config.my.yank'.paste('l', 'i') end, 'paste from l', mode = { 'i', }, silent = true, },
    ['<F9>m'] = { function() require 'config.my.yank'.paste('m', 'i') end, 'paste from m', mode = { 'i', }, silent = true, },
    ['<F9>n'] = { function() require 'config.my.yank'.paste('n', 'i') end, 'paste from n', mode = { 'i', }, silent = true, },
    ['<F9>o'] = { function() require 'config.my.yank'.paste('o', 'i') end, 'paste from o', mode = { 'i', }, silent = true, },
    ['<F9>p'] = { function() require 'config.my.yank'.paste('p', 'i') end, 'paste from p', mode = { 'i', }, silent = true, },
    ['<F9>q'] = { function() require 'config.my.yank'.paste('q', 'i') end, 'paste from q', mode = { 'i', }, silent = true, },
    ['<F9>r'] = { function() require 'config.my.yank'.paste('r', 'i') end, 'paste from r', mode = { 'i', }, silent = true, },
    ['<F9>s'] = { function() require 'config.my.yank'.paste('s', 'i') end, 'paste from s', mode = { 'i', }, silent = true, },
    ['<F9>t'] = { function() require 'config.my.yank'.paste('t', 'i') end, 'paste from t', mode = { 'i', }, silent = true, },
    ['<F9>u'] = { function() require 'config.my.yank'.paste('u', 'i') end, 'paste from u', mode = { 'i', }, silent = true, },
    ['<F9>v'] = { function() require 'config.my.yank'.paste('v', 'i') end, 'paste from v', mode = { 'i', }, silent = true, },
    ['<F9>w'] = { function() require 'config.my.yank'.paste('w', 'i') end, 'paste from w', mode = { 'i', }, silent = true, },
    ['<F9>x'] = { function() require 'config.my.yank'.paste('x', 'i') end, 'paste from x', mode = { 'i', }, silent = true, },
    ['<F9>y'] = { function() require 'config.my.yank'.paste('y', 'i') end, 'paste from y', mode = { 'i', }, silent = true, },
    ['<F9>z'] = { function() require 'config.my.yank'.paste('z', 'i') end, 'paste from z', mode = { 'i', }, silent = true, },
    ['<F9>,'] = { function() require 'config.my.yank'.paste(',', 'i') end, 'paste from ,', mode = { 'i', }, silent = true, },
    ['<F9>.'] = { function() require 'config.my.yank'.paste('.', 'i') end, 'paste from .', mode = { 'i', }, silent = true, },
    ['<F9>/'] = { function() require 'config.my.yank'.paste('/', 'i') end, 'paste from /', mode = { 'i', }, silent = true, },
    ['<F9>;'] = { function() require 'config.my.yank'.paste(';', 'i') end, 'paste from ;', mode = { 'i', }, silent = true, },
    ["<F9>'"] = { function() require 'config.my.yank'.paste("'", 'i') end, "paste from '", mode = { 'i', }, silent = true, },
    ['<F9>['] = { function() require 'config.my.yank'.paste('[', 'i') end, 'paste from [', mode = { 'i', }, silent = true, },
    ['<F9>]'] = { function() require 'config.my.yank'.paste(']', 'i') end, 'paste from ]', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() require 'config.my.yank'.paste('a', 'c') end, 'paste from a', mode = { 'c', }, silent = true, },
    ['<F9>b'] = { function() require 'config.my.yank'.paste('b', 'c') end, 'paste from b', mode = { 'c', }, silent = true, },
    ['<F9>c'] = { function() require 'config.my.yank'.paste('c', 'c') end, 'paste from c', mode = { 'c', }, silent = true, },
    ['<F9>d'] = { function() require 'config.my.yank'.paste('d', 'c') end, 'paste from d', mode = { 'c', }, silent = true, },
    ['<F9>e'] = { function() require 'config.my.yank'.paste('e', 'c') end, 'paste from e', mode = { 'c', }, silent = true, },
    ['<F9>f'] = { function() require 'config.my.yank'.paste('f', 'c') end, 'paste from f', mode = { 'c', }, silent = true, },
    ['<F9>g'] = { function() require 'config.my.yank'.paste('g', 'c') end, 'paste from g', mode = { 'c', }, silent = true, },
    ['<F9>h'] = { function() require 'config.my.yank'.paste('h', 'c') end, 'paste from h', mode = { 'c', }, silent = true, },
    ['<F9>i'] = { function() require 'config.my.yank'.paste('i', 'c') end, 'paste from i', mode = { 'c', }, silent = true, },
    ['<F9>j'] = { function() require 'config.my.yank'.paste('j', 'c') end, 'paste from j', mode = { 'c', }, silent = true, },
    ['<F9>k'] = { function() require 'config.my.yank'.paste('k', 'c') end, 'paste from k', mode = { 'c', }, silent = true, },
    ['<F9>l'] = { function() require 'config.my.yank'.paste('l', 'c') end, 'paste from l', mode = { 'c', }, silent = true, },
    ['<F9>m'] = { function() require 'config.my.yank'.paste('m', 'c') end, 'paste from m', mode = { 'c', }, silent = true, },
    ['<F9>n'] = { function() require 'config.my.yank'.paste('n', 'c') end, 'paste from n', mode = { 'c', }, silent = true, },
    ['<F9>o'] = { function() require 'config.my.yank'.paste('o', 'c') end, 'paste from o', mode = { 'c', }, silent = true, },
    ['<F9>p'] = { function() require 'config.my.yank'.paste('p', 'c') end, 'paste from p', mode = { 'c', }, silent = true, },
    ['<F9>q'] = { function() require 'config.my.yank'.paste('q', 'c') end, 'paste from q', mode = { 'c', }, silent = true, },
    ['<F9>r'] = { function() require 'config.my.yank'.paste('r', 'c') end, 'paste from r', mode = { 'c', }, silent = true, },
    ['<F9>s'] = { function() require 'config.my.yank'.paste('s', 'c') end, 'paste from s', mode = { 'c', }, silent = true, },
    ['<F9>t'] = { function() require 'config.my.yank'.paste('t', 'c') end, 'paste from t', mode = { 'c', }, silent = true, },
    ['<F9>u'] = { function() require 'config.my.yank'.paste('u', 'c') end, 'paste from u', mode = { 'c', }, silent = true, },
    ['<F9>v'] = { function() require 'config.my.yank'.paste('v', 'c') end, 'paste from v', mode = { 'c', }, silent = true, },
    ['<F9>w'] = { function() require 'config.my.yank'.paste('w', 'c') end, 'paste from w', mode = { 'c', }, silent = true, },
    ['<F9>x'] = { function() require 'config.my.yank'.paste('x', 'c') end, 'paste from x', mode = { 'c', }, silent = true, },
    ['<F9>y'] = { function() require 'config.my.yank'.paste('y', 'c') end, 'paste from y', mode = { 'c', }, silent = true, },
    ['<F9>z'] = { function() require 'config.my.yank'.paste('z', 'c') end, 'paste from z', mode = { 'c', }, silent = true, },
    ['<F9>,'] = { function() require 'config.my.yank'.paste(',', 'c') end, 'paste from ,', mode = { 'c', }, silent = true, },
    ['<F9>.'] = { function() require 'config.my.yank'.paste('.', 'c') end, 'paste from .', mode = { 'c', }, silent = true, },
    ['<F9>/'] = { function() require 'config.my.yank'.paste('/', 'c') end, 'paste from /', mode = { 'c', }, silent = true, },
    ['<F9>;'] = { function() require 'config.my.yank'.paste(';', 'c') end, 'paste from ;', mode = { 'c', }, silent = true, },
    ["<F9>'"] = { function() require 'config.my.yank'.paste("'", 'c') end, "paste from '", mode = { 'c', }, silent = true, },
    ['<F9>['] = { function() require 'config.my.yank'.paste('[', 'c') end, 'paste from [', mode = { 'c', }, silent = true, },
    ['<F9>]'] = { function() require 'config.my.yank'.paste(']', 'c') end, 'paste from ]', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>a'] = { function() require 'config.my.yank'.paste('a', 't') end, 'paste from a', mode = { 't', }, silent = true, },
    ['<F9>b'] = { function() require 'config.my.yank'.paste('b', 't') end, 'paste from b', mode = { 't', }, silent = true, },
    ['<F9>c'] = { function() require 'config.my.yank'.paste('c', 't') end, 'paste from c', mode = { 't', }, silent = true, },
    ['<F9>d'] = { function() require 'config.my.yank'.paste('d', 't') end, 'paste from d', mode = { 't', }, silent = true, },
    ['<F9>e'] = { function() require 'config.my.yank'.paste('e', 't') end, 'paste from e', mode = { 't', }, silent = true, },
    ['<F9>f'] = { function() require 'config.my.yank'.paste('f', 't') end, 'paste from f', mode = { 't', }, silent = true, },
    ['<F9>g'] = { function() require 'config.my.yank'.paste('g', 't') end, 'paste from g', mode = { 't', }, silent = true, },
    ['<F9>h'] = { function() require 'config.my.yank'.paste('h', 't') end, 'paste from h', mode = { 't', }, silent = true, },
    ['<F9>i'] = { function() require 'config.my.yank'.paste('i', 't') end, 'paste from i', mode = { 't', }, silent = true, },
    ['<F9>j'] = { function() require 'config.my.yank'.paste('j', 't') end, 'paste from j', mode = { 't', }, silent = true, },
    ['<F9>k'] = { function() require 'config.my.yank'.paste('k', 't') end, 'paste from k', mode = { 't', }, silent = true, },
    ['<F9>l'] = { function() require 'config.my.yank'.paste('l', 't') end, 'paste from l', mode = { 't', }, silent = true, },
    ['<F9>m'] = { function() require 'config.my.yank'.paste('m', 't') end, 'paste from m', mode = { 't', }, silent = true, },
    ['<F9>n'] = { function() require 'config.my.yank'.paste('n', 't') end, 'paste from n', mode = { 't', }, silent = true, },
    ['<F9>o'] = { function() require 'config.my.yank'.paste('o', 't') end, 'paste from o', mode = { 't', }, silent = true, },
    ['<F9>p'] = { function() require 'config.my.yank'.paste('p', 't') end, 'paste from p', mode = { 't', }, silent = true, },
    ['<F9>q'] = { function() require 'config.my.yank'.paste('q', 't') end, 'paste from q', mode = { 't', }, silent = true, },
    ['<F9>r'] = { function() require 'config.my.yank'.paste('r', 't') end, 'paste from r', mode = { 't', }, silent = true, },
    ['<F9>s'] = { function() require 'config.my.yank'.paste('s', 't') end, 'paste from s', mode = { 't', }, silent = true, },
    ['<F9>t'] = { function() require 'config.my.yank'.paste('t', 't') end, 'paste from t', mode = { 't', }, silent = true, },
    ['<F9>u'] = { function() require 'config.my.yank'.paste('u', 't') end, 'paste from u', mode = { 't', }, silent = true, },
    ['<F9>v'] = { function() require 'config.my.yank'.paste('v', 't') end, 'paste from v', mode = { 't', }, silent = true, },
    ['<F9>w'] = { function() require 'config.my.yank'.paste('w', 't') end, 'paste from w', mode = { 't', }, silent = true, },
    ['<F9>x'] = { function() require 'config.my.yank'.paste('x', 't') end, 'paste from x', mode = { 't', }, silent = true, },
    ['<F9>y'] = { function() require 'config.my.yank'.paste('y', 't') end, 'paste from y', mode = { 't', }, silent = true, },
    ['<F9>z'] = { function() require 'config.my.yank'.paste('z', 't') end, 'paste from z', mode = { 't', }, silent = true, },
    ['<F9>,'] = { function() require 'config.my.yank'.paste(',', 't') end, 'paste from ,', mode = { 't', }, silent = true, },
    ['<F9>.'] = { function() require 'config.my.yank'.paste('.', 't') end, 'paste from .', mode = { 't', }, silent = true, },
    ['<F9>/'] = { function() require 'config.my.yank'.paste('/', 't') end, 'paste from /', mode = { 't', }, silent = true, },
    ['<F9>;'] = { function() require 'config.my.yank'.paste(';', 't') end, 'paste from ;', mode = { 't', }, silent = true, },
    ["<F9>'"] = { function() require 'config.my.yank'.paste("'", 't') end, "paste from '", mode = { 't', }, silent = true, },
    ['<F9>['] = { function() require 'config.my.yank'.paste('[', 't') end, 'paste from [', mode = { 't', }, silent = true, },
    ['<F9>]'] = { function() require 'config.my.yank'.paste(']', 't') end, 'paste from ]', mode = { 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9>A'] = { function() require 'config.my.yank'.paste('a', 'n') end, 'paste from a', mode = { 'n', 'v', }, silent = true, },
    ['<F9>B'] = { function() require 'config.my.yank'.paste('b', 'n') end, 'paste from b', mode = { 'n', 'v', }, silent = true, },
    ['<F9>C'] = { function() require 'config.my.yank'.paste('c', 'n') end, 'paste from c', mode = { 'n', 'v', }, silent = true, },
    ['<F9>D'] = { function() require 'config.my.yank'.paste('d', 'n') end, 'paste from d', mode = { 'n', 'v', }, silent = true, },
    ['<F9>E'] = { function() require 'config.my.yank'.paste('e', 'n') end, 'paste from e', mode = { 'n', 'v', }, silent = true, },
    ['<F9>F'] = { function() require 'config.my.yank'.paste('f', 'n') end, 'paste from f', mode = { 'n', 'v', }, silent = true, },
    ['<F9>G'] = { function() require 'config.my.yank'.paste('g', 'n') end, 'paste from g', mode = { 'n', 'v', }, silent = true, },
    ['<F9>H'] = { function() require 'config.my.yank'.paste('h', 'n') end, 'paste from h', mode = { 'n', 'v', }, silent = true, },
    ['<F9>I'] = { function() require 'config.my.yank'.paste('i', 'n') end, 'paste from i', mode = { 'n', 'v', }, silent = true, },
    ['<F9>J'] = { function() require 'config.my.yank'.paste('j', 'n') end, 'paste from j', mode = { 'n', 'v', }, silent = true, },
    ['<F9>K'] = { function() require 'config.my.yank'.paste('k', 'n') end, 'paste from k', mode = { 'n', 'v', }, silent = true, },
    ['<F9>L'] = { function() require 'config.my.yank'.paste('l', 'n') end, 'paste from l', mode = { 'n', 'v', }, silent = true, },
    ['<F9>M'] = { function() require 'config.my.yank'.paste('m', 'n') end, 'paste from m', mode = { 'n', 'v', }, silent = true, },
    ['<F9>N'] = { function() require 'config.my.yank'.paste('n', 'n') end, 'paste from n', mode = { 'n', 'v', }, silent = true, },
    ['<F9>O'] = { function() require 'config.my.yank'.paste('o', 'n') end, 'paste from o', mode = { 'n', 'v', }, silent = true, },
    ['<F9>P'] = { function() require 'config.my.yank'.paste('p', 'n') end, 'paste from p', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Q'] = { function() require 'config.my.yank'.paste('q', 'n') end, 'paste from q', mode = { 'n', 'v', }, silent = true, },
    ['<F9>R'] = { function() require 'config.my.yank'.paste('r', 'n') end, 'paste from r', mode = { 'n', 'v', }, silent = true, },
    ['<F9>S'] = { function() require 'config.my.yank'.paste('s', 'n') end, 'paste from s', mode = { 'n', 'v', }, silent = true, },
    ['<F9>T'] = { function() require 'config.my.yank'.paste('t', 'n') end, 'paste from t', mode = { 'n', 'v', }, silent = true, },
    ['<F9>U'] = { function() require 'config.my.yank'.paste('u', 'n') end, 'paste from u', mode = { 'n', 'v', }, silent = true, },
    ['<F9>V'] = { function() require 'config.my.yank'.paste('v', 'n') end, 'paste from v', mode = { 'n', 'v', }, silent = true, },
    ['<F9>W'] = { function() require 'config.my.yank'.paste('w', 'n') end, 'paste from w', mode = { 'n', 'v', }, silent = true, },
    ['<F9>X'] = { function() require 'config.my.yank'.paste('x', 'n') end, 'paste from x', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Y'] = { function() require 'config.my.yank'.paste('y', 'n') end, 'paste from y', mode = { 'n', 'v', }, silent = true, },
    ['<F9>Z'] = { function() require 'config.my.yank'.paste('z', 'n') end, 'paste from z', mode = { 'n', 'v', }, silent = true, },
    ['<F9><'] = { function() require 'config.my.yank'.paste(',', 'n') end, 'paste from ,', mode = { 'n', 'v', }, silent = true, },
    ['<F9>>'] = { function() require 'config.my.yank'.paste('.', 'n') end, 'paste from .', mode = { 'n', 'v', }, silent = true, },
    ['<F9>?'] = { function() require 'config.my.yank'.paste('/', 'n') end, 'paste from /', mode = { 'n', 'v', }, silent = true, },
    ['<F9>:'] = { function() require 'config.my.yank'.paste(';', 'n') end, 'paste from ;', mode = { 'n', 'v', }, silent = true, },
    ['<F9>"'] = { function() require 'config.my.yank'.paste("'", 'n') end, "paste from '", mode = { 'n', 'v', }, silent = true, },
    ['<F9>{'] = { function() require 'config.my.yank'.paste('[', 'n') end, 'paste from [', mode = { 'n', 'v', }, silent = true, },
    ['<F9>}'] = { function() require 'config.my.yank'.paste(']', 'n') end, 'paste from ]', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><c-s-a>'] = { function() require 'config.my.yank'.delete 'a' end, 'delete from a', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-b>'] = { function() require 'config.my.yank'.delete 'b' end, 'delete from b', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-c>'] = { function() require 'config.my.yank'.delete 'c' end, 'delete from c', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-d>'] = { function() require 'config.my.yank'.delete 'd' end, 'delete from d', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-e>'] = { function() require 'config.my.yank'.delete 'e' end, 'delete from e', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-f>'] = { function() require 'config.my.yank'.delete 'f' end, 'delete from f', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-g>'] = { function() require 'config.my.yank'.delete 'g' end, 'delete from g', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-h>'] = { function() require 'config.my.yank'.delete 'h' end, 'delete from h', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-i>'] = { function() require 'config.my.yank'.delete 'i' end, 'delete from i', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-j>'] = { function() require 'config.my.yank'.delete 'j' end, 'delete from j', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-k>'] = { function() require 'config.my.yank'.delete 'k' end, 'delete from k', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-l>'] = { function() require 'config.my.yank'.delete 'l' end, 'delete from l', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-m>'] = { function() require 'config.my.yank'.delete 'm' end, 'delete from m', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-n>'] = { function() require 'config.my.yank'.delete 'n' end, 'delete from n', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-o>'] = { function() require 'config.my.yank'.delete 'o' end, 'delete from o', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-p>'] = { function() require 'config.my.yank'.delete 'p' end, 'delete from p', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-q>'] = { function() require 'config.my.yank'.delete 'q' end, 'delete from q', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-r>'] = { function() require 'config.my.yank'.delete 'r' end, 'delete from r', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-s>'] = { function() require 'config.my.yank'.delete 's' end, 'delete from s', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-t>'] = { function() require 'config.my.yank'.delete 't' end, 'delete from t', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-u>'] = { function() require 'config.my.yank'.delete 'u' end, 'delete from u', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-v>'] = { function() require 'config.my.yank'.delete 'v' end, 'delete from v', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-w>'] = { function() require 'config.my.yank'.delete 'w' end, 'delete from w', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-x>'] = { function() require 'config.my.yank'.delete 'x' end, 'delete from x', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-y>'] = { function() require 'config.my.yank'.delete 'y' end, 'delete from y', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-z>'] = { function() require 'config.my.yank'.delete 'z' end, 'delete from z', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-,>'] = { function() require 'config.my.yank'.delete ',' end, 'delete from ,', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-.>'] = { function() require 'config.my.yank'.delete '.' end, 'delete from .', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-/>'] = { function() require 'config.my.yank'.delete '/' end, 'delete from /', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-;>'] = { function() require 'config.my.yank'.delete ';' end, 'delete from ;', mode = { 'n', 'v', }, silent = true, },
    ["<F9><c-s-'>"] = { function() require 'config.my.yank'.delete "'" end, "delete from '", mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-[>'] = { function() require 'config.my.yank'.delete '[' end, 'delete from [', mode = { 'n', 'v', }, silent = true, },
    ['<F9><c-s-]>'] = { function() require 'config.my.yank'.delete ']' end, 'delete from ]', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F1>'] = { name = '+my.yank.clipboard', },
    ['<F9><F1>a'] = { function() require 'config.my.yank'.clipboard 'a' end, 'a to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>b'] = { function() require 'config.my.yank'.clipboard 'b' end, 'b to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>c'] = { function() require 'config.my.yank'.clipboard 'c' end, 'c to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>d'] = { function() require 'config.my.yank'.clipboard 'd' end, 'd to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>e'] = { function() require 'config.my.yank'.clipboard 'e' end, 'e to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>f'] = { function() require 'config.my.yank'.clipboard 'f' end, 'f to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>g'] = { function() require 'config.my.yank'.clipboard 'g' end, 'g to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>h'] = { function() require 'config.my.yank'.clipboard 'h' end, 'h to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>i'] = { function() require 'config.my.yank'.clipboard 'i' end, 'i to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>j'] = { function() require 'config.my.yank'.clipboard 'j' end, 'j to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>k'] = { function() require 'config.my.yank'.clipboard 'k' end, 'k to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>l'] = { function() require 'config.my.yank'.clipboard 'l' end, 'l to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>m'] = { function() require 'config.my.yank'.clipboard 'm' end, 'm to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>n'] = { function() require 'config.my.yank'.clipboard 'n' end, 'n to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>o'] = { function() require 'config.my.yank'.clipboard 'o' end, 'o to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>p'] = { function() require 'config.my.yank'.clipboard 'p' end, 'p to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>q'] = { function() require 'config.my.yank'.clipboard 'q' end, 'q to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>r'] = { function() require 'config.my.yank'.clipboard 'r' end, 'r to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>s'] = { function() require 'config.my.yank'.clipboard 's' end, 's to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>t'] = { function() require 'config.my.yank'.clipboard 't' end, 't to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>u'] = { function() require 'config.my.yank'.clipboard 'u' end, 'u to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>v'] = { function() require 'config.my.yank'.clipboard 'v' end, 'v to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>w'] = { function() require 'config.my.yank'.clipboard 'w' end, 'w to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>x'] = { function() require 'config.my.yank'.clipboard 'x' end, 'x to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>y'] = { function() require 'config.my.yank'.clipboard 'y' end, 'y to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>z'] = { function() require 'config.my.yank'.clipboard 'z' end, 'z to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>,'] = { function() require 'config.my.yank'.clipboard ',' end, ', to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>.'] = { function() require 'config.my.yank'.clipboard '.' end, '. to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>/'] = { function() require 'config.my.yank'.clipboard '/' end, '/ to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>;'] = { function() require 'config.my.yank'.clipboard ';' end, '; to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ["<F9><F1>'"] = { function() require 'config.my.yank'.clipboard "'" end, "' to clipboard", mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>['] = { function() require 'config.my.yank'.clipboard '[' end, '[ to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
    ['<F9><F1>]'] = { function() require 'config.my.yank'.clipboard ']' end, '] to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F2>'] = { function() require 'config.my.yank'.stack('n', 'w') end, 'yank <cword> to pool', mode = { 'n', }, silent = true, },
    ['<F9><F3>'] = { function() require 'config.my.yank'.stack('n', 'W') end, 'yank <cWORD> to pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F2>'] = { function() require 'config.my.yank'.stack('v', 'w') end, 'yank <cword> to pool', mode = { 'v', }, silent = true, },
    ['<F9><F3>'] = { function() require 'config.my.yank'.stack('v', 'W') end, 'yank <cWORD> to pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'n' end, 'sel paste from pool', mode = { 'n', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'v' end, 'sel paste from pool', mode = { 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'i' end, 'sel paste from pool', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'c' end, 'sel paste from pool', mode = { 'c', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 't' end, 'sel paste from pool', mode = { 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><F1><F1>'] = { function() require 'config.my.yank'.clipboard_from_pool() end, 'sel from pool to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  require 'which-key'.register {
    ['<F9><c-F4>'] = { function() require 'config.my.yank'.delete_pool() end, 'delete pool', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.toggle()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>t'] = { name = 'toggle', },
    ['<leader>td'] = { function() require 'config.my.toggle'.diff() end, 'diff', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tw'] = { function() require 'config.my.toggle'.wrap() end, 'wrap', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tn'] = { function() require 'config.my.toggle'.nu() end, 'nu', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tr'] = { function() require 'config.my.toggle'.renu() end, 'renu', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ts'] = { function() require 'config.my.toggle'.signcolumn() end, 'signcolumn', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tc'] = { function() require 'config.my.toggle'.conceallevel() end, 'conceallevel', mode = { 'n', 'v', }, silent = true, },
    ['<leader>tk'] = { function() require 'config.my.toggle'.iskeyword() end, 'iskeyword', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.lsp()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>f'] = { name = 'lsp', },
    ['<leader>fv'] = { name = 'lsp.more', },
    ['<leader>fn'] = { function() require 'config.nvim.lsp'.rename() end, 'lsp: rename', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.git()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>g'] = { name = 'git', },
    ['<leader>gt'] = { name = 'git.telescope', },
    ['<leader>gtb'] = { function() require 'config.nvim.telescope'.git_bcommits() end, 'git.telescope: bcommits', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gtc'] = { function() require 'config.nvim.telescope'.git_commits() end, 'git.telescope: commits', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gh'] = { function() require 'config.nvim.telescope'.git_branches() end, 'git.telescope: branches', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gg'] = { name = 'git.push', },
    ['<leader>gga'] = { function() require 'config.my.git'.addcommitpush(nil, 1) end, 'git.push: addcommitpush commit_history_en', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gc'] = { function() require 'config.my.git'.commit_push() end, 'git.push: commit_push', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggc'] = { function() require 'config.my.git'.commit_push(nil, 1) end, 'git.push: commit_push commit_history_en', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gp'] = { function() require 'config.my.git'.pull() end, 'git.push: pull', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gb'] = { function() require 'config.my.git'.git_browser() end, 'git.push: browser', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggs'] = { function() require 'config.my.git'.push() end, 'git.push: push', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggg'] = { function() require 'config.my.git'.graph_asyncrun() end, 'git.push: graph_asyncrun', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gg<c-g>'] = { function() require 'config.my.git'.graph_start() end, 'git.push: graph_start', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggv'] = { function() require 'config.my.git'.init() end, 'git.push: init', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-a>'] = { function() require 'config.my.git'.addall() end, 'git.push: addall', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggr'] = { function() require 'config.my.git'.reset_hard() end, 'git.push: reset_hard', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggd'] = { function() require 'config.my.git'.reset_hard_clean() end, 'git.push: reset_hard_clean', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggD'] = { function() require 'config.my.git'.clean_ignored_files_and_folders() end, 'git.push: clean_ignored_files_and_folders', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggC'] = { function() require 'config.my.git'.clone() end, 'git.push: clone', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ggh'] = { function() require 'config.my.git'.show_commit_history() end, 'git.push: show_commit_history', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-l>'] = { function() require 'config.my.git'.addcommitpush_curline() end, 'git.push: addcommitpush curline', mode = { 'n', 'v', }, silent = true, },
    ["<leader>g<c-'>"] = { function() require 'config.my.git'.addcommitpush_single_quote() end, 'git.push: addcommitpush single_quote', mode = { 'n', 'v', }, silent = true, },
    ["<leader>g<c-s-'>"] = { function() require 'config.my.git'.addcommitpush_double_quote() end, 'git.push: addcommitpush double_quote', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-0>'] = { function() require 'config.my.git'.addcommitpush_parentheses() end, 'git.push: addcommitpush parentheses', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-]>'] = { function() require 'config.my.git'.addcommitpush_bracket() end, 'git.push: addcommitpush bracket', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-s-]>'] = { function() require 'config.my.git'.addcommitpush_brace() end, 'git.push: addcommitpush brace', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-`>'] = { function() require 'config.my.git'.addcommitpush_back_quote() end, 'git.push: addcommitpush back_quote', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-s-.>'] = { function() require 'config.my.git'.addcommitpush_angle_bracket() end, 'git.push: addcommitpush angle_bracket', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-e>'] = { function() require 'config.my.git'.addcommitpush_cword() end, 'git.push: addcommitpush cword', mode = { 'n', 'v', }, silent = true, },
    ['<leader>g<c-4>'] = { function() require 'config.my.git'.addcommitpush_cWORD() end, 'git.push: addcommitpush cWORD', mode = { 'n', 'v', }, silent = true, },
    g = { name = 'git.push', },
    ['g<c-l>'] = { function() require 'config.my.git'.addcommitpush_curline() end, 'git.push: addcommitpush curline', mode = { 'n', 'v', }, silent = true, },
    ["g<c-'>"] = { function() require 'config.my.git'.addcommitpush_single_quote() end, 'git.push: addcommitpush single_quote', mode = { 'n', 'v', }, silent = true, },
    ["g<c-s-'>"] = { function() require 'config.my.git'.addcommitpush_double_quote() end, 'git.push: addcommitpush double_quote', mode = { 'n', 'v', }, silent = true, },
    ['g<c-0>'] = { function() require 'config.my.git'.addcommitpush_parentheses() end, 'git.push: addcommitpush parentheses', mode = { 'n', 'v', }, silent = true, },
    ['g<c-]>'] = { function() require 'config.my.git'.addcommitpush_bracket() end, 'git.push: addcommitpush bracket', mode = { 'n', 'v', }, silent = true, },
    ['g<c-s-]>'] = { function() require 'config.my.git'.addcommitpush_brace() end, 'git.push: addcommitpush brace', mode = { 'n', 'v', }, silent = true, },
    ['g<c-`>'] = { function() require 'config.my.git'.addcommitpush_back_quote() end, 'git.push: addcommitpush back_quote', mode = { 'n', 'v', }, silent = true, },
    ['g<c-s-.>'] = { function() require 'config.my.git'.addcommitpush_angle_bracket() end, 'git.push: addcommitpush angle_bracket', mode = { 'n', 'v', }, silent = true, },
    ['g<c-e>'] = { function() require 'config.my.git'.addcommitpush_cword() end, 'git.push: addcommitpush cword', mode = { 'n', 'v', }, silent = true, },
    ['g<c-4>'] = { function() require 'config.my.git'.addcommitpush_cWORD() end, 'git.push: addcommitpush cWORD', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gv'] = { name = 'git.diffview', },
    ['<leader>gv1'] = { function() require 'config.my.git'.diffview_filehistory(1) end, 'git.diffview: filehistory 16', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gv2'] = { function() require 'config.my.git'.diffview_filehistory(2) end, 'git.diffview: filehistory 64', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gv3'] = { function() require 'config.my.git'.diffview_filehistory(3) end, 'git.diffview: filehistory finite', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvs'] = { function() require 'config.my.git'.diffview_stash() end, 'git.diffview: filehistory stash', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvo'] = { function() require 'config.my.git'.diffview_open() end, 'git.diffview: open', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvq'] = { function() require 'config.my.git'.diffview_close() end, 'git.diffview: close', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvl'] = { ':<c-u>DiffviewRefresh<cr>', 'git.diffview: refresh', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gvw'] = { ':<c-u>Telescope git_diffs diff_commits<cr>', 'git.diffview: Telescope git_diffs diff_commits', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gm'] = { name = 'git.signs', },
    ['<leader>gmt'] = { name = 'git.signs.toggle', },
    ['<leader>ge'] = { function() require 'config.my.git'.toggle_deleted() end, 'my.git.signs: toggle_deleted', mode = { 'n', 'v', }, silent = true, },
    ['<leader>gmd'] = { function() require 'config.my.git'.diffthis_l() end, 'my.git.signs: diffthis_l', mode = { 'n', 'v', }, },
    ['<leader>gmr'] = { function() require 'config.my.git'.reset_buffer() end, 'my.git.signs: reset_buffer', mode = { 'n', 'v', }, },
    ['<leader>gms'] = { function() require 'config.my.git'.stage_buffer() end, 'my.git.signs: stage_buffer', mode = { 'n', 'v', }, },
    ['<leader>gmb'] = { function() require 'config.my.git'.blame_line() end, 'my.git.signs: blame_line', mode = { 'n', 'v', }, },
    ['<leader>gmp'] = { function() require 'config.my.git'.preview_hunk() end, 'my.git.signs: preview_hunk', mode = { 'n', 'v', }, },
    ['<leader>gmtb'] = { function() require 'config.my.git'.toggle_current_line_blame() end, 'my.git.signs: toggle_current_line_blame', mode = { 'n', 'v', }, },
    ['<leader>gmtd'] = { function() require 'config.my.git'.toggle_deleted() end, 'my.git.signs: toggle_deleted', mode = { 'n', 'v', }, },
    ['<leader>gmtl'] = { function() require 'config.my.git'.toggle_linehl() end, 'my.git.signs: toggle_linehl', mode = { 'n', 'v', }, },
    ['<leader>gmtn'] = { function() require 'config.my.git'.toggle_numhl() end, 'my.git.signs: toggle_numhl', mode = { 'n', 'v', }, },
    ['<leader>gmts'] = { function() require 'config.my.git'.toggle_signs() end, 'my.git.signs: toggle_signs', mode = { 'n', 'v', }, },
    ['<leader>gmtw'] = { function() require 'config.my.git'.toggle_word_diff() end, 'my.git.signs: toggle_word_diff', mode = { 'n', 'v', }, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.tabline()
  TimingBegin()
  require 'which-key'.register {
    ['<leader><c-s-l>'] = { function() require 'config.my.tabline'.bd_next_buf(1) end, 'my.tabline: bwipeout_next_buf ', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-h>'] = { function() require 'config.my.tabline'.bd_prev_buf(1) end, 'my.tabline: bwipeout_prev_buf', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-.>'] = { function() require 'config.my.tabline'.bd_all_next_buf(1) end, 'my.tabline: bwipeout_all_next_buf', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-,>'] = { function() require 'config.my.tabline'.bd_all_prev_buf(1) end, 'my.tabline: bwipeout_all_prev_buf', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.q()
  TimingBegin()
  require 'which-key'.register {
    ['q'] = { name = 'tabline', },
    qh = { function() require 'config.my.tabline'.restore_hidden_tabs() end, 'my.tabline: restore_hidden_tabs', mode = { 'n', 'v', }, silent = true, },
    qk = { function() require 'config.my.tabline'.append_one_proj_new_tab_no_dupl() end, 'my.tabline: append_one_proj_new_tab_no_dupl', mode = { 'n', 'v', }, silent = true, },
    qm = { function() require 'config.my.tabline'.restore_hidden_stack_main() end, 'my.tabline: restore_hidden_tabs', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.leader_d()
  TimingBegin()
  require 'which-key'.register {
    ['<leader>d'] = { name = 'nvim/qf', },
    ['<leader>dw'] = { function() require 'config.myy.git'.open_prev_item() end, 'quick open: qf prev item', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ds'] = { function() require 'config.myy.git'.open_next_item() end, 'quick open: qf next item', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dj'] = { function() require 'config.test.nvimtree'.open_next_tree_node() end, 'quick open: nvimtree next node', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dk'] = { function() require 'config.test.nvimtree'.open_prev_tree_node() end, 'quick open: nvimtree prev node', mode = { 'n', 'v', }, silent = true, },
    ['<leader>do'] = { function() require 'config.test.nvimtree'.open_all() end, 'nvimtree: open_all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>de'] = { function() require 'config.test.nvimtree'.refresh_hl() end, 'nvimtree: refresh hl', mode = { 'n', 'v', }, silent = true, },
    ['<leader>da'] = { function() require 'config.test.nvimtree'.ausize_toggle() end, 'nvimtree: ausize toggle', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dc'] = { function() require 'config.test.nvimtree'.toggle_cur_root() end, 'nvimtree: toggle cur root', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dr'] = { function() require 'config.test.nvimtree'.reset_nvimtree() end, 'nvimtree: reset nvimtree', mode = { 'n', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.others()
  require 'base'.lazy_map {
  }
end

function M.all(force)
  if M.loaded and not force then
    return
  end
  M.loaded = 1
  M.base()
  M.yank()
  M.toggle()
  M.lsp()
  M.git()
  M.q()
  M.leader_d()
  M.others()
end

return M
