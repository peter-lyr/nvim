-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/15 13:42:54 Friday

local M = {}

local start_time = vim.fn.reltime()

local wk = require 'which-key'

local r = wk.register

r {
  ['<F9>'] = { name = '+my.box.yank', },
}

r {
  ['<F9>a']     = { function() require 'config.my.box'.yank('a', 'n', 'w') end, 'my.box.yank: <cword> to a', mode = { 'n', }, silent = true, },
  ['<F9>b']     = { function() require 'config.my.box'.yank('b', 'n', 'w') end, 'my.box.yank: <cword> to b', mode = { 'n', }, silent = true, },
  ['<F9>c']     = { function() require 'config.my.box'.yank('c', 'n', 'w') end, 'my.box.yank: <cword> to c', mode = { 'n', }, silent = true, },
  ['<F9>d']     = { function() require 'config.my.box'.yank('d', 'n', 'w') end, 'my.box.yank: <cword> to d', mode = { 'n', }, silent = true, },
  ['<F9>e']     = { function() require 'config.my.box'.yank('e', 'n', 'w') end, 'my.box.yank: <cword> to e', mode = { 'n', }, silent = true, },
  ['<F9>f']     = { function() require 'config.my.box'.yank('f', 'n', 'w') end, 'my.box.yank: <cword> to f', mode = { 'n', }, silent = true, },
  ['<F9>g']     = { function() require 'config.my.box'.yank('g', 'n', 'w') end, 'my.box.yank: <cword> to g', mode = { 'n', }, silent = true, },
  ['<F9>h']     = { function() require 'config.my.box'.yank('h', 'n', 'w') end, 'my.box.yank: <cword> to h', mode = { 'n', }, silent = true, },
  ['<F9>i']     = { function() require 'config.my.box'.yank('i', 'n', 'w') end, 'my.box.yank: <cword> to i', mode = { 'n', }, silent = true, },
  ['<F9>j']     = { function() require 'config.my.box'.yank('j', 'n', 'w') end, 'my.box.yank: <cword> to j', mode = { 'n', }, silent = true, },
  ['<F9>k']     = { function() require 'config.my.box'.yank('k', 'n', 'w') end, 'my.box.yank: <cword> to k', mode = { 'n', }, silent = true, },
  ['<F9>l']     = { function() require 'config.my.box'.yank('l', 'n', 'w') end, 'my.box.yank: <cword> to l', mode = { 'n', }, silent = true, },
  ['<F9>m']     = { function() require 'config.my.box'.yank('m', 'n', 'w') end, 'my.box.yank: <cword> to m', mode = { 'n', }, silent = true, },
  ['<F9>n']     = { function() require 'config.my.box'.yank('n', 'n', 'w') end, 'my.box.yank: <cword> to n', mode = { 'n', }, silent = true, },
  ['<F9>o']     = { function() require 'config.my.box'.yank('o', 'n', 'w') end, 'my.box.yank: <cword> to o', mode = { 'n', }, silent = true, },
  ['<F9>p']     = { function() require 'config.my.box'.yank('p', 'n', 'w') end, 'my.box.yank: <cword> to p', mode = { 'n', }, silent = true, },
  ['<F9>q']     = { function() require 'config.my.box'.yank('q', 'n', 'w') end, 'my.box.yank: <cword> to q', mode = { 'n', }, silent = true, },
  ['<F9>r']     = { function() require 'config.my.box'.yank('r', 'n', 'w') end, 'my.box.yank: <cword> to r', mode = { 'n', }, silent = true, },
  ['<F9>s']     = { function() require 'config.my.box'.yank('s', 'n', 'w') end, 'my.box.yank: <cword> to s', mode = { 'n', }, silent = true, },
  ['<F9>t']     = { function() require 'config.my.box'.yank('t', 'n', 'w') end, 'my.box.yank: <cword> to t', mode = { 'n', }, silent = true, },
  ['<F9>u']     = { function() require 'config.my.box'.yank('u', 'n', 'w') end, 'my.box.yank: <cword> to u', mode = { 'n', }, silent = true, },
  ['<F9>v']     = { function() require 'config.my.box'.yank('v', 'n', 'w') end, 'my.box.yank: <cword> to v', mode = { 'n', }, silent = true, },
  ['<F9>w']     = { function() require 'config.my.box'.yank('w', 'n', 'w') end, 'my.box.yank: <cword> to w', mode = { 'n', }, silent = true, },
  ['<F9>x']     = { function() require 'config.my.box'.yank('x', 'n', 'w') end, 'my.box.yank: <cword> to x', mode = { 'n', }, silent = true, },
  ['<F9>y']     = { function() require 'config.my.box'.yank('y', 'n', 'w') end, 'my.box.yank: <cword> to y', mode = { 'n', }, silent = true, },
  ['<F9>z']     = { function() require 'config.my.box'.yank('z', 'n', 'w') end, 'my.box.yank: <cword> to z', mode = { 'n', }, silent = true, },
  ['<F9><c-a>'] = { function() require 'config.my.box'.yank('a', 'n', 'W') end, 'my.box.yank: <cWORD> to a', mode = { 'n', }, silent = true, },
  ['<F9><c-b>'] = { function() require 'config.my.box'.yank('b', 'n', 'W') end, 'my.box.yank: <cWORD> to b', mode = { 'n', }, silent = true, },
  ['<F9><c-c>'] = { function() require 'config.my.box'.yank('c', 'n', 'W') end, 'my.box.yank: <cWORD> to c', mode = { 'n', }, silent = true, },
  ['<F9><c-d>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to d', mode = { 'n', }, silent = true, },
  ['<F9><c-e>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to e', mode = { 'n', }, silent = true, },
  ['<F9><c-f>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to f', mode = { 'n', }, silent = true, },
  ['<F9><c-g>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to g', mode = { 'n', }, silent = true, },
  ['<F9><c-h>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to h', mode = { 'n', }, silent = true, },
  ['<F9><c-i>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to i', mode = { 'n', }, silent = true, },
  ['<F9><c-j>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to j', mode = { 'n', }, silent = true, },
  ['<F9><c-k>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to k', mode = { 'n', }, silent = true, },
  ['<F9><c-l>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to l', mode = { 'n', }, silent = true, },
  ['<F9><c-m>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to m', mode = { 'n', }, silent = true, },
  ['<F9><c-n>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to n', mode = { 'n', }, silent = true, },
  ['<F9><c-o>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to o', mode = { 'n', }, silent = true, },
  ['<F9><c-p>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to p', mode = { 'n', }, silent = true, },
  ['<F9><c-q>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to q', mode = { 'n', }, silent = true, },
  ['<F9><c-r>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to r', mode = { 'n', }, silent = true, },
  ['<F9><c-s>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to s', mode = { 'n', }, silent = true, },
  ['<F9><c-t>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to t', mode = { 'n', }, silent = true, },
  ['<F9><c-u>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to u', mode = { 'n', }, silent = true, },
  ['<F9><c-v>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to v', mode = { 'n', }, silent = true, },
  ['<F9><c-w>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to w', mode = { 'n', }, silent = true, },
  ['<F9><c-x>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to x', mode = { 'n', }, silent = true, },
  ['<F9><c-y>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to y', mode = { 'n', }, silent = true, },
  ['<F9><c-z>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to z', mode = { 'n', }, silent = true, },
}

r {
  ['<F9>a'] = { function() require 'config.my.box'.yank('a', 'v') end, 'my.box.yank: sel to a', mode = { 'v', }, silent = true, },
  ['<F9>b'] = { function() require 'config.my.box'.yank('b', 'v') end, 'my.box.yank: sel to b', mode = { 'v', }, silent = true, },
  ['<F9>c'] = { function() require 'config.my.box'.yank('c', 'v') end, 'my.box.yank: sel to c', mode = { 'v', }, silent = true, },
  ['<F9>d'] = { function() require 'config.my.box'.yank('d', 'v') end, 'my.box.yank: sel to d', mode = { 'v', }, silent = true, },
  ['<F9>e'] = { function() require 'config.my.box'.yank('e', 'v') end, 'my.box.yank: sel to e', mode = { 'v', }, silent = true, },
  ['<F9>f'] = { function() require 'config.my.box'.yank('f', 'v') end, 'my.box.yank: sel to f', mode = { 'v', }, silent = true, },
  ['<F9>g'] = { function() require 'config.my.box'.yank('g', 'v') end, 'my.box.yank: sel to g', mode = { 'v', }, silent = true, },
  ['<F9>h'] = { function() require 'config.my.box'.yank('h', 'v') end, 'my.box.yank: sel to h', mode = { 'v', }, silent = true, },
  ['<F9>i'] = { function() require 'config.my.box'.yank('i', 'v') end, 'my.box.yank: sel to i', mode = { 'v', }, silent = true, },
  ['<F9>j'] = { function() require 'config.my.box'.yank('j', 'v') end, 'my.box.yank: sel to j', mode = { 'v', }, silent = true, },
  ['<F9>k'] = { function() require 'config.my.box'.yank('k', 'v') end, 'my.box.yank: sel to k', mode = { 'v', }, silent = true, },
  ['<F9>l'] = { function() require 'config.my.box'.yank('l', 'v') end, 'my.box.yank: sel to l', mode = { 'v', }, silent = true, },
  ['<F9>m'] = { function() require 'config.my.box'.yank('m', 'v') end, 'my.box.yank: sel to m', mode = { 'v', }, silent = true, },
  ['<F9>n'] = { function() require 'config.my.box'.yank('n', 'v') end, 'my.box.yank: sel to n', mode = { 'v', }, silent = true, },
  ['<F9>o'] = { function() require 'config.my.box'.yank('o', 'v') end, 'my.box.yank: sel to o', mode = { 'v', }, silent = true, },
  ['<F9>p'] = { function() require 'config.my.box'.yank('p', 'v') end, 'my.box.yank: sel to p', mode = { 'v', }, silent = true, },
  ['<F9>q'] = { function() require 'config.my.box'.yank('q', 'v') end, 'my.box.yank: sel to q', mode = { 'v', }, silent = true, },
  ['<F9>r'] = { function() require 'config.my.box'.yank('r', 'v') end, 'my.box.yank: sel to r', mode = { 'v', }, silent = true, },
  ['<F9>s'] = { function() require 'config.my.box'.yank('s', 'v') end, 'my.box.yank: sel to s', mode = { 'v', }, silent = true, },
  ['<F9>t'] = { function() require 'config.my.box'.yank('t', 'v') end, 'my.box.yank: sel to t', mode = { 'v', }, silent = true, },
  ['<F9>u'] = { function() require 'config.my.box'.yank('u', 'v') end, 'my.box.yank: sel to u', mode = { 'v', }, silent = true, },
  ['<F9>v'] = { function() require 'config.my.box'.yank('v', 'v') end, 'my.box.yank: sel to v', mode = { 'v', }, silent = true, },
  ['<F9>w'] = { function() require 'config.my.box'.yank('w', 'v') end, 'my.box.yank: sel to w', mode = { 'v', }, silent = true, },
  ['<F9>x'] = { function() require 'config.my.box'.yank('x', 'v') end, 'my.box.yank: sel to x', mode = { 'v', }, silent = true, },
  ['<F9>y'] = { function() require 'config.my.box'.yank('y', 'v') end, 'my.box.yank: sel to y', mode = { 'v', }, silent = true, },
  ['<F9>z'] = { function() require 'config.my.box'.yank('z', 'v') end, 'my.box.yank: sel to z', mode = { 'v', }, silent = true, },
}

local end_time = vim.fn.reltimefloat(vim.fn.reltime(start_time))
local startup_time = string.format('wk.register time: %.3f ms', end_time * 1000)
print(vim.g.startup_time .. ', ' .. startup_time)

return M
