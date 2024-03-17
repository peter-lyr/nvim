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
      if #B.commands == 0 then
        B.create_user_command_with_M {
          ['Drag'] = require 'config.my.drag',
          ['Args'] = require 'config.my.args',
          ['Py'] = require 'config.my.py',
          ['C'] = require 'config.my.c',
          ['Gui'] = require 'config.my.gui',
        }
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
  local A = require 'config.my.box'
  M._m {
    { '<leader>a', name = 'my.box', },
  }
  M._m {
    { '<F1>', function() A.show_info() end,             mode = { 'n', 'v', }, silent = true, desc = 'show info', },
    { '<F2>', function() A.replace_two_words 'n' end,   mode = { 'n', },      silent = true, desc = 'switch two words prepare', },
    { '<F2>', function() A.replace_two_words 'v' end,   mode = { 'v', },      silent = true, desc = 'switch two words prepare', },
    { '<F3>', function() A.replace_two_words_2 'n' end, mode = { 'n', },      silent = true, desc = 'switch two words do', },
    { '<F3>', function() A.replace_two_words_2 'v' end, mode = { 'v', },      silent = true, desc = 'switch two words do', },
  }
  M._m {
    { '<leader>as',         name = 'nvim-qt/programs', },
    { '<leader>asr',        function() A.restart_nvim_qt() end,              mode = { 'n', 'v', }, silent = true, desc = 'restart nvim-qt', },
    { '<leader>as<leader>', function() A.start_new_nvim_qt() end,            mode = { 'n', 'v', }, silent = true, desc = 'start new nvim-qt', },
    { '<leader>as;',        function() A.start_new_nvim_qt_cfile() end,      mode = { 'n', 'v', }, silent = true, desc = 'start new nvim-qt and open <cfile>', },
    { '<leader>asq',        function() A.quit_nvim_qt() end,                 mode = { 'n', 'v', }, silent = true, desc = 'quit nvim-qt', },
    { '<leader>asp',        function() A.sel_open_programs_file() end,       mode = { 'n', 'v', }, silent = true, desc = 'sel open programs file', },
    { '<leader>as<c-p>',    function() A.sel_open_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel open programs file force', },
    { '<leader>ask',        function() A.sel_kill_programs_file() end,       mode = { 'n', 'v', }, silent = true, desc = 'sel kill programs file', },
    { '<leader>as<c-k>',    function() A.sel_kill_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel kill programs file force', },
    { '<leader>ass',        function() A.sel_open_startup_file() end,        mode = { 'n', 'v', }, silent = true, desc = 'sel open startup file', },
    { '<leader>aa',         function() A.source() end,                       mode = { 'n', 'v', }, silent = true, desc = 'source', },
    { '<leader>ax',         function() A.type_execute_output() end,          mode = { 'n', 'v', }, silent = true, desc = 'execute output to and open file', },
    { '<leader>ae',         function() A.sel_open_temp() end,                mode = { 'n', 'v', }, silent = true, desc = 'sel open temp file', },
    { '<leader>aw',         function() A.sel_write_to_temp() end,            mode = { 'n', 'v', }, silent = true, desc = 'sel write to temp file', },
    { '<leader>ac',         function() A.mes_clear() end,                    mode = { 'n', 'v', }, silent = true, desc = 'mes clear', },
  }
  M._m {
    { '<leader>ao',  name = 'open', },
    { '<leader>aop', function() A.open_path() end,  mode = { 'n', 'v', }, silent = true, desc = 'open path', },
    { '<leader>aos', function() A.open_sound() end, mode = { 'n', 'v', }, silent = true, desc = 'open sound', },
    { '<leader>aof', function() A.open_file() end,  mode = { 'n', 'v', }, silent = true, desc = 'open file in clipboard', },
  }
  M._m {
    { '<leader>am',  name = 'monitor', },
    { '<leader>am1', function() A.monitor_1min() end,   mode = { 'n', 'v', }, silent = true, desc = 'monitor 1 min', },
    { '<leader>am3', function() A.monitor_30min() end,  mode = { 'n', 'v', }, silent = true, desc = 'monitor 30 min', },
    { '<leader>am5', function() A.monitor_5hours() end, mode = { 'n', 'v', }, silent = true, desc = 'monitor 5 hours', },
  }
  M._m {
    { '<leader>ap',  name = 'prx', },
    { '<leader>apo', function() A.proxy_on() end,  mode = { 'n', 'v', }, silent = true, desc = 'prx on', },
    { '<leader>apf', function() A.proxy_off() end, mode = { 'n', 'v', }, silent = true, desc = 'prx off', },
  }
  M._m {
    { '<leader>ag',  name = 'git', },
    { '<leader>agm', function() A.git_init_and_cmake() end, mode = { 'n', 'v', }, silent = true, desc = 'git init and cmake', },
  }
  M._m {
    { '<leader>aq',  name = 'qf make conv', },
    { '<leader>aq8', function() A.qfmakeconv2utf8() end,  mode = { 'n', 'v', }, silent = true, desc = 'qf makeconv 2 utf8', },
    { '<leader>aq9', function() A.qfmakeconv2cp936() end, mode = { 'n', 'v', }, silent = true, desc = 'qf makeconv 2 cp936', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.copy()
  local start_time = M._s()
  local A = require 'config.my.copy'
  M._m {
    { '<leader>y', name = 'copy to clipboard', },
  }
  M._m {
    { '<leader>yf',  name = 'absolute path', },
    { '<leader>yff', function() A.full_name() end, mode = { 'n', 'v', }, silent = true, desc = 'full name', },
    { '<leader>yft', function() A.full_tail() end, mode = { 'n', 'v', }, silent = true, desc = 'full tail', },
    { '<leader>yfh', function() A.full_head() end, mode = { 'n', 'v', }, silent = true, desc = 'full head', },
  }
  M._m {
    { '<leader>yr',  name = 'relative path', },
    { '<leader>yrr', function() A.rela_name() end, mode = { 'n', 'v', }, silent = true, desc = 'rela name', },
    { '<leader>yrh', function() A.rela_head() end, mode = { 'n', 'v', }, silent = true, desc = 'rela head', },
    { '<leader>yrc', function() A.cur_root() end,  mode = { 'n', 'v', }, silent = true, desc = 'telescope cur root', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.window()
  local start_time = M._s()
  local A = require 'config.my.window'
  local B = require 'base'
  M._m {
    { '<leader>w',        name = 'window jump/split/new', },
    { '<leader>wa',       function() A.change_around 'h' end,   mode = { 'n', 'v', }, desc = 'change with window left', },
    { '<leader>ws',       function() A.change_around 'j' end,   mode = { 'n', 'v', }, desc = 'change with window down', },
    { '<leader>ww',       function() A.change_around 'k' end,   mode = { 'n', 'v', }, desc = 'change with window up', },
    { '<leader>wd',       function() A.change_around 'l' end,   mode = { 'n', 'v', }, desc = 'change with window right', },
    { '<leader>wt',       '<c-w>t',                             mode = { 'n', 'v', }, desc = 'go topleft window', },
    { '<leader>wq',       '<c-w>p',                             mode = { 'n', 'v', }, desc = 'go toggle last window', },
    { '<leader>w;',       function() A.toggle_max_height() end, mode = { 'n', 'v', }, desc = 'toggle max height', },
    { '<leader>wm',       function() B.win_max_height() end,    mode = { 'n', 'v', }, desc = 'window highest', },
    { '<leader>wh',       function() A.go_window 'h' end,       mode = { 'n', 'v', }, desc = 'go window up', },
    { '<leader>wj',       function() A.go_window 'j' end,       mode = { 'n', 'v', }, desc = 'go window down', },
    { '<leader>wk',       function() A.go_window 'k' end,       mode = { 'n', 'v', }, desc = 'go window left', },
    { '<leader>wl',       function() A.go_window 'l' end,       mode = { 'n', 'v', }, desc = 'go window right', },
    { '<leader>wu',       ':<c-u>leftabove new<cr>',            mode = { 'n', 'v', }, desc = 'create new window up', },
    { '<leader>wi',       ':<c-u>new<cr>',                      mode = { 'n', 'v', }, desc = 'create new window down', },
    { '<leader>wo',       ':<c-u>leftabove vnew<cr>',           mode = { 'n', 'v', }, desc = 'create new window left', },
    { '<leader>wp',       ':<c-u>vnew<cr>',                     mode = { 'n', 'v', }, desc = 'create new window right', },
    { '<leader>w<left>',  '<c-w>v<c-w>h',                       mode = { 'n', 'v', }, desc = 'split to window up', },
    { '<leader>w<down>',  '<c-w>s',                             mode = { 'n', 'v', }, desc = 'split to window down', },
    { '<leader>w<up>',    '<c-w>s<c-w>k',                       mode = { 'n', 'v', }, desc = 'split to window left', },
    { '<leader>w<right>', '<c-w>v',                             mode = { 'n', 'v', }, desc = 'split to window right', },
    { '<leader>wc',       '<c-w>H',                             mode = { 'n', 'v', }, desc = 'be most window up', },
    { '<leader>wv',       '<c-w>J',                             mode = { 'n', 'v', }, desc = 'be most window down', },
    { '<leader>wf',       '<c-w>K',                             mode = { 'n', 'v', }, desc = 'be most window left', },
    { '<leader>wb',       '<c-w>L',                             mode = { 'n', 'v', }, desc = 'be most window right', },
    { '<leader>wn',       '<c-w>w',                             mode = { 'n', 'v', }, desc = 'go next window', },
    { '<leader>wg',       '<c-w>W',                             mode = { 'n', 'v', }, desc = 'go prev window', },
    { '<leader>wz',       function() A.go_last_window() end,    mode = { 'n', 'v', }, desc = 'go last window', },
  }
  M._m {
    { '<leader>x',      name = 'window bdelete/bwipeout', },
    { '<leader>xh',     function() A.close_win_left() end,    mode = { 'n', 'v', }, desc = 'close window left', },
    { '<leader>xj',     function() A.close_win_down() end,    mode = { 'n', 'v', }, desc = 'close window down', },
    { '<leader>xk',     function() A.close_win_up() end,      mode = { 'n', 'v', }, desc = 'close window up', },
    { '<leader>xl',     function() A.close_win_right() end,   mode = { 'n', 'v', }, desc = 'close window right', },
    { '<leader>xt',     function() A.close_cur_tab() end,     mode = { 'n', 'v', }, desc = 'close window current', },
    { '<leader>xw',     function() A.Bwipeout_cur() end,      mode = { 'n', 'v', }, desc = 'Bwipeout current buffer', },
    { '<leader>x<c-w>', function() A.bwipeout_cur() end,      mode = { 'n', 'v', }, desc = 'bwipeout current buffer', },
    { '<leader>xW',     function() A.bwipeout_cur() end,      mode = { 'n', 'v', }, desc = 'bwipeout current buffer', },
    { '<leader>xd',     function() A.Bdelete_cur() end,       mode = { 'n', 'v', }, desc = 'Bdelete current buffer', },
    { '<leader>x<c-d>', function() A.bdelete_cur() end,       mode = { 'n', 'v', }, desc = 'bdelete current buffer', },
    { '<leader>xD',     function() A.bdelete_cur() end,       mode = { 'n', 'v', }, desc = 'bdelete current buffer', },
    { '<leader>xc',     function() A.close_cur() end,         mode = { 'n', 'v', }, desc = 'close current buffer', },
    { '<leader>xp',     function() A.bdelete_cur_proj() end,  mode = { 'n', 'v', }, desc = 'bdelete current proj files', },
    { '<leader>x<c-p>', function() A.bwipeout_cur_proj() end, mode = { 'n', 'v', }, desc = 'bwipeout current proj files', },
    { '<leader>xP',     function() A.bwipeout_cur_proj() end, mode = { 'n', 'v', }, desc = 'bwipeout current proj files', },
    { '<leader>x<del>', function() A.bwipeout_deleted() end,  mode = { 'n', 'v', }, desc = 'bwipeout buffers deleted', },
    { '<leader>x<cr>',  function() A.reopen_deleted() end,    mode = { 'n', 'v', }, desc = 'sel reopen buffers deleted', },
    { '<leader>xu',     function() A.bwipeout_unloaded() end, mode = { 'n', 'v', }, desc = 'bdelete buffers unloaded', },
  }
  M._m {
    { '<leader>xo',      name = 'window other bdelete/bwipeout', },
    { '<leader>xow',     function() A.Bwipeout_other() end,            mode = { 'n', 'v', }, desc = 'Bwipeout other buffers', },
    { '<leader>xo<c-w>', function() A.bwipeout_other() end,            mode = { 'n', 'v', }, desc = 'bwipeout other buffers', },
    { '<leader>xoW',     function() A.bwipeout_other() end,            mode = { 'n', 'v', }, desc = 'bwipeout other buffers', },
    { '<leader>xod',     function() A.Bdelete_other() end,             mode = { 'n', 'v', }, desc = 'Bdelete other buffers', },
    { '<leader>xo<c-d>', function() A.bdelete_other() end,             mode = { 'n', 'v', }, desc = 'bdelete other buffers', },
    { '<leader>xoD',     function() A.bdelete_other() end,             mode = { 'n', 'v', }, desc = 'bdelete other buffers', },
    { '<leader>xop',     function() A.bdelete_other_proj() end,        mode = { 'n', 'v', }, desc = 'bdelete other proj buffers', },
    { '<leader>xo<c-p>', function() A.bwipeout_other_proj() end,       mode = { 'n', 'v', }, desc = 'bwipeout other proj buffers', },
    { '<leader>xoP',     function() A.bwipeout_other_proj() end,       mode = { 'n', 'v', }, desc = 'bwipeout other proj buffers', },
    { '<leader>xoh',     function() A.bdelete_proj 'h' end,            mode = { 'n', 'v', }, desc = 'bdelete proj up', },
    { '<leader>xoj',     function() A.bdelete_proj 'j' end,            mode = { 'n', 'v', }, desc = 'bdelete proj down', },
    { '<leader>xok',     function() A.bdelete_proj 'k' end,            mode = { 'n', 'v', }, desc = 'bdelete proj left', },
    { '<leader>xol',     function() A.bdelete_proj 'l' end,            mode = { 'n', 'v', }, desc = 'bdelete proj right', },
    { '<leader>xo<c-h>', function() A.bwipeout_proj 'h' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj up', },
    { '<leader>xo<c-j>', function() A.bwipeout_proj 'j' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj down', },
    { '<leader>xo<c-k>', function() A.bwipeout_proj 'k' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj left', },
    { '<leader>xo<c-l>', function() A.bwipeout_proj 'l' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj right', },
    { '<leader>xoH',     function() A.bwipeout_proj 'h' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj up', },
    { '<leader>xoJ',     function() A.bwipeout_proj 'j' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj down', },
    { '<leader>xoK',     function() A.bwipeout_proj 'k' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj left', },
    { '<leader>xoL',     function() A.bwipeout_proj 'l' end,           mode = { 'n', 'v', }, desc = 'bwipeout proj right', },
    { '<leader>xor',     function() A.bdelete_ex_cur_root() end,       mode = { 'n', 'v', }, desc = 'bdelete buffers exclude cur_root', },
    { '<leader>xr',      function() A.listed_cur_root_files() end,     mode = { 'n', 'v', }, desc = 'listed cur root buffers', },
    { '<leader>x<c-r>',  function() A.listed_cur_root_files 'all' end, mode = { 'n', 'v', }, desc = 'listed cur root buffers all', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.toggle()
  local start_time = M._s()
  local A = require 'config.my.toggle'
  M._m {
    { '<leader>t',  name = 'toggle', },
    { '<leader>td', function() A.diff() end,         mode = { 'n', 'v', }, silent = true, desc = 'diff', },
    { '<leader>tw', function() A.wrap() end,         mode = { 'n', 'v', }, silent = true, desc = 'wrap', },
    { '<leader>tn', function() A.nu() end,           mode = { 'n', 'v', }, silent = true, desc = 'nu', },
    { '<leader>tr', function() A.renu() end,         mode = { 'n', 'v', }, silent = true, desc = 'renu', },
    { '<leader>ts', function() A.signcolumn() end,   mode = { 'n', 'v', }, silent = true, desc = 'signcolumn', },
    { '<leader>tc', function() A.conceallevel() end, mode = { 'n', 'v', }, silent = true, desc = 'conceallevel', },
    { '<leader>tk', function() A.iskeyword() end,    mode = { 'n', 'v', }, silent = true, desc = 'iskeyword', },
  }
  M._c(M._e(start_time), debug.getinfo(1)['name'])
end

function M.hili()
  local start_time = M._s()
  local A = require 'config.my.hili'
  M._m {
    { '*',       function() A.search() end,          mode = { 'v', },      silent = true, desc = 'hili: multiline search', },
    -- windo cursorword
    { '<a-7>',   function() A.cursorword() end,      mode = { 'n', },      silent = true, desc = 'hili: cursor word', },
    { '<a-8>',   function() A.windocursorword() end, mode = { 'n', },      silent = true, desc = 'hili: windo cursor word', },
    -- cword hili
    { '<c-8>',   function() A.hili_n() end,          mode = { 'n', },      silent = true, desc = 'hili: cword', },
    { '<c-8>',   function() A.hili_v() end,          mode = { 'v', },      silent = true, desc = 'hili: cword', },
    -- cword hili rm
    { '<c-s-8>', function() A.rmhili_v() end,        mode = { 'v', },      silent = true, desc = 'hili: rm v', },
    { '<c-s-8>', function() A.rmhili_n() end,        mode = { 'n', },      silent = true, desc = 'hili: rm n', },
    -- select hili
    { '<c-7>',   function() A.selnexthili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: sel next', },
    { '<c-s-7>', function() A.selprevhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: sel prev', },
    -- go hili
    { '<c-n>',   function() A.prevhili() end,        mode = { 'n', 'v', }, silent = true, desc = 'hili: go prev', },
    { '<c-m>',   function() A.nexthili() end,        mode = { 'n', 'v', }, silent = true, desc = 'hili: go next', },
    -- go cur hili
    { '<c-s-n>', function() A.prevcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: go cur prev', },
    { '<c-s-m>', function() A.nextcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'hili: go cur next', },
    -- rehili
    { '<c-s-9>', function() A.rehili() end,          mode = { 'n', 'v', }, silent = true, desc = 'hili: rehili', },
    -- search cword
    { "<c-s-'>", function() A.prevlastcword() end,   mode = { 'n', 'v', }, silent = true, desc = 'hili: prevlastcword', },
    { '<c-s-/>', function() A.nextlastcword() end,   mode = { 'n', 'v', }, silent = true, desc = 'hili: nextlastcword', },
    { '<c-,>',   function() A.prevcword() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: prevcword', },
    { '<c-.>',   function() A.nextcword() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: nextcword', },
    { "<c-'>",   function() A.prevcWORD() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: prevcWORD', },
    { '<c-/>',   function() A.nextcWORD() end,       mode = { 'n', 'v', }, silent = true, desc = 'hili: nextcWORD', },
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

M.base()
M.box()
M.copy()
M.window()
M.toggle()
M.hili()
M.svn()

return M
