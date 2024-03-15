-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/15 13:42:54 Friday

local M = {}

local wk = require 'which-key'

wk.register {
  ['<F9>']      = { name = '+my.box.yank', },
  ['<F9>a']     = { function() require 'config.my.box'.yank('a', 'n', 'w') end, 'my.box.yank: <cword> to a', mode = { 'n', }, silent = true, },
  ['<F9><c-a>'] = { function() require 'config.my.box'.yank('a', 'n', 'W') end, 'my.box.yank: <cWORD> to a', mode = { 'n', }, silent = true, },
  ['<F9>b']     = { function() require 'config.my.box'.yank('b', 'n', 'w') end, 'my.box.yank: <cword> to b', mode = { 'n', }, silent = true, },
  ['<F9><c-b>'] = { function() require 'config.my.box'.yank('b', 'n', 'W') end, 'my.box.yank: <cWORD> to b', mode = { 'n', }, silent = true, },
  ['<F9>c']     = { function() require 'config.my.box'.yank('c', 'n', 'w') end, 'my.box.yank: <cword> to c', mode = { 'n', }, silent = true, },
  ['<F9><c-c>'] = { function() require 'config.my.box'.yank('c', 'n', 'W') end, 'my.box.yank: <cWORD> to c', mode = { 'n', }, silent = true, },
  ['<F9>d']     = { function() require 'config.my.box'.yank('d', 'n', 'w') end, 'my.box.yank: <cword> to d', mode = { 'n', }, silent = true, },
  ['<F9><c-d>'] = { function() require 'config.my.box'.yank('d', 'n', 'W') end, 'my.box.yank: <cWORD> to d', mode = { 'n', }, silent = true, },
}

wk.register {
  ['<F9>']  = { name = '+my.box.yank', },
  ['<F9>a'] = { function() require 'config.my.box'.yank('a', 'v') end, 'my.box.yank: sel to a', mode = { 'v', }, silent = true, },
  ['<F9>b'] = { function() require 'config.my.box'.yank('b', 'v') end, 'my.box.yank: sel to b', mode = { 'v', }, silent = true, },
  ['<F9>c'] = { function() require 'config.my.box'.yank('c', 'v') end, 'my.box.yank: sel to c', mode = { 'v', }, silent = true, },
  ['<F9>d'] = { function() require 'config.my.box'.yank('d', 'v') end, 'my.box.yank: sel to d', mode = { 'v', }, silent = true, },
}

return M
