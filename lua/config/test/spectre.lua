-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/09 16:12:36 Saturday

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])

B.del_map({ 'n', 'v', }, '<leader>r')

require 'which-key'.register { ['<leader>r'] = { name = 'test.spectre', }, }

M.spectre_dir = B.getcreate_dir(M.source .. '.exe')

M.sed_exe = B.get_filepath(M.spectre_dir, 'sed.exe').filename

require 'spectre'.setup {
  replace_engine = {
    ['sed'] = {
      cmd = M.sed_exe,
      args = {
        '-i',
        '-E',
      },
      options = {
        ['ignore-case'] = {
          value = '--ignore-case',
          icon = '[I]',
          desc = 'ignore case',
        },
      },
    },
    -- call rust code by nvim-oxi to replace
    ['oxi'] = {
      cmd = 'oxi',
      args = {},
      options = {
        ['ignore-case'] = {
          value = 'i',
          icon = '[I]',
          desc = 'ignore case',
        },
      },
    },
  },
}

return M
