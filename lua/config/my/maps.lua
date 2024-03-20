-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 20:10:17 星期六

local M = {}

M.r = require 'which-key'.register

function M.base()
  TimingBegin()
  M.r {
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
    M.r { [lhs] = item, }
  end
end

function M.box()
  TimingBegin()
  M.r {
    ['<leader>a'] = { name = 'my.box', },
  }
  M.r {
    ['<F2>'] = { function() require 'config.my.box'.replace_two_words 'v' end, 'switch two words prepare', mode = { 'v', }, silent = true, },
    ['<F3>'] = { function() require 'config.my.box'.replace_two_words_2 'v' end, 'switch two words do', mode = { 'v', }, silent = true, },
  }
  M.r {
    ['<F2>'] = { function() require 'config.my.box'.replace_two_words 'n' end, 'switch two words prepare', mode = { 'n', }, silent = true, },
    ['<F3>'] = { function() require 'config.my.box'.replace_two_words_2 'n' end, 'switch two words do', mode = { 'n', }, silent = true, },
  }
  M.r {
    ['<leader>as'] = { name = 'nvim-qt/programs', },
    ['<leader>as;'] = { function() require 'config.my.box'.start_new_nvim_qt_cfile() end, 'start new nvim-qt and open <cfile>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>as<c-p>'] = { function() require 'config.my.box'.sel_open_programs_file_force() end, 'sel open programs file force', mode = { 'n', 'v', }, silent = true, },
    ['<leader>as<c-k>'] = { function() require 'config.my.box'.sel_kill_programs_file_force() end, 'sel kill programs file force', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ass'] = { function() require 'config.my.box'.sel_open_startup_file() end, 'sel open startup file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aa'] = { function() require 'config.my.box'.source_file() end, 'source file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ax'] = { function() require 'config.my.box'.type_execute_output() end, 'execute output to and open file', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ac'] = { function() require 'config.my.box'.mes_clear() end, 'mes clear', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<leader>ao'] = { name = 'open', },
    ['<leader>aop'] = { function() require 'config.my.box'.open_path() end, 'open path', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aos'] = { function() require 'config.my.box'.open_sound() end, 'open sound', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aof'] = { function() require 'config.my.box'.open_file() end, 'open file in clipboard', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<leader>am'] = { name = 'monitor', },
    ['<leader>am1'] = { function() require 'config.my.box'.monitor_1min() end, 'monitor 1 min', mode = { 'n', 'v', }, silent = true, },
    ['<leader>am3'] = { function() require 'config.my.box'.monitor_30min() end, 'monitor 30 min', mode = { 'n', 'v', }, silent = true, },
    ['<leader>am5'] = { function() require 'config.my.box'.monitor_5hours() end, 'monitor 5 hours', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<leader>ap'] = { name = 'prx', },
    ['<leader>apo'] = { function() require 'config.my.box'.proxy_on() end, 'prx on', mode = { 'n', 'v', }, silent = true, },
    ['<leader>apf'] = { function() require 'config.my.box'.proxy_off() end, 'prx off', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<leader>ag'] = { name = 'git', },
    ['<leader>agm'] = { function() require 'config.my.box'.git_init_and_cmake() end, 'git init and cmake', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<leader>aq'] = { name = 'qf make conv', },
    ['<leader>aq8'] = { function() require 'config.my.box'.qfmakeconv2utf8() end, 'qf makeconv 2 utf8', mode = { 'n', 'v', }, silent = true, },
    ['<leader>aq9'] = { function() require 'config.my.box'.qfmakeconv2cp936() end, 'qf makeconv 2 cp936', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.copy()
  TimingBegin()
  M.r {
    ['<leader>y'] = { name = 'copy to clipboard', },
  }
  M.r {
    ['<leader>yf'] = { name = 'absolute path', },
    ['<leader>yff'] = { function() require 'config.my.copy'.full_name() end, 'full name', mode = { 'n', 'v', }, silent = true, },
    ['<leader>yft'] = { function() require 'config.my.copy'.full_tail() end, 'full tail', mode = { 'n', 'v', }, silent = true, },
    ['<leader>yfh'] = { function() require 'config.my.copy'.full_head() end, 'full head', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<leader>yr'] = { name = 'relative path', },
    ['<leader>yrr'] = { function() require 'config.my.copy'.rela_name() end, 'rela name', mode = { 'n', 'v', }, silent = true, },
    ['<leader>yrh'] = { function() require 'config.my.copy'.rela_head() end, 'rela head', mode = { 'n', 'v', }, silent = true, },
    ['<leader>yrc'] = { function() require 'config.my.copy'.cur_root() end, 'telescope cur root', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.yank()
  TimingBegin()
  M.r {
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
  M.r {
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
  M.r {
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
  M.r {
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
  M.r {
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
  M.r {
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
  M.r {
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
  M.r {
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
  M.r {
    ['<F9><F2>'] = { function() require 'config.my.yank'.stack('n', 'w') end, 'yank <cword> to pool', mode = { 'n', }, silent = true, },
    ['<F9><F3>'] = { function() require 'config.my.yank'.stack('n', 'W') end, 'yank <cWORD> to pool', mode = { 'n', }, silent = true, },
  }
  M.r {
    ['<F9><F2>'] = { function() require 'config.my.yank'.stack('v', 'w') end, 'yank <cword> to pool', mode = { 'v', }, silent = true, },
    ['<F9><F3>'] = { function() require 'config.my.yank'.stack('v', 'W') end, 'yank <cWORD> to pool', mode = { 'v', }, silent = true, },
  }
  M.r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'n' end, 'sel paste from pool', mode = { 'n', }, silent = true, },
  }
  M.r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'v' end, 'sel paste from pool', mode = { 'v', }, silent = true, },
  }
  M.r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'i' end, 'sel paste from pool', mode = { 'i', }, silent = true, },
  }
  M.r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 'c' end, 'sel paste from pool', mode = { 'c', }, silent = true, },
  }
  M.r {
    ['<F9><F4>'] = { function() require 'config.my.yank'.paste_from_stack 't' end, 'sel paste from pool', mode = { 't', }, silent = true, },
  }
  M.r {
    ['<F9><F1><F1>'] = { function() require 'config.my.yank'.clipboard_from_pool() end, 'sel from pool to clipboard', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  M.r {
    ['<F9><c-F4>'] = { function() require 'config.my.yank'.delete_pool() end, 'delete pool', mode = { 'n', 'v', 'i', 'c', 't', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.window()
  TimingBegin()
  M.r {
    ['<leader>w'] = { name = 'window jump/split/new', },
    ['<leader>wa'] = { function() require 'config.my.window'.change_around 'h' end, 'change with window left', mode = { 'n', 'v', }, },
    ['<leader>ws'] = { function() require 'config.my.window'.change_around 'j' end, 'change with window down', mode = { 'n', 'v', }, },
    ['<leader>ww'] = { function() require 'config.my.window'.change_around 'k' end, 'change with window up', mode = { 'n', 'v', }, },
    ['<leader>wd'] = { function() require 'config.my.window'.change_around 'l' end, 'change with window right', mode = { 'n', 'v', }, },
    ['<leader>wt'] = { '<c-w>t', 'go topleft window', mode = { 'n', 'v', }, },
    ['<leader>wq'] = { '<c-w>p', 'go toggle last window', mode = { 'n', 'v', }, },
    ['<leader>w;'] = { function() require 'config.my.window'.toggle_max_height() end, 'toggle max height', mode = { 'n', 'v', }, },
    ['<leader>wu'] = { ':<c-u>leftabove new<cr>', 'create new window up', mode = { 'n', 'v', }, },
    ['<leader>wi'] = { ':<c-u>new<cr>', 'create new window down', mode = { 'n', 'v', }, },
    ['<leader>wo'] = { ':<c-u>leftabove vnew<cr>', 'create new window left', mode = { 'n', 'v', }, },
    ['<leader>wp'] = { ':<c-u>vnew<cr>', 'create new window right', mode = { 'n', 'v', }, },
    ['<leader>w<left>'] = { '<c-w>v<c-w>h', 'split to window up', mode = { 'n', 'v', }, },
    ['<leader>w<down>'] = { '<c-w>s', 'split to window down', mode = { 'n', 'v', }, },
    ['<leader>w<up>'] = { '<c-w>s<c-w>k', 'split to window left', mode = { 'n', 'v', }, },
    ['<leader>w<right>'] = { '<c-w>v', 'split to window right', mode = { 'n', 'v', }, },
    ['<leader>wc'] = { '<c-w>H', 'be most window up', mode = { 'n', 'v', }, },
    ['<leader>wv'] = { '<c-w>J', 'be most window down', mode = { 'n', 'v', }, },
    ['<leader>wf'] = { '<c-w>K', 'be most window left', mode = { 'n', 'v', }, },
    ['<leader>wb'] = { '<c-w>L', 'be most window right', mode = { 'n', 'v', }, },
    ['<leader>wn'] = { '<c-w>w', 'go next window', mode = { 'n', 'v', }, },
    ['<leader>wg'] = { '<c-w>W', 'go prev window', mode = { 'n', 'v', }, },
    ['<leader>wz'] = { function() require 'config.my.window'.go_last_window() end, 'go last window', mode = { 'n', 'v', }, },
  }
  M.r {
    ['<leader>x'] = { name = 'window bdelete/bwipeout', },
    ['<leader>xh'] = { function() require 'config.my.window'.close_win_left() end, 'close window left', mode = { 'n', 'v', }, },
    ['<leader>xj'] = { function() require 'config.my.window'.close_win_down() end, 'close window down', mode = { 'n', 'v', }, },
    ['<leader>xk'] = { function() require 'config.my.window'.close_win_up() end, 'close window up', mode = { 'n', 'v', }, },
    ['<leader>xl'] = { function() require 'config.my.window'.close_win_right() end, 'close window right', mode = { 'n', 'v', }, },
    ['<leader>xt'] = { function() require 'config.my.window'.close_cur_tab() end, 'close window current', mode = { 'n', 'v', }, },
    ['<leader>xw'] = { function() require 'config.my.window'.Bwipeout_cur() end, 'Bwipeout current buffer', mode = { 'n', 'v', }, },
    ['<leader>x<c-w>'] = { function() require 'config.my.window'.bwipeout_cur() end, 'bwipeout current buffer', mode = { 'n', 'v', }, },
    ['<leader>xW'] = { function() require 'config.my.window'.bwipeout_cur() end, 'bwipeout current buffer', mode = { 'n', 'v', }, },
    ['<leader>xd'] = { function() require 'config.my.window'.Bdelete_cur() end, 'Bdelete current buffer', mode = { 'n', 'v', }, },
    ['<leader>x<c-d>'] = { function() require 'config.my.window'.bdelete_cur() end, 'bdelete current buffer', mode = { 'n', 'v', }, },
    ['<leader>xD'] = { function() require 'config.my.window'.bdelete_cur() end, 'bdelete current buffer', mode = { 'n', 'v', }, },
    ['<leader>xc'] = { function() require 'config.my.window'.close_cur() end, 'close current buffer', mode = { 'n', 'v', }, },
    ['<leader>xp'] = { function() require 'config.my.window'.bdelete_cur_proj() end, 'bdelete current proj files', mode = { 'n', 'v', }, },
    ['<leader>x<c-p>'] = { function() require 'config.my.window'.bwipeout_cur_proj() end, 'bwipeout current proj files', mode = { 'n', 'v', }, },
    ['<leader>xP'] = { function() require 'config.my.window'.bwipeout_cur_proj() end, 'bwipeout current proj files', mode = { 'n', 'v', }, },
    ['<leader>x<del>'] = { function() require 'config.my.window'.bwipeout_deleted() end, 'bwipeout buffers deleted', mode = { 'n', 'v', }, },
    ['<leader>x<cr>'] = { function() require 'config.my.window'.reopen_deleted() end, 'sel reopen buffers deleted', mode = { 'n', 'v', }, },
    ['<leader>xu'] = { function() require 'config.my.window'.bwipeout_unloaded() end, 'bdelete buffers unloaded', mode = { 'n', 'v', }, },
  }
  M.r {
    ['<leader>xo'] = { name = 'window other bdelete/bwipeout', },
    ['<leader>xow'] = { function() require 'config.my.window'.Bwipeout_other() end, 'Bwipeout other buffers', mode = { 'n', 'v', }, },
    ['<leader>xo<c-w>'] = { function() require 'config.my.window'.bwipeout_other() end, 'bwipeout other buffers', mode = { 'n', 'v', }, },
    ['<leader>xoW'] = { function() require 'config.my.window'.bwipeout_other() end, 'bwipeout other buffers', mode = { 'n', 'v', }, },
    ['<leader>xod'] = { function() require 'config.my.window'.Bdelete_other() end, 'Bdelete other buffers', mode = { 'n', 'v', }, },
    ['<leader>xo<c-d>'] = { function() require 'config.my.window'.bdelete_other() end, 'bdelete other buffers', mode = { 'n', 'v', }, },
    ['<leader>xoD'] = { function() require 'config.my.window'.bdelete_other() end, 'bdelete other buffers', mode = { 'n', 'v', }, },
    ['<leader>xop'] = { function() require 'config.my.window'.bdelete_other_proj() end, 'bdelete other proj buffers', mode = { 'n', 'v', }, },
    ['<leader>xo<c-p>'] = { function() require 'config.my.window'.bwipeout_other_proj() end, 'bwipeout other proj buffers', mode = { 'n', 'v', }, },
    ['<leader>xoP'] = { function() require 'config.my.window'.bwipeout_other_proj() end, 'bwipeout other proj buffers', mode = { 'n', 'v', }, },
    ['<leader>xoh'] = { function() require 'config.my.window'.bdelete_proj 'h' end, 'bdelete proj up', mode = { 'n', 'v', }, },
    ['<leader>xoj'] = { function() require 'config.my.window'.bdelete_proj 'j' end, 'bdelete proj down', mode = { 'n', 'v', }, },
    ['<leader>xok'] = { function() require 'config.my.window'.bdelete_proj 'k' end, 'bdelete proj left', mode = { 'n', 'v', }, },
    ['<leader>xol'] = { function() require 'config.my.window'.bdelete_proj 'l' end, 'bdelete proj right', mode = { 'n', 'v', }, },
    ['<leader>xo<c-h>'] = { function() require 'config.my.window'.bwipeout_proj 'h' end, 'bwipeout proj up', mode = { 'n', 'v', }, },
    ['<leader>xo<c-j>'] = { function() require 'config.my.window'.bwipeout_proj 'j' end, 'bwipeout proj down', mode = { 'n', 'v', }, },
    ['<leader>xo<c-k>'] = { function() require 'config.my.window'.bwipeout_proj 'k' end, 'bwipeout proj left', mode = { 'n', 'v', }, },
    ['<leader>xo<c-l>'] = { function() require 'config.my.window'.bwipeout_proj 'l' end, 'bwipeout proj right', mode = { 'n', 'v', }, },
    ['<leader>xoH'] = { function() require 'config.my.window'.bwipeout_proj 'h' end, 'bwipeout proj up', mode = { 'n', 'v', }, },
    ['<leader>xoJ'] = { function() require 'config.my.window'.bwipeout_proj 'j' end, 'bwipeout proj down', mode = { 'n', 'v', }, },
    ['<leader>xoK'] = { function() require 'config.my.window'.bwipeout_proj 'k' end, 'bwipeout proj left', mode = { 'n', 'v', }, },
    ['<leader>xoL'] = { function() require 'config.my.window'.bwipeout_proj 'l' end, 'bwipeout proj right', mode = { 'n', 'v', }, },
    ['<leader>xor'] = { function() require 'config.my.window'.bdelete_ex_cur_root() end, 'bdelete buffers exclude cur_root', mode = { 'n', 'v', }, },
    ['<leader>xr'] = { function() require 'config.my.window'.listed_cur_root_files() end, 'listed cur root buffers', mode = { 'n', 'v', }, },
    ['<leader>x<c-r>'] = { function() require 'config.my.window'.listed_cur_root_files 'all' end, 'listed cur root buffers all', mode = { 'n', 'v', }, },
  }
  M.r {
    ['<a-h>'] = { function() vim.cmd 'wincmd <' end, 'my.window: width_less_1', mode = { 'n', 'v', }, silent = true, },
    ['<a-l>'] = { function() vim.cmd 'wincmd >' end, 'my.window: width_more_1', mode = { 'n', 'v', }, silent = true, },
    ['<a-j>'] = { function() vim.cmd 'wincmd -' end, 'my.window: height_less_1', mode = { 'n', 'v', }, silent = true, },
    ['<a-k>'] = { function() vim.cmd 'wincmd +' end, 'my.window: height_more_1', mode = { 'n', 'v', }, silent = true, },

    ['<a-s-h>'] = { function() vim.cmd '10wincmd <' end, 'my.window: width_less_10', mode = { 'n', 'v', }, silent = true, },
    ['<a-s-l>'] = { function() vim.cmd '10wincmd >' end, 'my.window: width_more_10', mode = { 'n', 'v', }, silent = true, },
    ['<a-s-j>'] = { function() vim.cmd '10wincmd -' end, 'my.window: height_less_10', mode = { 'n', 'v', }, silent = true, },
    ['<a-s-k>'] = { function() vim.cmd '10wincmd +' end, 'my.window: height_more_10', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.toggle()
  TimingBegin()
  M.r {
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

function M.hili()
  TimingBegin()
  M.r {
    ['*'] = { function() require 'config.my.hili'.search() end, 'hili: multiline search', mode = { 'v', }, silent = true, },
    -- windo cursorword
    ['<a-7>'] = { function() require 'config.my.hili'.cursorword() end, 'hili: cursor word', mode = { 'n', }, silent = true, },
    ['<a-8>'] = { function() require 'config.my.hili'.windocursorword() end, 'hili: windo cursor word', mode = { 'n', }, silent = true, },
    -- cword hili
    ['<c-8>'] = { function() require 'config.my.hili'.hili_v() end, 'hili: cword', mode = { 'v', }, silent = true, },
    -- cword hili rm
    ['<c-s-8>'] = { function() require 'config.my.hili'.rmhili_v() end, 'hili: rm v', mode = { 'v', }, silent = true, },
    -- select hili
    ['<c-7>'] = { function() require 'config.my.hili'.selnexthili() end, 'hili: sel next', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-7>'] = { function() require 'config.my.hili'.selprevhili() end, 'hili: sel prev', mode = { 'n', 'v', }, silent = true, },
    -- go hili
    ['<c-n>'] = { function() require 'config.my.hili'.prevhili() end, 'hili: go prev', mode = { 'n', 'v', }, silent = true, },
    ['<c-m>'] = { function() require 'config.my.hili'.nexthili() end, 'hili: go next', mode = { 'n', 'v', }, silent = true, },
    -- go cur hili
    ['<c-s-n>'] = { function() require 'config.my.hili'.prevcurhili() end, 'hili: go cur prev', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-m>'] = { function() require 'config.my.hili'.nextcurhili() end, 'hili: go cur next', mode = { 'n', 'v', }, silent = true, },
    -- rehili
    ['<c-s-9>'] = { function() require 'config.my.hili'.rehili() end, 'hili: rehili', mode = { 'n', 'v', }, silent = true, },
    -- search cword
    ["<c-s-'>"] = { function() require 'config.my.hili'.prevlastcword() end, 'hili: prevlastcword', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-/>'] = { function() require 'config.my.hili'.nextlastcword() end, 'hili: nextlastcword', mode = { 'n', 'v', }, silent = true, },
    ['<c-,>'] = { function() require 'config.my.hili'.prevcword() end, 'hili: prevcword', mode = { 'n', 'v', }, silent = true, },
    ['<c-.>'] = { function() require 'config.my.hili'.nextcword() end, 'hili: nextcword', mode = { 'n', 'v', }, silent = true, },
    ["<c-'>"] = { function() require 'config.my.hili'.prevcWORD() end, 'hili: prevcWORD', mode = { 'n', 'v', }, silent = true, },
    ['<c-/>'] = { function() require 'config.my.hili'.nextcWORD() end, 'hili: nextcWORD', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<c-8>'] = { function() require 'config.my.hili'.hili_n() end, 'hili: cword', mode = { 'n', }, silent = true, },
    ['<c-s-8>'] = { function() require 'config.my.hili'.rmhili_n() end, 'hili: rm n', mode = { 'n', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.svn()
  TimingBegin()
  vim.api.nvim_create_user_command('TortoiseSVN', function(params)
    require 'config.my.svn'.tortoisesvn(params['fargs'])
  end, { nargs = '*', })
  M.r {
    ['<leader>v'] = { name = 'my.svn', },
    ['<leader>vo'] = { '<cmd>TortoiseSVN settings cur yes<cr>', 'TortoiseSVN settings cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vd'] = { '<cmd>TortoiseSVN diff cur yes<cr>', 'TortoiseSVN diff cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vf'] = { '<cmd>TortoiseSVN diff root yes<cr>', 'TortoiseSVN diff root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vb'] = { '<cmd>TortoiseSVN blame cur yes<cr>', 'TortoiseSVN blame cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vw'] = { '<cmd>TortoiseSVN repobrowser cur yes<cr>', 'TortoiseSVN repobrowser cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ve'] = { '<cmd>TortoiseSVN repobrowser root yes<cr>', 'TortoiseSVN repobrowser root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vv'] = { '<cmd>TortoiseSVN revert root yes<cr>', 'TortoiseSVN revert root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>va'] = { '<cmd>TortoiseSVN add root yes<cr>', 'TortoiseSVN add root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vc'] = { '<cmd>TortoiseSVN commit root yes<cr>', 'TortoiseSVN commit root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vu'] = { '<cmd>TortoiseSVN update /rev root yes<cr>', 'TortoiseSVN update /rev root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vl'] = { '<cmd>TortoiseSVN log cur yes<cr>', 'TortoiseSVN log cur yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>v;'] = { '<cmd>TortoiseSVN log root yes<cr>', 'TortoiseSVN log root yes<cr>', mode = { 'n', 'v', }, silent = true, },
    ['<leader>vk'] = { '<cmd>TortoiseSVN checkout root yes<cr>', 'TortoiseSVN checkout root yes<cr>', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.lsp()
  TimingBegin()
  M.r {
    ['<leader>f'] = { name = 'lsp', },
    ['<leader>fv'] = { name = 'lsp.move', },
    ['<leader>fn'] = { function() require 'config.nvim.lsp'.rename() end, 'lsp: rename', mode = { 'n', 'v', }, silent = true, },
    ['<leader>fl'] = { function() require 'config.nvim.telescope'.lsp_document_symbols() end, 'telescope.lsp: document_symbols', mode = { 'n', 'v', }, silent = true, },
    ['<leader>fr'] = { function() require 'config.nvim.telescope'.lsp_references() end, 'telescope.lsp: references', mode = { 'n', 'v', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.git()
  TimingBegin()
  M.r {
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
    ['<leader>ggp'] = { function() require 'config.my.git'.pull_all() end, 'git.push: pull_all', mode = { 'n', 'v', }, silent = true, },
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
  }
  TimingEnd(debug.getinfo(1)['name'])
end

function M.telescope()
  TimingBegin()
  M.r {
    ['<leader>s'] = { name = 'telescope', },
    -- builtins
    ['<leader>s<leader>'] = { function() require 'config.nvim.telescope'.find_files_all() end, 'telescope: find_files_all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sd'] = { function() require 'config.nvim.telescope'.diagnostics() end, 'telescope: diagnostics', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-f>'] = { function() require 'config.nvim.telescope'.filetypes() end, 'telescope: filetypes', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sh'] = { function() require 'config.nvim.telescope'.search_history() end, 'telescope: search_history', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sj'] = { function() require 'config.nvim.telescope'.jumplist() end, 'telescope: jumplist', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sm'] = { function() require 'config.nvim.telescope'.keymaps() end, 'telescope: keymaps', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sr'] = { function() require 'config.nvim.telescope'.root_sel_till_git() end, 'telescope: root_sel_till_git', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sR'] = { function() require 'config.nvim.telescope'.root_sel_scan_dirs() end, 'telescope: root_sel_scan_dirs', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<a-r>'] = { function() require 'config.nvim.telescope'.root_sel_parennt_dirs() end, 'telescope: root_sel_parennt_dirs', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-r>'] = { function() require 'config.nvim.telescope'.root_sel_switch() end, 'telescope: root_sel_switch', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sq'] = { function() require 'config.nvim.telescope'.quickfix() end, 'telescope: quickfix', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sv'] = { name = 'telescope.more', },
    ['<leader>svv'] = { name = 'telescope.more', },
    ['<leader>svq'] = { function() require 'config.nvim.telescope'.quickfixhistory() end, 'telescope: quickfixhistory', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svvc'] = { function() require 'config.nvim.telescope'.colorscheme() end, 'telescope: colorscheme', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svh'] = { function() require 'config.nvim.telescope'.help_tags() end, 'telescope: help_tags', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sva'] = { function() require 'config.nvim.telescope'.autocommands() end, 'telescope: autocommands', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svva'] = { function() require 'config.nvim.telescope'.builtin() end, 'telescope: builtin', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svo'] = { function() require 'config.nvim.telescope'.vim_options() end, 'telescope: vim_options', mode = { 'n', 'v', }, silent = true, },
    -- terminal
    ['<leader>st'] = { name = 'telescope.terminal', },
    ['<leader>stc'] = { function() require 'config.nvim.telescope'.terminal_cmd() end, 'telescope.terminal: cmd', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sti'] = { function() require 'config.nvim.telescope'.terminal_ipython() end, 'telescope.terminal: ipython', mode = { 'n', 'v', }, silent = true, },
    ['<leader>stb'] = { function() require 'config.nvim.telescope'.terminal_bash() end, 'telescope.terminal: bash', mode = { 'n', 'v', }, silent = true, },
    ['<leader>stp'] = { function() require 'config.nvim.telescope'.terminal_powershell() end, 'telescope.terminal: powershell', mode = { 'n', 'v', }, silent = true, },
    -- open telescope.lua
    ['<leader>sO'] = { function() require 'config.nvim.telescope'.open_telescope_lua() end, 'telescope: open telescope.lua', mode = { 'n', 'v', }, silent = true, },
    ['<leader>m'] = { function() require 'config.nvim.telescope'.find_files_curdir() end, 'telescope: find_files_curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir() end, 'telescope: find_files_pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>M'] = { function() require 'config.nvim.telescope'.find_files_pardir_2() end, 'telescope: find_files_pardir_2', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir_3() end, 'telescope: find_files_pardir_3', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir_4() end, 'telescope: find_files_pardir_4', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-s-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir_5() end, 'telescope: find_files_pardir_5', mode = { 'n', 'v', }, silent = true, },
    ['<leader>e'] = { function() require 'config.nvim.telescope'.everything() end, 'telescope: everything', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-e>'] = { function() require 'config.nvim.telescope'.everything_regex() end, 'telescope: everything', mode = { 'n', 'v', }, silent = true, },
    ['<leader>p'] = { function() require 'config.nvim.telescope'.pure_curdir() end, 'telescope: pure_curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-p>'] = { function() require 'config.nvim.telescope'.pure_pardir() end, 'telescope: pure_pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>P'] = { function() require 'config.nvim.telescope'.pure_pardir_2() end, 'telescope: pure_pardir_2', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-p>'] = { function() require 'config.nvim.telescope'.pure_pardir_3() end, 'telescope: pure_pardir_3', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-p>'] = { function() require 'config.nvim.telescope'.pure_pardir_4() end, 'telescope: pure_pardir_4', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-s-p>'] = { function() require 'config.nvim.telescope'.pure_pardir_5() end, 'telescope: pure_pardir_5', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-l>'] = { function() require 'config.nvim.telescope'.live_grep_curdir() end, 'telescope: live_grep_curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>L'] = { function() require 'config.nvim.telescope'.live_grep_pardir() end, 'telescope: live_grep_pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-l>'] = { function() require 'config.nvim.telescope'.live_grep_pardir_2() end, 'telescope: live_grep_pardir2', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-l>'] = { function() require 'config.nvim.telescope'.live_grep_pardir_3() end, 'telescope: live_grep_pardir3', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-s-l>'] = { function() require 'config.nvim.telescope'.live_grep_pardir_4() end, 'telescope: live_grep_pardir4', mode = { 'n', 'v', }, silent = true, },
    ['<leader>ss'] = { function() require 'config.nvim.telescope'.grep_string() end, 'telescope: grep_string', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-s>'] = { function() require 'config.nvim.telescope'.grep_string_curdir() end, 'telescope: grep_string_curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sS'] = { function() require 'config.nvim.telescope'.grep_string_pardir() end, 'telescope: grep_string_pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-s-s>'] = { function() require 'config.nvim.telescope'.grep_string_pardir_2() end, 'telescope: grep_string_pardir_2', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<a-s>'] = { function() require 'config.nvim.telescope'.grep_string_pardir_3() end, 'telescope: grep_string_pardir_3', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<a-s-s>'] = { function() require 'config.nvim.telescope'.grep_string_pardir_4() end, 'telescope: grep_string_pardir_4', mode = { 'n', 'v', }, silent = true, },
    ['<leader>n'] = { function() require 'config.nvim.telescope'.commands() end, 'telescope: commands', mode = { 'n', 'v', }, silent = true, },
    ['<leader>b'] = { function() require 'config.nvim.telescope'.buffers_cur() end, 'telescope: buffers cur', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-b>'] = { function() require 'config.nvim.telescope'.buffers_all() end, 'telescope: buffers all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>so'] = { function() require 'config.nvim.telescope'.oldfiles() end, 'telescope: oldfiles', mode = { 'n', 'v', }, silent = true, },
    -- mouse
    ['<c-s-f12>'] = { name = 'telescope', },
    ['<c-s-f12><f1>'] = { function() require 'config.nvim.telescope'.git_status() end, 'telescope: git_status', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f2>'] = { function() require 'config.nvim.telescope'.buffers_cur() end, 'telescope: buffers_cur', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f3>'] = { function() require 'config.nvim.telescope'.find_files() end, 'telescope: find_files', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f4>'] = { function() require 'config.nvim.telescope'.jumplist() end, 'telescope: jumplist', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f6>'] = { function() require 'config.nvim.telescope'.command_history() end, 'telescope: command_history', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f7>'] = { function() require 'config.nvim.telescope'.lsp_document_symbols() end, 'telescope.lsp: document_symbols', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f8>'] = { function() require 'config.nvim.telescope'.buffers() end, 'telescope: buffers', mode = { 'n', 'v', }, silent = true, },
  }
  M.r {
    ['<c-s-f12><f1>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f2>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f3>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f4>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f6>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f7>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f8>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
  }
  TimingEnd(debug.getinfo(1)['name'])
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
  require 'base'.del_map({ 'n', 'v', }, '<s-esc>')
end

vim.api.nvim_create_user_command('MapFromLazyToWhichkey', function(params)
  M.map_from_lazy_to_whichkey(unpack(params['fargs']))
end, { nargs = 0, })

function M.map_from_lazy_to_whichkey(fname)
  if not fname then
    fname = string.gsub(vim.api.nvim_buf_get_name(0), '/', '\\')
  end
  if #fname == 0 then
    return
  end
  local new_lines = {}
  for _, line in ipairs(vim.fn.readfile(fname)) do
    local res = string.match(line, '^ +({.*mode *= *.*}) *,')
    if not res then
      res = string.match(line, '^ +({.*name *= *.*}) *,')
    end
    if res then
      local item = loadstring('return ' .. res)
      if item then
        local val = item()
        if type(val[2]) == 'function' then
          val[2] = string.match(res, '(function().+end),')
        end
        local lhs = table.remove(val, 1)
        if not val['name'] then
          val[#val + 1] = val['desc']
          val['desc'] = nil
        end
        local temp = string.gsub(vim.inspect { [lhs] = val, }, '%s+', ' ')
        temp = string.gsub(temp, '"(function().+end)",', '%1,')
        temp = string.gsub(temp, '\\"', '"')
        temp = string.gsub(temp, '{(.+)}', '%1')
        temp = vim.fn.trim(temp) .. ','
        new_lines[#new_lines + 1] = '  ' .. temp
      else
        new_lines[#new_lines + 1] = line
      end
    else
      new_lines[#new_lines + 1] = line
    end
  end
  require 'plenary.path':new(fname):write(vim.fn.join(new_lines, '\r\n'), 'w')
end

vim.api.nvim_create_user_command('MapFromWhichkeyToLazy', function(params)
  M.map_from_whichkey_to_lazy(unpack(params['fargs']))
end, { nargs = 0, })

function M.map_from_whichkey_to_lazy(fname)
  if not fname then
    fname = string.gsub(vim.api.nvim_buf_get_name(0), '/', '\\')
  end
  if #fname == 0 then
    return
  end
  local new_lines = {}
  for _, line in ipairs(vim.fn.readfile(fname)) do
    local res = string.match(line, '^.+ *=.*{.*mode *=.+} *,')
    if res then
      local item = loadstring('return {' .. res .. '}')
      if item then
        local val = item()
        for lhs, d in pairs(val) do
          if type(d[1]) == 'function' then
            d[1] = string.match(res, '(function().+end),')
          end
          table.insert(d, 1, lhs)
          d['desc'] = table.remove(d, 3)
          local temp = string.gsub(vim.inspect(d), '%s+', ' ')
          temp = string.gsub(temp, '"(function().+end)",', '%1,')
          temp = string.gsub(temp, '\\"', '"')
          temp = vim.fn.trim(temp) .. ','
          new_lines[#new_lines + 1] = '  ' .. temp
        end
      else
        new_lines[#new_lines + 1] = line
      end
    else
      new_lines[#new_lines + 1] = line
    end
  end
  require 'plenary.path':new(fname):write(vim.fn.join(new_lines, '\r\n'), 'w')
end

vim.opt.updatetime = 500

return M

