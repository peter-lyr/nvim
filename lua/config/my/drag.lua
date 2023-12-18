local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.DOC_EXTS = {
  'doc', 'docx',
  'html',
  'pdf',
}

M.BIN_EXTS = {
  'bin',
  'wav', 'mp3',
}

M.en_check_all = 1
M.en_doc_must_system_open = 1
M.en_bin_must_xxd = 1

M.xxd_output_dir_path = B.getcreate_temp_dirpath { 'xxd_output', }

-- eanblea or disable
function M.enable()
  M.en_check_all = 1
end

function M.disable()
  M.en_check_all = nil
end

function M.enable_bin_must_xxd()
  M.en_bin_must_xxd = 1
end

function M.disable_bin_must_xxd()
  M.en_bin_must_xxd = nil
end

function M.enable_doc_must_system_open()
  M.en_doc_must_system_open = 1
end

function M.disable_doc_must_system_open()
  M.en_doc_must_system_open = nil
end

-- is
function M._is_doc(file)
  return B.is_file_in_extensions(M.DOC_EXTS, file)
end

function M._is_bin(file)
  local info = vim.fn.system(string.format('file -b --mime-type --mime-encoding "%s"', file))
  info = string.gsub(info, '%s', '')
  local info_l = vim.fn.split(info, ';')
  if info_l[2] and string.match(info_l[2], 'binary') and info_l[1] and not string.match(info_l[1], 'empty') then
    return 1
  end
  return nil
end

-- common
function M._delete_buffer(file)
  if file then
    B.cmd('Bdelete! %s', file)
  else
    vim.cmd 'Bdelete!'
  end
end

function M.system_open(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
  B.system_run('start silent', '"%s"', file)
  M._delete_buffer(file)
end

-- bin
function M._xxd_do(file)
  local bin_fname = B.rep_slash_lower(file)
  local bin_fname_tail = vim.fn.fnamemodify(bin_fname, ':t')
  local bin_fname_full__ = string.gsub(vim.fn.fnamemodify(bin_fname, ':h'), '\\', '_')
  bin_fname_full__ = string.gsub(bin_fname_full__, ':', '_')
  local xxd_output_sub_dir_path = M.xxd_output_dir_path:joinpath(bin_fname_full__)
  if not xxd_output_sub_dir_path:exists() then vim.fn.mkdir(xxd_output_sub_dir_path.filename) end
  local xxd = xxd_output_sub_dir_path:joinpath(bin_fname_tail .. '.xxd').filename
  local c = xxd_output_sub_dir_path:joinpath(bin_fname_tail .. '.c').filename
  local bak = xxd_output_sub_dir_path:joinpath(bin_fname_tail .. '.bak').filename
  vim.fn.system(string.format('copy /y "%s" "%s"', bin_fname, bak))
  vim.fn.system(string.format('xxd "%s" "%s"', bak, xxd))
  vim.fn.system(string.format('%s && xxd -i "%s" "%s"', B.system_cd(bak), vim.fn.fnamemodify(bak, ':t'), c))
  vim.cmd('e ' .. xxd)
  vim.cmd 'setlocal ft=xxd'
end

function M._bin_xxd_and_delete_buffer(file)
  M._delete_buffer(file)
  B.set_timeout(50, function()
    M._xxd_do(file)
  end)
end

function M.bin_xxd(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
  if M._is_bin(file) then
    if not B.is_file_in_extensions(M.BIN_EXTS, file) then
      local res = vim.fn.input('detected as binary file: ' .. file .. ', to xxd? [N/y]: ', 'y')
      if not B.is(vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res)) then
        return
      end
    end
    M._bin_xxd_and_delete_buffer(file)
  end
end

function M.bin_xxd_force(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
  M._bin_xxd_and_delete_buffer(file)
end

-- callback
M._titles = {}
M._callbacks = {}

function M._add_callbacks(tbl)
  for _, v in ipairs(tbl) do
    if not B.is(vim.tbl_contains(M._titles, v[1])) then
      M._titles[#M._titles + 1] = v[1]
      M._callbacks[#M._callbacks + 1] = v[2]
    end
  end
end

function M._add_callbacks_basic(file)
  M._add_callbacks {
    { 'bin xxd and delete buffer',     function() M.bin_xxd(file) end, },
    { 'system open and delete buffer', function() M.system_open(file) end, },
  }
end

B.aucmd('BufReadPost', 'my.drag.BufReadPost', {
  callback = function(ev)
    if not M.en_check_all then
      return
    end
    M._cur_file = B.get_full_name(ev.file)
    M._titles = {}
    M._callbacks = {}

    if M._is_doc(M._cur_file) then
      if M.en_doc_must_system_open then
        M.system_open(M._cur_file)
        return
      end
      M._add_callbacks_basic(M._cur_file)
    end

    if M._is_bin(M._cur_file) then
      if M.en_bin_must_xxd then
        M.bin_xxd_force(M._cur_file)
        return
      end
      M._add_callbacks_basic(M._cur_file)
    end

    if #M._callbacks == 1 then
      M._callbacks[1]()
    else
      B.ui_sel(M._titles, 'Drag', function(_, index)
        M._callbacks[index]()
      end)
    end
  end,
})

B.create_user_command_with_M(M, 'Drag')

return M
