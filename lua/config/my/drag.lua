local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.MARKDOWN_EXTS = {
  'md',
}

M.IMAGE_EXTS = { 'jpg', 'png', }

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

M._last_file = ''
M._last_lnr = 1

-- eanblea or disable
function M.enable_check_all()
  M.en_check_all = 1
end

function M.disable_check_all()
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
function M._is_in_markdown_fts(file)
  return B.is_file_in_extensions(M.MARKDOWN_EXTS, file)
end

function M._is_in_image_fts(file)
  return B.is_file_in_extensions(M.IMAGE_EXTS, file)
end

function M._is_in_doc_fts(file)
  return B.is_file_in_extensions(M.DOC_EXTS, file)
end

function M._is_in_bin_fts(file)
  return B.is_file_in_extensions(M.BIN_EXTS, file)
end

function M._is_detected_as_bin(file)
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

function M.system_open_and_delete_buffer(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
  B.system_run('start silent', '"%s"', file)
  M._delete_buffer(file)
end

-- image
M._image_root_dir_name = '.images'
M._image_root_dir_md_name = '_.md'

function M._copy_image_2_markdown(image_file, markdown_file, lnr)
  local _proj_root = vim.fn['ProjectRootGet'](markdown_file)
  if not B.is(_proj_root) then
    B.notify_info('not in a project root: ' .. markdown_file)
    return
  end
  local _image_root_dir = B.getcreate_dirpath { _proj_root, M._image_root_dir_name, }.filename
  local _image_root_dir_md_path = B.getcreate_filepath(_image_root_dir, M._image_root_dir_md_name)
  local _image_hash_64 = B.get_hash(image_file)
  local _image_hash_8 = string.sub(_image_hash_64, 1, 8)
  local _image_fname_tail = vim.fn.fnamemodify(image_file, ':t')
  local _image_fname_tail_root = vim.fn.fnamemodify(_image_fname_tail, ':r')
  local _image_fname_tail_ext = vim.fn.fnamemodify(_image_fname_tail, ':e')
  local _image_hash_name = _image_hash_8 .. '.' .. _image_fname_tail_ext
  local _image_target_file = B.getcreate_filepath(_image_root_dir, _image_hash_name).filename
  -- TODO: [Done] copy image_file to _image_root_dir
  vim.fn.system(string.format('copy /y "%s" "%s"', image_file, _image_target_file))
  -- TODO: [Done] create _image_root_dir_md_name image url
  local _image_root_dir_md_url = string.format('![%s](%s)\n', _image_fname_tail_root, _image_hash_name)
  -- TODO: [Done] write _image_root_dir_md_name image url
  _image_root_dir_md_path:write(_image_root_dir_md_url, 'a')
  -- TODO: [Done] create markdown_file image url
  local relative = vim.fn['repeat']('../', B.count_char(B.rep_slash_lower(string.sub(markdown_file, #_proj_root + 2, #markdown_file)), '\\'))
  local _image_root_dir_md_url_relative = string.format('![%s](%s%s/%s)', _image_fname_tail_root, relative, M._image_root_dir_name, _image_hash_name)
  -- TODO: [Done] append markdown_file image url
  B.cmd('e %s', markdown_file)
  vim.fn.append(lnr, _image_root_dir_md_url_relative)
end

function M._copy_image_2_markdown_and_delete_buffer(image_file, markdown_file, lnr)
  if not M._is_in_image_fts(image_file) then
    return
  end
  if not M._is_in_markdown_fts(markdown_file) then
    return
  end
  M._copy_image_2_markdown(image_file, markdown_file, lnr)
  M._delete_buffer(image_file)
end

-- bin
function M.bin_xxd(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
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
    M.bin_xxd(file)
  end)
end

function M.bin_xxd_and_delete_buffer(file)
  if not file then file = vim.api.nvim_buf_get_name(0) end
  if M._is_detected_as_bin(file) then
    if not M._is_in_bin_fts(file) then
      local res = vim.fn.input('detected as binary file: ' .. file .. ', to xxd? [N/y]: ', 'y')
      if not B.is(vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res)) then
        return
      end
    end
    M._bin_xxd_and_delete_buffer(file)
  end
end

function M.bin_xxd_and_delete_buffer_force(file)
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
    { 'nop',                           function() end, },
    { 'delete buffer',                 function() M._delete_buffer(file) end, },
    { 'bin xxd and delete buffer',     function() M.bin_xxd_and_delete_buffer(file) end, },
    { 'system open and delete buffer', function() M.system_open_and_delete_buffer(file) end, },
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

    if M._is_in_markdown_fts(M._last_file) then
      if M._is_in_image_fts(M._cur_file) then
        M._copy_image_2_markdown_and_delete_buffer(M._cur_file, M._last_file, M._last_lnr)
        return
      end
    end

    if M._is_in_doc_fts(M._cur_file) then
      if M.en_doc_must_system_open then
        M.system_open_and_delete_buffer(M._cur_file)
        return
      end
      M._add_callbacks_basic(M._cur_file)
    end

    if M._is_detected_as_bin(M._cur_file) then
      if M.en_bin_must_xxd then
        M.bin_xxd_and_delete_buffer(M._cur_file)
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

B.aucmd('BufEnter', 'my.drag.BufEnter', {
  callback = function(ev)
    if M.en_check_all then
      M._last_file = B.get_full_name(ev.file)
    end
  end,
})

B.aucmd('CursorHold', 'my.drag.CursorHold', {
  callback = function()
    if M.en_check_all then
      M._last_lnr = vim.fn.line '.'
    end
  end,
})

function M.paste_jpg_2_markdown(png, no_input_image_name)
  print(string.format('## %s# %d', debug.getinfo(1)['source'], debug.getinfo(1)['currentline']))
  --   local file = vim.api.nvim_buf_get_name(0)
  --   local project = B.rep_slash_lower(vim.fn['ProjectRootGet'](file))
  --   local image_name = vim.fn.strftime '%Y%m%d-%A-%H%M%S'
  --   if not no_input_image_name then
  --     image_name = vim.fn.input('Input ' .. png .. ' image name: ', image_name .. '-')
  --   end
  --   if not B.is(image_name) then
  --     return
  --   end
  --   vim.g.temp_image_file = require 'plenary.path':new(vim.fn.expand '$temp'):joinpath(image_name .. '.' .. png).filename
  --   vim.g.temp_image_ext = png
  --   vim.g.temp_image_drag = require 'plenary.path':new(M.source):parent().filename
  --   vim.cmd [[
  --   python << EOF
  -- import vim
  -- import subprocess
  -- arg1 = vim.eval('g:temp_image_file')
  -- arg2 = vim.eval('g:temp_image_ext')
  -- cwd = vim.eval('g:temp_image_drag')
  -- psxmlgen = subprocess.Popen([r'powershell.exe', '-ExecutionPolicy', 'Unrestricted', './my_drag_images.lua.GetClipboardImage.ps1', arg1, arg2], cwd=cwd)
  -- psxmlgen.wait()
  --   EOF
  --   ]]
  --   if require 'plenary.path':new(vim.g.temp_image_file):exists() then
  --     M.prepare(project, vim.g.temp_image_file, file)
  --     M.save_image()
  --     M.append_info()
  --     M.append_line()
  --   else
  --     B.notify_info 'get image failed.'
  --   end
end

function M._is_image_in_clipboard()
  vim.g.temp_res = nil
  vim.cmd [[
    python << EOF
import vim
try:
  from PIL import ImageGrab, Image
except:
  import os
  cmd = "pip install pillow -i http://pypi.douban.com/simple --trusted-host pypi.douban.com"
  print(cmd)
  os.system(cmd)
  from PIL import ImageGrab, Image
img = ImageGrab.grabclipboard()
if isinstance(img, Image.Image):
  vim.command('let g:temp_res = 1')
EOF
  ]]
  local file = vim.api.nvim_buf_get_name(0)
  if not M._is_in_markdown_fts(file) then
    B.print('not a markdown file: ' .. file)
    return nil
  end
  local project = B.rep_slash_lower(vim.fn['ProjectRootGet'](file))
  if #project == 0 then
    B.print('not in a project root: ' .. file)
    return nil
  end
  return vim.g.temp_res
end

function M._middlemouse()
  if vim.fn.getmousepos()['line'] == 0 then
    return '<MiddleMouse>'
  end
  if M._is_image_in_clipboard() then
    return ':<c-u>Drag paste_jpg_2_markdown<cr>'
  end
  return '<MiddleMouse>'
end

B.lazy_map {
  { '<MiddleMouse>', M._middlemouse, mode = { 'n', 'v', }, silent = true, desc = 'my.drag: _middlemouse', expr = true, },
}

B.create_user_command_with_M(M, 'Drag')

return M
