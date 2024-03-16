-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/16 20:10:17 星期六

local M = {}

local start_time = vim.fn.reltime()

local r = require 'which-key'.register

function M.all_commands()
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
end

r {
  ['<c-;>'] = { M.all_commands, 'base: all commands', mode = { 'n', 'v', }, silent = true, },
}

function M.map(items)
  for _, item in ipairs(items) do
    local lhs = table.remove(item, 1)
    if not item['name'] then
      item[#item + 1] = item['desc']
    end
    r { [lhs] = item, }
  end
end

M.map {
  { '<leader>a', name = 'my.box', },
}

M.map {
  { '<F1>', function() require 'config.my.box'.show_info() end,             mode = { 'n', 'v', }, silent = true, desc = 'show info', },
  { '<F2>', function() require 'config.my.box'.replace_two_words 'n' end,   mode = { 'n', },      silent = true, desc = 'switch two words prepare', },
  { '<F2>', function() require 'config.my.box'.replace_two_words 'v' end,   mode = { 'v', },      silent = true, desc = 'switch two words prepare', },
  { '<F3>', function() require 'config.my.box'.replace_two_words_2 'n' end, mode = { 'n', },      silent = true, desc = 'switch two words do', },
  { '<F3>', function() require 'config.my.box'.replace_two_words_2 'v' end, mode = { 'v', },      silent = true, desc = 'switch two words do', },
}

M.map {
  { '<leader>as',         name = 'nvim-qt/programs', },
  { '<leader>asr',        function() require 'config.my.box'.restart_nvim_qt() end,              mode = { 'n', 'v', }, silent = true, desc = 'restart nvim-qt', },
  { '<leader>as<leader>', function() require 'config.my.box'.start_new_nvim_qt() end,            mode = { 'n', 'v', }, silent = true, desc = 'start new nvim-qt', },
  { '<leader>as;',        function() require 'config.my.box'.start_new_nvim_qt_cfile() end,      mode = { 'n', 'v', }, silent = true, desc = 'start new nvim-qt and open <cfile>', },
  { '<leader>asq',        function() require 'config.my.box'.quit_nvim_qt() end,                 mode = { 'n', 'v', }, silent = true, desc = 'quit nvim-qt', },
  { '<leader>asp',        function() require 'config.my.box'.sel_open_programs_file() end,       mode = { 'n', 'v', }, silent = true, desc = 'sel open programs file', },
  { '<leader>as<c-p>',    function() require 'config.my.box'.sel_open_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel open programs file force', },
  { '<leader>ask',        function() require 'config.my.box'.sel_kill_programs_file() end,       mode = { 'n', 'v', }, silent = true, desc = 'sel kill programs file', },
  { '<leader>as<c-k>',    function() require 'config.my.box'.sel_kill_programs_file_force() end, mode = { 'n', 'v', }, silent = true, desc = 'sel kill programs file force', },
  { '<leader>ass',        function() require 'config.my.box'.sel_open_startup_file() end,        mode = { 'n', 'v', }, silent = true, desc = 'sel open startup file', },
  { '<leader>aa',         function() require 'config.my.box'.source() end,                       mode = { 'n', 'v', }, silent = true, desc = 'source', },
  { '<leader>ax',         function() require 'config.my.box'.type_execute_output() end,          mode = { 'n', 'v', }, silent = true, desc = 'execute output to and open file', },
  { '<leader>ae',         function() require 'config.my.box'.sel_open_temp() end,                mode = { 'n', 'v', }, silent = true, desc = 'sel open temp file', },
  { '<leader>aw',         function() require 'config.my.box'.sel_write_to_temp() end,            mode = { 'n', 'v', }, silent = true, desc = 'sel write to temp file', },
  { '<leader>ac',         function() require 'config.my.box'.mes_clear() end,                    mode = { 'n', 'v', }, silent = true, desc = 'mes clear', },
}

M.map {
  { '<leader>ao',  name = 'open', },
  { '<leader>aop', function() require 'config.my.box'.open_path() end,  mode = { 'n', 'v', }, silent = true, desc = 'open path', },
  { '<leader>aos', function() require 'config.my.box'.open_sound() end, mode = { 'n', 'v', }, silent = true, desc = 'open sound', },
  { '<leader>aof', function() require 'config.my.box'.open_file() end,  mode = { 'n', 'v', }, silent = true, desc = 'open file in clipboard', },
}

M.map {
  { '<leader>am',  name = 'monitor', },
  { '<leader>am1', function() require 'config.my.box'.monitor_1min() end,   mode = { 'n', 'v', }, silent = true, desc = 'monitor 1 min', },
  { '<leader>am3', function() require 'config.my.box'.monitor_30min() end,  mode = { 'n', 'v', }, silent = true, desc = 'monitor 30 min', },
  { '<leader>am5', function() require 'config.my.box'.monitor_5hours() end, mode = { 'n', 'v', }, silent = true, desc = 'monitor 5 hours', },
}

M.map {
  { '<leader>ap',  name = 'prx', },
  { '<leader>apo', function() require 'config.my.box'.proxy_on() end,  mode = { 'n', 'v', }, silent = true, desc = 'prx on', },
  { '<leader>apf', function() require 'config.my.box'.proxy_off() end, mode = { 'n', 'v', }, silent = true, desc = 'prx off', },
}

M.map {
  { '<leader>ag',  name = 'git', },
  { '<leader>agm', function() require 'config.my.box'.git_init_and_cmake() end, mode = { 'n', 'v', }, silent = true, desc = 'git init and cmake', },
}

M.map {
  { '<leader>aq',  name = 'qf make conv', },
  { '<leader>aq8', function() require 'config.my.box'.qfmakeconv2utf8() end,  mode = { 'n', 'v', }, silent = true, desc = 'qf makeconv 2 utf8', },
  { '<leader>aq9', function() require 'config.my.box'.qfmakeconv2cp936() end, mode = { 'n', 'v', }, silent = true, desc = 'qf makeconv 2 cp936', },
}

local end_time = vim.fn.reltimefloat(vim.fn.reltime(start_time))
local startup_time = string.format('maps time: %.3f ms', end_time * 1000)
print(startup_time)

return M
