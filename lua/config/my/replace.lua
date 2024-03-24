-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/09 16:12:36 Saturday

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])

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

function M.replace_end()
  B.del_map {
    { 'n', 'v', }, '<F7>',
  }
  B.print('replace %d done', #M._replace_files)
  B.aucmd({ 'BufEnter', }, 'test_replace_without_spectre', {
    callback = function()
    end,
  })
end

function M.replace_do()
  local file = nil
  while 1 do
    M._replace_cnt = M._replace_cnt + 1
    if M._replace_cnt > #M._replace_files then
      M.replace_end()
      return
    end
    file = M._replace_files[M._replace_cnt]
    local ext = string.match(file, '%.([^.]+)$')
    if M.ext == '*' or ext == M.ext then
      local temp = nil
      for _, line in ipairs(vim.fn.readfile(file)) do
        if vim.fn.match(line, M.patt) > -1 then
          temp = 1
          break
        end
      end
      if temp then
        break
      end
    end
  end
  if not file or not B.is_file(file) then
    return
  end
  B.cmd('e %s', file)
  B.set_timeout(100, function()
    M._replace_cnt = M._replace_cnt + 1
    if M._replace_cnt <= #M._replace_files then
      M.replace_do()
    else
      M.replace_end()
    end
  end)
end

function Replace(patt, rep, ext, root)
  M.ext = ext
  M.patt = patt
  local substitute_string = string.format('%%s/%s/%s/g', patt, rep)
  if not root then
    root = vim.loop.cwd()
  else
    if not B.is_dir(root) then
      return
    end
  end
  B.lazy_map {
    { '<F7>', function() M._replace_cnt = #M._replace_files + 1 end, mode = { 'n', 'v', }, silent = true, desc = 'test_replace_without_spectre stop', },
  }
  B.notify_info 'Press <F7> to stop replacing.'
  M._replace_files = B.scan_files_deep(root)
  M._replace_cnt = 1
  B.aucmd({ 'BufEnter', }, 'test_replace_without_spectre', {
    callback = function()
      vim.schedule(function()
        B.cmd([[try|%s|catch|endtry]], substitute_string)
      end)
    end,
  })
  M.replace_do()
end

function M.test()
  B.cmd([[call feedkeys(":\<c-u>lua Replace(%s, %s, 'md')")]], string.format('[[%s]]', vim.fn.getreg '/'), '[[]]')
  vim.cmd [[call feedkeys("\<c-f>b5h")]]
end

-- Replace([[20\(2[34]\d\{2}\)\(\d\{2}\)]], [[\=submatch(1)..submatch(2)]], 'md', [[c:\Users\depei_liu\appdata\local\repos\2024s]])
-- Replace([[20\(2[34]\d\{2}\)\(\d\{2}\)]], [[\=submatch(1)..submatch(2)]], 'md')

function M.map()
  require 'which-key'.register {
    ['<leader>r'] = { name = 'Run Py/Find & Replace', },
    ['<leader>rf'] = { function() require 'spectre'.open_file_search { select_word = true, } end, 'Find <cword> & Replace in current buffer', mode = { 'n', 'v', }, silent = true, },
    ['<leader>r<c-f>'] = { function() require 'spectre'.open_file_search() end, 'Find copied text & Replace', mode = { 'n', 'v', }, silent = true, },
    ['<leader>rw'] = { function() require 'spectre'.open_visual { select_word = true, } end, 'Find <cword> & Replace in current project', mode = { 'n', 'v', }, silent = true, },
    ['<leader>r<c-w>'] = { function() require 'spectre'.open() end, 'Find & Replace in current project', mode = { 'n', 'v', }, silent = true, },
    ['<leader>rr'] = { function() M.test() end, 'My Find & Replace in current project', mode = { 'n', 'v', }, silent = true, },
  }
end

L(M, M.map)

return M
