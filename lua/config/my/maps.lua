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
  Notify(string.format('%s: %.3f ms', name, end_time * 1000))
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
    { '<F2>', function() require 'config.my.box'.replace_two_words 'n' end,   mode = { 'n', },      silent = true, desc = 'switch two words prepare', },
    { '<F2>', function() require 'config.my.box'.replace_two_words 'v' end,   mode = { 'v', },      silent = true, desc = 'switch two words prepare', },
    { '<F3>', function() require 'config.my.box'.replace_two_words_2 'n' end, mode = { 'n', },      silent = true, desc = 'switch two words do', },
    { '<F3>', function() require 'config.my.box'.replace_two_words_2 'v' end, mode = { 'v', },      silent = true, desc = 'switch two words do', },
  }
  M._m {
    { '<leader>as',         name = 'nvim-qt/programs', },
    { '<leader>as;',        function() require 'config.my.box'.start_new_nvim_qt_cfile() end,      mode = { 'n', 'v', }, silent = true, desc = 'start new nvim-qt and open <cfile>', },
    { '<leader>as<c-p>',    function() require 'config.my.box'.sel_open_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel open programs file force', },
    { '<leader>as<c-k>',    function() require 'config.my.box'.sel_kill_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel kill programs file force', },
    { '<leader>ass',        function() require 'config.my.box'.sel_open_startup_file() end,        mode = { 'n', 'v', }, silent = true, desc = 'sel open startup file', },
    { '<leader>aa',         function() require 'config.my.box'.source() end,                       mode = { 'n', 'v', }, silent = true, desc = 'source', },
    { '<leader>ax',         function() require 'config.my.box'.type_execute_output() end,          mode = { 'n', 'v', }, silent = true, desc = 'execute output to and open file', },
    { '<leader>ac',         function() require 'config.my.box'.mes_clear() end,                    mode = { 'n', 'v', }, silent = true, desc = 'mes clear', },
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
    { '<leader>we',       '<c-w>=',                                                      mode = { 'n', 'v', }, desc = 'my.window: go window equal', },
    { '<leader>w;',       function() require 'config.my.window'.toggle_max_height() end, mode = { 'n', 'v', }, desc = 'toggle max height', },
    { '<leader>wm',       function() require 'base'.win_max_height() end,                mode = { 'n', 'v', }, desc = 'window highest', },
    { '<leader>wh',       function() require 'config.my.window'.go_window 'h' end,       mode = { 'n', 'v', }, desc = 'go window up', },
    { '<leader>wj',       function() require 'config.my.window'.go_window 'j' end,       mode = { 'n', 'v', }, desc = 'go window down', },
    { '<leader>wk',       function() require 'config.my.window'.go_window 'k' end,       mode = { 'n', 'v', }, desc = 'go window left', },
    { '<leader>wl',       function() require 'config.my.window'.go_window 'l' end,       mode = { 'n', 'v', }, desc = 'go window right', },
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
    { '<leader>f',  name = 'nvim.lsp', },
    { '<leader>fv', name = 'nvim.lsp.move', },
    { '<leader>ff', function() require 'config.nvim.lsp'.format() end,                     mode = { 'n', 'v', }, silent = true, desc = 'nvim.lsp: format', },
    { '<leader>fn', function() require 'config.nvim.lsp'.rename() end,                     mode = { 'n', 'v', }, silent = true, desc = 'nvim.lsp: rename', },
    { '<leader>fl', function() require 'config.nvim.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: document_symbols', },
    { '<leader>fr', function() require 'config.nvim.telescope'.lsp_references() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: references', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

M.base()
M.box()
M.copy()
M.window()
M.toggle()
M.hili()
M.svn()
M.lsp()

return M
