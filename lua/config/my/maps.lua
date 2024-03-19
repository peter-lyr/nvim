-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 20:10:17 星期六

local M = {}

local r = require 'which-key'.register

function M._s()
  return vim.fn.reltime()
end

function M._e(start_time)
  return vim.fn.reltimefloat(vim.fn.reltime(start_time))
end

function M._c(end_time, name)
  Notify(string.format('%s: %.3f ms', name, end_time * 1000), end_time * 1000)
end

function M.base()
  local start_time = M._s()
  r {
    ['<c-;>'] = { function()
      local B = require 'base'
      if not B.commands then
        B.create_user_command_with_M(BaseCommand())
      end
      B.all_commands()
    end, 'base: all commands', mode = { 'n', 'v', }, silent = true, },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M._m(items)
  for _, item in ipairs(items) do
    local lhs = table.remove(item, 1)
    if not item['name'] then
      item[#item + 1] = item['desc']
    end
    r { [lhs] = item, }
  end
end

function M.box()
  local start_time = M._s()
  M._m {
    { '<leader>a', name = 'my.box', },
  }
  M._m {
    { '<F2>', function() require 'config.my.box'.replace_two_words 'n' end,   mode = { 'n', }, silent = true, desc = 'switch two words prepare', },
    { '<F2>', function() require 'config.my.box'.replace_two_words 'v' end,   mode = { 'v', }, silent = true, desc = 'switch two words prepare', },
    { '<F3>', function() require 'config.my.box'.replace_two_words_2 'n' end, mode = { 'n', }, silent = true, desc = 'switch two words do', },
    { '<F3>', function() require 'config.my.box'.replace_two_words_2 'v' end, mode = { 'v', }, silent = true, desc = 'switch two words do', },
  }
  M._m {
    { '<leader>as',      name = 'nvim-qt/programs', },
    { '<leader>as;',     function() require 'config.my.box'.start_new_nvim_qt_cfile() end,      mode = { 'n', 'v', }, silent = true, desc = 'start new nvim-qt and open <cfile>', },
    { '<leader>as<c-p>', function() require 'config.my.box'.sel_open_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel open programs file force', },
    { '<leader>as<c-k>', function() require 'config.my.box'.sel_kill_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel kill programs file force', },
    { '<leader>ass',     function() require 'config.my.box'.sel_open_startup_file() end,        mode = { 'n', 'v', }, silent = true, desc = 'sel open startup file', },
    { '<leader>aa',      function() require 'config.my.box'.source() end,                       mode = { 'n', 'v', }, silent = true, desc = 'source', },
    { '<leader>ax',      function() require 'config.my.box'.type_execute_output() end,          mode = { 'n', 'v', }, silent = true, desc = 'execute output to and open file', },
    { '<leader>ac',      function() require 'config.my.box'.mes_clear() end,                    mode = { 'n', 'v', }, silent = true, desc = 'mes clear', },
  }
  M._m {
    { '<leader>ao',  name = 'open', },
    { '<leader>aop', function() require 'config.my.box'.open_path() end,  mode = { 'n', 'v', }, silent = true, desc = 'open path', },
    { '<leader>aos', function() require 'config.my.box'.open_sound() end, mode = { 'n', 'v', }, silent = true, desc = 'open sound', },
    { '<leader>aof', function() require 'config.my.box'.open_file() end,  mode = { 'n', 'v', }, silent = true, desc = 'open file in clipboard', },
  }
  M._m {
    { '<leader>am',  name = 'monitor', },
    { '<leader>am1', function() require 'config.my.box'.monitor_1min() end,   mode = { 'n', 'v', }, silent = true, desc = 'monitor 1 min', },
    { '<leader>am3', function() require 'config.my.box'.monitor_30min() end,  mode = { 'n', 'v', }, silent = true, desc = 'monitor 30 min', },
    { '<leader>am5', function() require 'config.my.box'.monitor_5hours() end, mode = { 'n', 'v', }, silent = true, desc = 'monitor 5 hours', },
  }
  M._m {
    { '<leader>ap',  name = 'prx', },
    { '<leader>apo', function() require 'config.my.box'.proxy_on() end,  mode = { 'n', 'v', }, silent = true, desc = 'prx on', },
    { '<leader>apf', function() require 'config.my.box'.proxy_off() end, mode = { 'n', 'v', }, silent = true, desc = 'prx off', },
  }
  M._m {
    { '<leader>ag',  name = 'git', },
    { '<leader>agm', function() require 'config.my.box'.git_init_and_cmake() end, mode = { 'n', 'v', }, silent = true, desc = 'git init and cmake', },
  }
  M._m {
    { '<leader>aq',  name = 'qf make conv', },
    { '<leader>aq8', function() require 'config.my.box'.qfmakeconv2utf8() end,  mode = { 'n', 'v', }, silent = true, desc = 'qf makeconv 2 utf8', },
    { '<leader>aq9', function() require 'config.my.box'.qfmakeconv2cp936() end, mode = { 'n', 'v', }, silent = true, desc = 'qf makeconv 2 cp936', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.copy()
  local start_time = M._s()
  M._m {
    { '<leader>y', name = 'copy to clipboard', },
  }
  M._m {
    { '<leader>yf',  name = 'absolute path', },
    { '<leader>yff', function() require 'config.my.copy'.full_name() end, mode = { 'n', 'v', }, silent = true, desc = 'full name', },
    { '<leader>yft', function() require 'config.my.copy'.full_tail() end, mode = { 'n', 'v', }, silent = true, desc = 'full tail', },
    { '<leader>yfh', function() require 'config.my.copy'.full_head() end, mode = { 'n', 'v', }, silent = true, desc = 'full head', },
  }
  M._m {
    { '<leader>yr',  name = 'relative path', },
    { '<leader>yrr', function() require 'config.my.copy'.rela_name() end, mode = { 'n', 'v', }, silent = true, desc = 'rela name', },
    { '<leader>yrh', function() require 'config.my.copy'.rela_head() end, mode = { 'n', 'v', }, silent = true, desc = 'rela head', },
    { '<leader>yrc', function() require 'config.my.copy'.cur_root() end,  mode = { 'n', 'v', }, silent = true, desc = 'telescope cur root', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.yank()
  local start_time = M._s()
  r {
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
  r {
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
  r {
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
  r {
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
  r {
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
  r {
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
  r {
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
  r {
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
  r {
    ['<F9><F2>'] = { function() require 'config.my.yank'.stack('n', 'w') end, 'yank <cword> to pool', mode = { 'n', }, silent = true, },
    ['<F9><F3>'] = { function() require 'config.my.yank'.stack('n', 'W') end, 'yank <cWORD> to pool', mode = { 'n', }, silent = true, },
  }
  r {
    ['<F9><F2>'] = { function() require 'config.my.yank'.stack('v', 'w') end, 'yank <cword> to pool', mode = { 'v', }, silent = true, },
    ['<F9><F3>'] = { function() require 'config.my.yank'.stack('v', 'W') end, 'yank <cWORD> to pool', mode = { 'v', }, silent = true, },
  }
  r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'n' end, 'sel paste from pool', mode = { 'n', }, silent = true, },
  }
  r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'v' end, 'sel paste from pool', mode = { 'v', }, silent = true, },
  }
  r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'i' end, 'sel paste from pool', mode = { 'i', }, silent = true, },
  }
  r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'c' end, 'sel paste from pool', mode = { 'c', }, silent = true, },
  }
  r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 't' end, 'sel paste from pool', mode = { 't', }, silent = true, },
  }
  r {
    ['<F9><F1><F1>'] = { function() require 'config.my.yank'.clipboard_from_pool() end, 'sel from pool to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  r {
    ['<F9><c-F4>'] = { function() require 'config.my.yank'.delete_pool() end, 'delete pool', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.window()
  local start_time = M._s()
  M._m {
    { '<leader>w',        name = 'window jump/split/new', },
    { '<leader>wa',       function() require 'config.my.window'.change_around 'h' end,   mode = { 'n', 'v', }, desc = 'change with window left', },
    { '<leader>ws',       function() require 'config.my.window'.change_around 'j' end,   mode = { 'n', 'v', }, desc = 'change with window down', },
    { '<leader>ww',       function() require 'config.my.window'.change_around 'k' end,   mode = { 'n', 'v', }, desc = 'change with window up', },
    { '<leader>wd',       function() require 'config.my.window'.change_around 'l' end,   mode = { 'n', 'v', }, desc = 'change with window right', },
    { '<leader>wt',       '<c-w>t',                                                      mode = { 'n', 'v', }, desc = 'go topleft window', },
    { '<leader>wq',       '<c-w>p',                                                      mode = { 'n', 'v', }, desc = 'go toggle last window', },
    { '<leader>w;',       function() require 'config.my.window'.toggle_max_height() end, mode = { 'n', 'v', }, desc = 'toggle max height', },
    { '<leader>wu',       ':<c-u>leftabove new<cr>',                                     mode = { 'n', 'v', }, desc = 'create new window up', },
    { '<leader>wi',       ':<c-u>new<cr>',                                               mode = { 'n', 'v', }, desc = 'create new window down', },
    { '<leader>wo',       ':<c-u>leftabove vnew<cr>',                                    mode = { 'n', 'v', }, desc = 'create new window left', },
    { '<leader>wp',       ':<c-u>vnew<cr>',                                              mode = { 'n', 'v', }, desc = 'create new window right', },
    { '<leader>w<left>',  '<c-w>v<c-w>h',                                                mode = { 'n', 'v', }, desc = 'split to window up', },
    { '<leader>w<down>',  '<c-w>s',                                                      mode = { 'n', 'v', }, desc = 'split to window down', },
    { '<leader>w<up>',    '<c-w>s<c-w>k',                                                mode = { 'n', 'v', }, desc = 'split to window left', },
    { '<leader>w<right>', '<c-w>v',                                                      mode = { 'n', 'v', }, desc = 'split to window right', },
    { '<leader>wc',       '<c-w>H',                                                      mode = { 'n', 'v', }, desc = 'be most window up', },
    { '<leader>wv',       '<c-w>J',                                                      mode = { 'n', 'v', }, desc = 'be most window down', },
    { '<leader>wf',       '<c-w>K',                                                      mode = { 'n', 'v', }, desc = 'be most window left', },
    { '<leader>wb',       '<c-w>L',                                                      mode = { 'n', 'v', }, desc = 'be most window right', },
    { '<leader>wn',       '<c-w>w',                                                      mode = { 'n', 'v', }, desc = 'go next window', },
    { '<leader>wg',       '<c-w>W',                                                      mode = { 'n', 'v', }, desc = 'go prev window', },
    { '<leader>wz',       function() require 'config.my.window'.go_last_window() end,    mode = { 'n', 'v', }, desc = 'go last window', },
  }
  M._m {
    { '<leader>x',      name = 'window bdelete/bwipeout', },
    { '<leader>xh',     function() require 'config.my.window'.close_win_left() end,    mode = { 'n', 'v', }, desc = 'close window left', },
    { '<leader>xj',     function() require 'config.my.window'.close_win_down() end,    mode = { 'n', 'v', }, desc = 'close window down', },
    { '<leader>xk',     function() require 'config.my.window'.close_win_up() end,      mode = { 'n', 'v', }, desc = 'close window up', },
    { '<leader>xl',     function() require 'config.my.window'.close_win_right() end,   mode = { 'n', 'v', }, desc = 'close window right', },
    { '<leader>xt',     function() require 'config.my.window'.close_cur_tab() end,     mode = { 'n', 'v', }, desc = 'close window current', },
    { '<leader>xw',     function() require 'config.my.window'.Bwipeout_cur() end,      mode = { 'n', 'v', }, desc = 'Bwipeout current buffer', },
    { '<leader>x<c-w>', function() require 'config.my.window'.bwipeout_cur() end,      mode = { 'n', 'v', }, desc = 'bwipeout current buffer', },
    { '<leader>xW',     function() require 'config.my.window'.bwipeout_cur() end,      mode = { 'n', 'v', }, desc = 'bwipeout current buffer', },
    { '<leader>xd',     function() require 'config.my.window'.Bdelete_cur() end,       mode = { 'n', 'v', }, desc = 'Bdelete current buffer', },
    { '<leader>x<c-d>', function() require 'config.my.window'.bdelete_cur() end,       mode = { 'n', 'v', }, desc = 'bdelete current buffer', },
    { '<leader>xD',     function() require 'config.my.window'.bdelete_cur() end,       mode = { 'n', 'v', }, desc = 'bdelete current buffer', },
    { '<leader>xc',     function() require 'config.my.window'.close_cur() end,         mode = { 'n', 'v', }, desc = 'close current buffer', },
    { '<leader>xp',     function() require 'config.my.window'.bdelete_cur_proj() end,  mode = { 'n', 'v', }, desc = 'bdelete current proj files', },
    { '<leader>x<c-p>', function() require 'config.my.window'.bwipeout_cur_proj() end, mode = { 'n', 'v', }, desc = 'bwipeout current proj files', },
    { '<leader>xP',     function() require 'config.my.window'.bwipeout_cur_proj() end, mode = { 'n', 'v', }, desc = 'bwipeout current proj files', },
    { '<leader>x<del>', function() require 'config.my.window'.bwipeout_deleted() end,  mode = { 'n', 'v', }, desc = 'bwipeout buffers deleted', },
    { '<leader>x<cr>',  function() require 'config.my.window'.reopen_deleted() end,    mode = { 'n', 'v', }, desc = 'sel reopen buffers deleted', },
    { '<leader>xu',     function() require 'config.my.window'.bwipeout_unloaded() end, mode = { 'n', 'v', }, desc = 'bdelete buffers unloaded', },
  }
  M._m {
    { '<leader>xo',      name = 'window other bdelete/bwipeout', },
    { '<leader>xow',     function() require 'config.my.window'.Bwipeout_other() end,            mode = { 'n', 'v', }, desc = 'Bwipeout other buffers', },
    { '<leader>xo<c-w>', function() require 'config.my.window'.bwipeout_other() end,            mode = { 'n', 'v', }, desc = 'bwipeout other buffers', },
    { '<leader>xoW',     function() require 'config.my.window'.bwipeout_other() end,            mode = { 'n', 'v', }, desc = 'bwipeout other buffers', },
    { '<leader>xod',     function() require 'config.my.window'.Bdelete_other() end,             mode = { 'n', 'v', }, desc = 'Bdelete other buffers', },
    { '<leader>xo<c-d>', function() require 'config.my.window'.bdelete_other() end,             mode = { 'n', 'v', }, desc = 'bdelete other buffers', },
    { '<leader>xoD',     function() require 'config.my.window'.bdelete_other() end,             mode = { 'n', 'v', }, desc = 'bdelete other buffers', },
    { '<leader>xop',     function() require 'config.my.window'.bdelete_other_proj() end,        mode = { 'n', 'v', }, desc = 'bdelete other proj buffers', },
    { '<leader>xo<c-p>', function() require 'config.my.window'.bwipeout_other_proj() end,       mode = { 'n', 'v', }, desc = 'bwipeout other proj buffers', },
    { '<leader>xoP',     function() require 'config.my.window'.bwipeout_other_proj() end,       mode = { 'n', 'v', }, desc = 'bwipeout other proj buffers', },
    { '<leader>xoh',     function() require 'config.my.window'.bdelete_proj 'h' end,            mode = { 'n', 'v', }, desc = 'bdelete proj up', },
    { '<leader>xoj',     function() require 'config.my.window'.bdelete_proj 'j' end,            mode = { 'n', 'v', }, desc = 'bdelete proj down', },
    { '<leader>xok',     function() require 'config.my.window'.bdelete_proj 'k' end,            mode = { 'n', 'v', }, desc = 'bdelete proj left', },
    { '<leader>xol',     function() require 'config.my.window'.bdelete_proj 'l' end,            mode = { 'n', 'v', }, desc = 'bdelete proj right', },
    { '<leader>xo<c-h>', function() require 'config.my.window'.bwipeout_proj 'h' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj up', },
    { '<leader>xo<c-j>', function() require 'config.my.window'.bwipeout_proj 'j' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj down', },
    { '<leader>xo<c-k>', function() require 'config.my.window'.bwipeout_proj 'k' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj left', },
    { '<leader>xo<c-l>', function() require 'config.my.window'.bwipeout_proj 'l' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj right', },
    { '<leader>xoH',     function() require 'config.my.window'.bwipeout_proj 'h' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj up', },
    { '<leader>xoJ',     function() require 'config.my.window'.bwipeout_proj 'j' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj down', },
    { '<leader>xoK',     function() require 'config.my.window'.bwipeout_proj 'k' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj left', },
    { '<leader>xoL',     function() require 'config.my.window'.bwipeout_proj 'l' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj right', },
    { '<leader>xor',     function() require 'config.my.window'.bdelete_ex_cur_root() end,       mode = { 'n', 'v', }, desc = 'bdelete buffers exclude cur_root', },
    { '<leader>xr',      function() require 'config.my.window'.listed_cur_root_files() end,     mode = { 'n', 'v', }, desc = 'listed cur root buffers', },
    { '<leader>x<c-r>',  function() require 'config.my.window'.listed_cur_root_files 'all' end, mode = { 'n', 'v', }, desc = 'listed cur root buffers all', },
  }
  M._m {
    { '<a-h>',   function() vim.cmd 'wincmd <' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less_1', },
    { '<a-l>',   function() vim.cmd 'wincmd >' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more_1', },
    { '<a-j>',   function() vim.cmd 'wincmd -' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less_1', },
    { '<a-k>',   function() vim.cmd 'wincmd +' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more_1', },

    { '<a-s-h>', function() vim.cmd '10wincmd <' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less_10', },
    { '<a-s-l>', function() vim.cmd '10wincmd >' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more_10', },
    { '<a-s-j>', function() vim.cmd '10wincmd -' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less_10', },
    { '<a-s-k>', function() vim.cmd '10wincmd +' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more_10', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.toggle()
  local start_time = M._s()
  M._m {
    { '<leader>t',  name = 'toggle', },
    { '<leader>td', function() require 'config.my.toggle'.diff() end,         mode = { 'n', 'v', }, silent = true, desc = 'diff', },
    { '<leader>tw', function() require 'config.my.toggle'.wrap() end,         mode = { 'n', 'v', }, silent = true, desc = 'wrap', },
    { '<leader>tn', function() require 'config.my.toggle'.nu() end,           mode = { 'n', 'v', }, silent = true, desc = 'nu', },
    { '<leader>tr', function() require 'config.my.toggle'.renu() end,         mode = { 'n', 'v', }, silent = true, desc = 'renu', },
    { '<leader>ts', function() require 'config.my.toggle'.signcolumn() end,   mode = { 'n', 'v', }, silent = true, desc = 'signcolumn', },
    { '<leader>tc', function() require 'config.my.toggle'.conceallevel() end, mode = { 'n', 'v', }, silent = true, desc = 'conceallevel', },
    { '<leader>tk', function() require 'config.my.toggle'.iskeyword() end,    mode = { 'n', 'v', }, silent = true, desc = 'iskeyword', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.hili()
  local start_time = M._s()
  M._m {
    { '*',       function() require 'config.my.hili'.search() end,          mode = { 'v', },      silent = true, desc = 'hili: multiline search', },
    -- windo cursorword
    { '<a-7>',   function() require 'config.my.hili'.cursorword() end,      mode = { 'n', },      silent = true, desc = 'hili: cursor word', },
    { '<a-8>',   function() require 'config.my.hili'.windocursorword() end, mode = { 'n', },      silent = true, desc = 'hili: windo cursor word', },
    -- cword hili
    { '<c-8>',   function() require 'config.my.hili'.hili_n() end,          mode = { 'n', },      silent = true, desc = 'hili: cword', },
    { '<c-8>',   function() require 'config.my.hili'.hili_v() end,          mode = { 'v', },      silent = true, desc = 'hili: cword', },
    -- cword hili rm
    { '<c-s-8>', function() require 'config.my.hili'.rmhili_v() end,        mode = { 'v', },      silent = true, desc = 'hili: rm v', },
    { '<c-s-8>', function() require 'config.my.hili'.rmhili_n() end,        mode = { 'n', },      silent = true, desc = 'hili: rm n', },
    -- select hili
    { '<c-7>',   function() require 'config.my.hili'.selnexthili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: sel next', },
    { '<c-s-7>', function() require 'config.my.hili'.selprevhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: sel prev', },
    -- go hili
    { '<c-n>',   function() require 'config.my.hili'.prevhili() end,        mode = { 'n', 'v', }, silent = true, desc = 'hili: go prev', },
    { '<c-m>',   function() require 'config.my.hili'.nexthili() end,        mode = { 'n', 'v', }, silent = true, desc = 'hili: go next', },
    -- go cur hili
    { '<c-s-n>', function() require 'config.my.hili'.prevcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: go cur prev', },
    { '<c-s-m>', function() require 'config.my.hili'.nextcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: go cur next', },
    -- rehili
    { '<c-s-9>', function() require 'config.my.hili'.rehili() end,          mode = { 'n', 'v', }, silent = true, desc = 'hili: rehili', },
    -- search cword
    { "<c-s-'>", function() require 'config.my.hili'.prevlastcword() end,   mode = { 'n', 'v', }, silent = true, desc = 'hili: prevlastcword', },
    { '<c-s-/>', function() require 'config.my.hili'.nextlastcword() end,   mode = { 'n', 'v', }, silent = true, desc = 'hili: nextlastcword', },
    { '<c-,>',   function() require 'config.my.hili'.prevcword() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: prevcword', },
    { '<c-.>',   function() require 'config.my.hili'.nextcword() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: nextcword', },
    { "<c-'>",   function() require 'config.my.hili'.prevcWORD() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: prevcWORD', },
    { '<c-/>',   function() require 'config.my.hili'.nextcWORD() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: nextcWORD', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.svn()
  local start_time = M._s()
  vim.api.nvim_create_user_command('TortoiseSVN', function(params)
    require 'config.my.svn'.tortoisesvn(params['fargs'])
  end, { nargs = '*', })
  M._m {
    { '<leader>v',  name = 'my.svn', },
    { '<leader>vo', '<cmd>TortoiseSVN settings cur yes<cr>',     mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN settings cur yes<cr>', },
    { '<leader>vd', '<cmd>TortoiseSVN diff cur yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN diff cur yes<cr>', },
    { '<leader>vf', '<cmd>TortoiseSVN diff root yes<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN diff root yes<cr>', },
    { '<leader>vb', '<cmd>TortoiseSVN blame cur yes<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN blame cur yes<cr>', },
    { '<leader>vw', '<cmd>TortoiseSVN repobrowser cur yes<cr>',  mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repobrowser cur yes<cr>', },
    { '<leader>ve', '<cmd>TortoiseSVN repobrowser root yes<cr>', mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN repobrowser root yes<cr>', },
    { '<leader>vv', '<cmd>TortoiseSVN revert root yes<cr>',      mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN revert root yes<cr>', },
    { '<leader>va', '<cmd>TortoiseSVN add root yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN add root yes<cr>', },
    { '<leader>vc', '<cmd>TortoiseSVN commit root yes<cr>',      mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN commit root yes<cr>', },
    { '<leader>vu', '<cmd>TortoiseSVN update /rev root yes<cr>', mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN update /rev root yes<cr>', },
    { '<leader>vl', '<cmd>TortoiseSVN log cur yes<cr>',          mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN log cur yes<cr>', },
    { '<leader>v;', '<cmd>TortoiseSVN log root yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN log root yes<cr>', },
    { '<leader>vk', '<cmd>TortoiseSVN checkout root yes<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'TortoiseSVN checkout root yes<cr>', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.lsp()
  local start_time = M._s()
  M._m {
    { '<leader>f',  name = 'lsp', },
    { '<leader>fv', name = 'lsp.move', },
    { '<leader>fn', function() require 'config.nvim.lsp'.rename() end,                     mode = { 'n', 'v', }, silent = true, desc = 'lsp: rename', },
    { '<leader>fl', function() require 'config.nvim.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'telescope.lsp: document_symbols', },
    { '<leader>fr', function() require 'config.nvim.telescope'.lsp_references() end,       mode = { 'n', 'v', }, silent = true, desc = 'telescope.lsp: references', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.git()
  local start_time = M._s()
  M._m {
    { '<leader>g',         name = 'git', },
    { '<leader>gt',        name = 'git.telescope', },
    { '<leader>gtb',       function() require 'config.nvim.telescope'.git_bcommits() end,            mode = { 'n', 'v', }, silent = true, desc = 'git.telescope: bcommits', },
    { '<leader>gtc',       function() require 'config.nvim.telescope'.git_commits() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.telescope: commits', },
    { '<leader>gh',        function() require 'config.nvim.telescope'.git_branches() end,            mode = { 'n', 'v', }, silent = true, desc = 'git.telescope: branches', },
    { '<leader>gg',        name = 'git.push', },
    { '<leader>ga',        function() require 'config.my.git'.addcommitpush() end,                   mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush', },
    { '<leader>gga',       function() require 'config.my.git'.addcommitpush(nil, 1) end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush commit_history_en', },
    { '<leader>gc',        function() require 'config.my.git'.commit_push() end,                     mode = { 'n', 'v', }, silent = true, desc = 'git.push: commit_push', },
    { '<leader>ggc',       function() require 'config.my.git'.commit_push(nil, 1) end,               mode = { 'n', 'v', }, silent = true, desc = 'git.push: commit_push commit_history_en', },
    { '<leader>gp',        function() require 'config.my.git'.pull() end,                            mode = { 'n', 'v', }, silent = true, desc = 'git.push: pull', },
    { '<leader>ggp',       function() require 'config.my.git'.pull_all() end,                        mode = { 'n', 'v', }, silent = true, desc = 'git.push: pull_all', },
    { '<leader>gb',        function() require 'config.my.git'.git_browser() end,                     mode = { 'n', 'v', }, silent = true, desc = 'git.push: browser', },
    { '<leader>ggs',       function() require 'config.my.git'.push() end,                            mode = { 'n', 'v', }, silent = true, desc = 'git.push: push', },
    { '<leader>ggg',       function() require 'config.my.git'.graph_asyncrun() end,                  mode = { 'n', 'v', }, silent = true, desc = 'git.push: graph_asyncrun', },
    { '<leader>gg<c-g>',   function() require 'config.my.git'.graph_start() end,                     mode = { 'n', 'v', }, silent = true, desc = 'git.push: graph_start', },
    { '<leader>ggv',       function() require 'config.my.git'.init() end,                            mode = { 'n', 'v', }, silent = true, desc = 'git.push: init', },
    { '<leader>g<c-a>',    function() require 'config.my.git'.addall() end,                          mode = { 'n', 'v', }, silent = true, desc = 'git.push: addall', },
    { '<leader>ggr',       function() require 'config.my.git'.reset_hard() end,                      mode = { 'n', 'v', }, silent = true, desc = 'git.push: reset_hard', },
    { '<leader>ggd',       function() require 'config.my.git'.reset_hard_clean() end,                mode = { 'n', 'v', }, silent = true, desc = 'git.push: reset_hard_clean', },
    { '<leader>ggD',       function() require 'config.my.git'.clean_ignored_files_and_folders() end, mode = { 'n', 'v', }, silent = true, desc = 'git.push: clean_ignored_files_and_folders', },
    { '<leader>ggC',       function() require 'config.my.git'.clone() end,                           mode = { 'n', 'v', }, silent = true, desc = 'git.push: clone', },
    { '<leader>ggh',       function() require 'config.my.git'.show_commit_history() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: show_commit_history', },
    { '<leader>g<c-l>',    function() require 'config.my.git'.addcommitpush_curline() end,           mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush curline', },
    { '<leader>g<c-\'>',   function() require 'config.my.git'.addcommitpush_single_quote() end,      mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush single_quote', },
    { '<leader>g<c-s-\'>', function() require 'config.my.git'.addcommitpush_double_quote() end,      mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush double_quote', },
    { '<leader>g<c-0>',    function() require 'config.my.git'.addcommitpush_parentheses() end,       mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush parentheses', },
    { '<leader>g<c-]>',    function() require 'config.my.git'.addcommitpush_bracket() end,           mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush bracket', },
    { '<leader>g<c-s-]>',  function() require 'config.my.git'.addcommitpush_brace() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush brace', },
    { '<leader>g<c-`>',    function() require 'config.my.git'.addcommitpush_back_quote() end,        mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush back_quote', },
    { '<leader>g<c-s-.>',  function() require 'config.my.git'.addcommitpush_angle_bracket() end,     mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush angle_bracket', },
    { '<leader>g<c-e>',    function() require 'config.my.git'.addcommitpush_cword() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush cword', },
    { '<leader>g<c-4>',    function() require 'config.my.git'.addcommitpush_cWORD() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush cWORD', },
    { 'g',                 name = 'git.push', },
    { 'g<c-l>',            function() require 'config.my.git'.addcommitpush_curline() end,           mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush curline', },
    { 'g<c-\'>',           function() require 'config.my.git'.addcommitpush_single_quote() end,      mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush single_quote', },
    { 'g<c-s-\'>',         function() require 'config.my.git'.addcommitpush_double_quote() end,      mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush double_quote', },
    { 'g<c-0>',            function() require 'config.my.git'.addcommitpush_parentheses() end,       mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush parentheses', },
    { 'g<c-]>',            function() require 'config.my.git'.addcommitpush_bracket() end,           mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush bracket', },
    { 'g<c-s-]>',          function() require 'config.my.git'.addcommitpush_brace() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush brace', },
    { 'g<c-`>',            function() require 'config.my.git'.addcommitpush_back_quote() end,        mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush back_quote', },
    { 'g<c-s-.>',          function() require 'config.my.git'.addcommitpush_angle_bracket() end,     mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush angle_bracket', },
    { 'g<c-e>',            function() require 'config.my.git'.addcommitpush_cword() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush cword', },
    { 'g<c-4>',            function() require 'config.my.git'.addcommitpush_cWORD() end,             mode = { 'n', 'v', }, silent = true, desc = 'git.push: addcommitpush cWORD', },
    { '<leader>gv',        name = 'git.diffview', },
    { '<leader>gv1',       function() require 'config.my.git'.diffview_filehistory(1) end,           mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: filehistory 16', },
    { '<leader>gv2',       function() require 'config.my.git'.diffview_filehistory(2) end,           mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: filehistory 64', },
    { '<leader>gv3',       function() require 'config.my.git'.diffview_filehistory(3) end,           mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: filehistory finite', },
    { '<leader>gvs',       function() require 'config.my.git'.diffview_stash() end,                  mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: filehistory stash', },
    { '<leader>gvo',       function() require 'config.my.git'.diffview_open() end,                   mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: open', },
    { '<leader>gvq',       function() require 'config.my.git'.diffview_close() end,                  mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: close', },
    { '<leader>gvl',       ':<c-u>DiffviewRefresh<cr>',                                              mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: refresh', },
    { '<leader>gvw',       ':<c-u>Telescope git_diffs diff_commits<cr>',                             mode = { 'n', 'v', }, silent = true, desc = 'git.diffview: Telescope git_diffs diff_commits', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.telescope()
  local start_time = M._s()
  M._m {
    { '<leader>s',         name = 'telescope', },
    -- builtins
    { '<leader>s<leader>', function() require 'config.nvim.telescope'.find_files_all() end,        mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_all', },
    { '<leader>sd',        function() require 'config.nvim.telescope'.diagnostics() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: diagnostics', },
    { '<leader>s<c-f>',    function() require 'config.nvim.telescope'.filetypes() end,             mode = { 'n', 'v', }, silent = true, desc = 'telescope: filetypes', },
    { '<leader>sh',        function() require 'config.nvim.telescope'.search_history() end,        mode = { 'n', 'v', }, silent = true, desc = 'telescope: search_history', },
    { '<leader>sj',        function() require 'config.nvim.telescope'.jumplist() end,              mode = { 'n', 'v', }, silent = true, desc = 'telescope: jumplist', },
    { '<leader>sm',        function() require 'config.nvim.telescope'.keymaps() end,               mode = { 'n', 'v', }, silent = true, desc = 'telescope: keymaps', },
    { '<leader>sr',        function() require 'config.nvim.telescope'.root_sel_till_git() end,     mode = { 'n', 'v', }, silent = true, desc = 'telescope: root_sel_till_git', },
    { '<leader>sR',        function() require 'config.nvim.telescope'.root_sel_scan_dirs() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: root_sel_scan_dirs', },
    { '<leader>s<a-r>',    function() require 'config.nvim.telescope'.root_sel_parennt_dirs() end, mode = { 'n', 'v', }, silent = true, desc = 'telescope: root_sel_parennt_dirs', },
    { '<leader>s<c-r>',    function() require 'config.nvim.telescope'.root_sel_switch() end,       mode = { 'n', 'v', }, silent = true, desc = 'telescope: root_sel_switch', },
    { '<leader>sq',        function() require 'config.nvim.telescope'.quickfix() end,              mode = { 'n', 'v', }, silent = true, desc = 'telescope: quickfix', },
    { '<leader>sv',        name = 'telescope.more', },
    { '<leader>svv',       name = 'telescope.more', },
    { '<leader>svq',       function() require 'config.nvim.telescope'.quickfixhistory() end,       mode = { 'n', 'v', }, silent = true, desc = 'telescope: quickfixhistory', },
    { '<leader>svvc',      function() require 'config.nvim.telescope'.colorscheme() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: colorscheme', },
    { '<leader>svh',       function() require 'config.nvim.telescope'.help_tags() end,             mode = { 'n', 'v', }, silent = true, desc = 'telescope: help_tags', },
    { '<leader>sva',       function() require 'config.nvim.telescope'.autocommands() end,          mode = { 'n', 'v', }, silent = true, desc = 'telescope: autocommands', },
    { '<leader>svva',      function() require 'config.nvim.telescope'.builtin() end,               mode = { 'n', 'v', }, silent = true, desc = 'telescope: builtin', },
    { '<leader>svo',       function() require 'config.nvim.telescope'.vim_options() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: vim_options', },
    -- terminal
    { '<leader>st',        name = 'telescope.terminal', },
    { '<leader>stc',       function() require 'config.nvim.telescope'.terminal_cmd() end,          mode = { 'n', 'v', }, silent = true, desc = 'telescope.terminal: cmd', },
    { '<leader>sti',       function() require 'config.nvim.telescope'.terminal_ipython() end,      mode = { 'n', 'v', }, silent = true, desc = 'telescope.terminal: ipython', },
    { '<leader>stb',       function() require 'config.nvim.telescope'.terminal_bash() end,         mode = { 'n', 'v', }, silent = true, desc = 'telescope.terminal: bash', },
    { '<leader>stp',       function() require 'config.nvim.telescope'.terminal_powershell() end,   mode = { 'n', 'v', }, silent = true, desc = 'telescope.terminal: powershell', },
    -- open telescope.lua
    { '<leader>sO',        function() require 'config.nvim.telescope'.open_telescope_lua() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: open telescope.lua', },
    { '<leader>m',         function() require 'config.nvim.telescope'.find_files_curdir() end,     mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_curdir', },
    { '<leader><c-m>',     function() require 'config.nvim.telescope'.find_files_pardir() end,     mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_pardir', },
    { '<leader>M',         function() require 'config.nvim.telescope'.find_files_pardir_2() end,   mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_pardir_2', },
    { '<leader><c-s-m>',   function() require 'config.nvim.telescope'.find_files_pardir_3() end,   mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_pardir_3', },
    { '<leader><a-m>',     function() require 'config.nvim.telescope'.find_files_pardir_4() end,   mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_pardir_4', },
    { '<leader><a-s-m>',   function() require 'config.nvim.telescope'.find_files_pardir_5() end,   mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files_pardir_5', },
    { '<leader>e',         function() require 'config.nvim.telescope'.everything() end,            mode = { 'n', 'v', }, silent = true, desc = 'telescope: everything', },
    { '<leader><c-e>',     function() require 'config.nvim.telescope'.everything_regex() end,      mode = { 'n', 'v', }, silent = true, desc = 'telescope: everything', },
    { '<leader>p',         function() require 'config.nvim.telescope'.pure_curdir() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: pure_curdir', },
    { '<leader><c-p>',     function() require 'config.nvim.telescope'.pure_pardir() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: pure_pardir', },
    { '<leader>P',         function() require 'config.nvim.telescope'.pure_pardir_2() end,         mode = { 'n', 'v', }, silent = true, desc = 'telescope: pure_pardir_2', },
    { '<leader><c-s-p>',   function() require 'config.nvim.telescope'.pure_pardir_3() end,         mode = { 'n', 'v', }, silent = true, desc = 'telescope: pure_pardir_3', },
    { '<leader><a-p>',     function() require 'config.nvim.telescope'.pure_pardir_4() end,         mode = { 'n', 'v', }, silent = true, desc = 'telescope: pure_pardir_4', },
    { '<leader><a-s-p>',   function() require 'config.nvim.telescope'.pure_pardir_5() end,         mode = { 'n', 'v', }, silent = true, desc = 'telescope: pure_pardir_5', },
    { '<leader><c-l>',     function() require 'config.nvim.telescope'.live_grep_curdir() end,      mode = { 'n', 'v', }, silent = true, desc = 'telescope: live_grep_curdir', },
    { '<leader>L',         function() require 'config.nvim.telescope'.live_grep_pardir() end,      mode = { 'n', 'v', }, silent = true, desc = 'telescope: live_grep_pardir', },
    { '<leader><c-s-l>',   function() require 'config.nvim.telescope'.live_grep_pardir_2() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: live_grep_pardir2', },
    { '<leader><a-l>',     function() require 'config.nvim.telescope'.live_grep_pardir_3() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: live_grep_pardir3', },
    { '<leader><a-s-l>',   function() require 'config.nvim.telescope'.live_grep_pardir_4() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: live_grep_pardir4', },
    { '<leader>ss',        function() require 'config.nvim.telescope'.grep_string() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: grep_string', },
    { '<leader>s<c-s>',    function() require 'config.nvim.telescope'.grep_string_curdir() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: grep_string_curdir', },
    { '<leader>sS',        function() require 'config.nvim.telescope'.grep_string_pardir() end,    mode = { 'n', 'v', }, silent = true, desc = 'telescope: grep_string_pardir', },
    { '<leader>s<c-s-s>',  function() require 'config.nvim.telescope'.grep_string_pardir_2() end,  mode = { 'n', 'v', }, silent = true, desc = 'telescope: grep_string_pardir_2', },
    { '<leader>s<a-s>',    function() require 'config.nvim.telescope'.grep_string_pardir_3() end,  mode = { 'n', 'v', }, silent = true, desc = 'telescope: grep_string_pardir_3', },
    { '<leader>s<a-s-s>',  function() require 'config.nvim.telescope'.grep_string_pardir_4() end,  mode = { 'n', 'v', }, silent = true, desc = 'telescope: grep_string_pardir_4', },
    { '<leader>n',         function() require 'config.nvim.telescope'.commands() end,              mode = { 'n', 'v', }, silent = true, desc = 'telescope: commands', },
    { '<leader>b',         function() require 'config.nvim.telescope'.buffers_cur() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: buffers cur', },
    { '<leader><c-b>',     function() require 'config.nvim.telescope'.buffers_all() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: buffers all', },
    { '<leader>so',        function() require 'config.nvim.telescope'.oldfiles() end,              mode = { 'n', 'v', }, silent = true, desc = 'telescope: oldfiles', },
    -- mouse
    { '<c-s-f12>',         name = 'telescope', },
    { '<c-s-f12><f1>',     function() require 'config.nvim.telescope'.git_status() end,            mode = { 'n', 'v', }, silent = true, desc = 'telescope: git_status', },
    { '<c-s-f12><f2>',     function() require 'config.nvim.telescope'.buffers_cur() end,           mode = { 'n', 'v', }, silent = true, desc = 'telescope: buffers_cur', },
    { '<c-s-f12><f3>',     function() require 'config.nvim.telescope'.find_files() end,            mode = { 'n', 'v', }, silent = true, desc = 'telescope: find_files', },
    { '<c-s-f12><f4>',     function() require 'config.nvim.telescope'.jumplist() end,              mode = { 'n', 'v', }, silent = true, desc = 'telescope: jumplist', },
    { '<c-s-f12><f6>',     function() require 'config.nvim.telescope'.command_history() end,       mode = { 'n', 'v', }, silent = true, desc = 'telescope: command_history', },
    { '<c-s-f12><f7>',     function() require 'config.nvim.telescope'.lsp_document_symbols() end,  mode = { 'n', 'v', }, silent = true, desc = 'telescope.lsp: document_symbols', },
    { '<c-s-f12><f8>',     function() require 'config.nvim.telescope'.buffers() end,               mode = { 'n', 'v', }, silent = true, desc = 'telescope: buffers', },
    { '<c-s-f12><f1>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
    { '<c-s-f12><f2>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
    { '<c-s-f12><f3>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
    { '<c-s-f12><f4>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
    { '<c-s-f12><f6>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
    { '<c-s-f12><f7>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
    { '<c-s-f12><f8>',     function() require 'config.nvim.telescope'.nop() end,                   mode = { 'i', },      silent = true, desc = 'telescope: nop', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.all()
  M.base()
  M.box()
  M.copy()
  M.yank()
  M.window()
  M.toggle()
  M.hili()
  M.svn()
  M.lsp()
  M.git()
  M.telescope()
end

vim.opt.updatetime = 500

return M
