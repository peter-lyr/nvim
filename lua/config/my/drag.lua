local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.DOC_EXTS = {
  'doc', 'docx',
  'html',
  'pdf',
}

M._en_total = 1
M._en_bin_must_xxd = 1
M._en_doc_must_system_open = 1
M._last_file = ''
M._callbacks = {}

M._xxd_output_dir_path = B.getcreate_temp_dirpath { 'xxd_output', }

-- eanblea or disable
function M.enable()
  M._en_total = 1
end

function M.disable()
  M._en_total = nil
end

function M.enable_bin_must_xxd()
  M._en_bin_must_xxd = 1
end

function M.disable_bin_must_xxd()
  M._en_bin_must_xxd = nil
end

function M.enable_doc_must_system_open()
  M._en_doc_must_system_open = 1
end

function M.disable_doc_must_system_open()
  M._en_doc_must_system_open = nil
end

-- common
function M._delete_buffer(cur_file)
  if cur_file then
    B.cmd('Bdelete! %s', cur_file)
  else
    vim.cmd 'Bdelete!'
  end
end

function M.system_open(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  B.system_run('start silent', '"%s"', cur_file)
end

-- bin
function M._xxd_do(cur_file)
  local bin_fname = B.rep_slash_lower(cur_file)
  local bin_fname_tail = vim.fn.fnamemodify(bin_fname, ':t')
  local bin_fname_full__ = string.gsub(vim.fn.fnamemodify(bin_fname, ':h'), '\\', '_')
  bin_fname_full__ = string.gsub(bin_fname_full__, ':', '_')
  local xxd_output_sub_dir_path = M._xxd_output_dir_path:joinpath(bin_fname_full__)
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

function M.bin_xxd(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  if M._is_bin(cur_file) then
    M._delete_buffer(cur_file)
    B.set_timeout(50, function()
      M._xxd_do(cur_file)
    end)
  end
end

function M.bin_xxd_force(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  M._delete_buffer(cur_file)
  B.set_timeout(50, function()
    M._xxd_do(cur_file)
  end)
end

function M._is_bin(cur_file)
  local info = vim.fn.system(string.format('file -b --mime-type --mime-encoding "%s"', cur_file))
  info = string.gsub(info, '%s', '')
  local info_l = vim.fn.split(info, ';')
  if info_l[2] and string.match(info_l[2], 'binary') and info_l[1] and not string.match(info_l[1], 'empty') then
    return 1
  end
  return nil
end

function M._check_bin(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  if M._is_bin(cur_file) then
    return {
      ['bin xxd and delete buffer'] = function()
        M.bin_xxd(cur_file)
        M._delete_buffer(cur_file)
      end,
      ['system open and delete buffer'] = function()
        M.system_open(cur_file)
        M._delete_buffer(cur_file)
      end,
    }
  end
end

-- doc
function M._check_doc(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  if B.is_file_in_extensions(M.DOC_EXTS, cur_file) then
    return {
      ['bin xxd and delete buffer'] = function()
        M.bin_xxd(cur_file)
        M._delete_buffer(cur_file)
      end,
      ['system open and delete buffer'] = function()
        M.system_open(cur_file)
        M._delete_buffer(cur_file)
      end,
    }
  end
end

-- aucmd
B.aucmd('BufReadPre', 'my.drag.BufReadPre', {
  callback = function(ev)
    if M._en_total then
      local file = B.get_full_name(ev.file)
      M._callbacks = { ['Nop'] = function() end, }
      M._callbacks = B.merge_dict(M._callbacks, M._check_bin(file))
      M._callbacks = B.merge_dict(M._callbacks, M._check_doc(file))
    end
  end,
})

B.aucmd('BufReadPost', 'my.drag.BufReadPost', {
  callback = function(ev)
    if M._en_total then
      if M._en_doc_must_system_open and B.is_file_in_extensions(M.DOC_EXTS, ev.file) then
        M.system_open(ev.file)
        M._delete_buffer(ev.file)
        return
      elseif M._en_bin_must_xxd and M._is_bin(ev.file) then
        M.bin_xxd(ev.file)
        M._delete_buffer(ev.file)
        return
      end
      local count = B.get_dict_count(M._callbacks)
      if count == 1 then
        for _, callback in pairs(M._callbacks) do callback() end
      elseif count > 1 then
        M._callbacks = B.merge_dict(M._callbacks, { ['Delete buffer'] = function() M._delete_buffer(ev.file) end, })
        B.ui_sel(vim.fn.sort(vim.tbl_keys(M._callbacks)), 'Drag', function(callback)
          if callback then
            M._callbacks[callback]()
          end
        end)
      end
    end
  end,
})

B.aucmd('BufEnter', 'my.drag.BufEnter', {
  callback = function(ev)
    if M._en_total then
      M._last_file = B.get_full_name(ev.file)
    end
  end,
})

B.create_user_command_with_M(M, 'Drag')

return M
