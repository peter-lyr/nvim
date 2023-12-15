local M = {}

local B = require 'base'

M.lua = B.getlua(debug.getinfo(1)['source'])
M.source = B.getsource(M.lua)

M.DOC_EXTS = {
  'doc', 'docx',
  'html',
  'pdf',
}

M._en = 1
M._last_file = ''
M._callbacks = {}

-- eanblea or disable
function M.enable()
  M._en = 1
end

function M.disable()
  M._en = nil
end

-- bin
function M.bin_xxd(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  if M._is_bin(cur_file) then
    B.system_run('start silent', '"%s"', cur_file)
  end
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
      ['bin_xxd'] = function() M.bin_xxd(cur_file) end,
    }
  end
end

-- doc
function M.doc_open(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  if B.is_file_in_extensions(M.DOC_EXTS, cur_file) then
    B.system_run('start silent', '"%s"', cur_file)
  end
end

function M._check_doc(cur_file)
  if not cur_file then cur_file = vim.api.nvim_buf_get_name(0) end
  if B.is_file_in_extensions(M.DOC_EXTS, cur_file) then
    return {
      ['doc_open'] = function() M.doc_open(cur_file) end,
    }
  end
end

-- aucmd
B.aucmd('BufReadPre', 'my.drag.BufReadPre', {
  callback = function(ev)
    if M._en then
      local file = B.get_full_name(ev.file)
      M._callbacks = { ['nop'] = function() end, }
      M._callbacks = B.merge_dict(M._callbacks, M._check_bin(file))
      M._callbacks = B.merge_dict(M._callbacks, M._check_doc(file))
    end
  end,
})

B.aucmd('BufReadPost', 'my.drag.BufReadPost', {
  callback = function()
    if M._en then
      local count = B.get_dict_count(M._callbacks)
      if count == 1 then
        for _, callback in pairs(M._callbacks) do callback() end
      elseif count > 1 then
        M._callbacks = B.merge_dict(M._callbacks, { ['delete'] = function() vim.cmd 'Bdelete!' end, })
        B.ui_sel(vim.tbl_keys(M._callbacks), 'Drag', function(callback)
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
    if M._en then
      M._last_file = B.get_full_name(ev.file)
    end
  end,
})

B.create_user_command_with_M(M, 'Drag')

return M
