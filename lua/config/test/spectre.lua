-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/09 16:12:36 Saturday

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])

B.del_map({ 'n', 'v', }, '<leader>r')

B.whichkey_register({ 'n', 'v', }, '<leader>r', 'test.spectre')

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

function M.replace_do()
  local file = M._replace_files[M._replace_cnt]
  local ext = string.match(file, '%.([^.]+)$')
  while ext ~= 'md' do
    M._replace_cnt = M._replace_cnt + 1
    file = M._replace_files[M._replace_cnt]
    ext = string.match(file, '%.([^.]+)$')
  end
  B.cmd('e %s', file)
  B.set_timeout(100, function()
    M._replace_cnt = M._replace_cnt + 1
    if M._replace_cnt <= #M._replace_files then
      M.replace_do()
    else
      B.print('replace %d done', #M._replace_files)
      B.aucmd({ 'BufEnter', }, 'test_replace_without_spectre', {
        callback = function()
        end,
      })
    end
  end)
end

function M.replace()
  M._replace_files = B.scan_files_deep [[c:\Users\depei_liu\appdata\local\repos\2024s]]
  M._replace_cnt = 1
  B.aucmd({ 'BufEnter', }, 'test_replace_without_spectre', {
    callback = function()
      vim.schedule(function()
        -- vim.print [[try|%s/20\(2[34]\d\{2}\)\(\d\{2}\)/\=submatch(1)..submatch(2)/g|catch|endtry]]
        vim.cmd [[try|%s/20\(2[34]\d\{2}\)\(\d\{2}\)/\=submatch(1)..submatch(2)/g|catch|endtry]]
      end)
    end,
  })
  M.replace_do()
end

return M
