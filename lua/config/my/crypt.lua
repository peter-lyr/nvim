-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/28 13:51:07 Thursday

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.crypt_exe_dir_path = B.getcreate_dirpath(M.source .. '.exe')
M.aescrypt_exe = B.get_filepath(M.crypt_exe_dir_path.filename, 'aescrypt.exe').filename
print("M.aescrypt_exe:", M.aescrypt_exe)

-- aescrypt.exe -e -p 123456 -o a.txt.bin a.txt
-- aescrypt.exe -d -p 123456 -o a.txt.dec.txt a.txt.bin

-- password: ldp-******

return M
