-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/28 13:51:07 Thursday

-- aescrypt.exe -e -p 123456 -o a.txt.bin a.txt
-- aescrypt.exe -d -p 123456 -o a.txt.dec.txt a.txt.bin

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.crypt_exe_dir_path = B.getcreate_dirpath(M.source .. '.exe')
M.aescrypt_exe = B.get_filepath(M.crypt_exe_dir_path.filename, 'aescrypt.exe').filename

M.encrypt_fts = {
  'md',
}

M.decrypt_fts = {
  'bin',
}

function M.encrypt(ifile, ofile, pass)
  if not ifile then
    ifile = B.buf_get_name_0()
  end
  local ext = vim.fn.tolower(string.match(ifile, '%.([^.]+)$'))
  if not B.is_in_tbl(ext, M.encrypt_fts) then
    return
  end
  if not ofile then
    ofile = vim.fn.fnamemodify(ifile, ':p:r') .. '.bin'
  end
  if not pass then
    pass = vim.fn.fnamemodify(ifile, ':p:t:r')
  end
  B.system_run('start silent', '%s -e -p %s -o %s %s', M.aescrypt_exe, pass, ofile, ifile)
  B.cmd('Bdelete %s', ifile)
  B.system_run('start silent', [[del /s /q %s]], ifile)
end

function M.decrypt(ifile, ofile, pass)
  if not ifile then
    ifile = B.buf_get_name_0()
  end
  local ext = vim.fn.tolower(string.match(ifile, '%.([^.]+)$'))
  if not B.is_in_tbl(ext, M.decrypt_fts) then
    return
  end
  if not ofile then
    ofile = vim.fn.fnamemodify(ifile, ':p:r') .. '.md'
  end
  if not pass then
    pass = vim.fn.fnamemodify(ifile, ':p:t:r')
  end
  B.system_run('start silent', '%s -d -p %s -o %s %s', M.aescrypt_exe, pass, ofile, ifile)
  B.system_run('start silent', [[del /s /q %s]], ifile)
end

vim.api.nvim_create_user_command('EncryptMd', function(params)
  M.encrypt(unpack(params['fargs']))
end, { nargs = '*', })

vim.api.nvim_create_user_command('DecryptBin', function(params)
  M.decrypt(unpack(params['fargs']))
end, { nargs = '*', })

return M
