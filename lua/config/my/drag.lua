local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.MARKDOWN_EXTS = {
  'md',
}

M.IMAGE_EXTS = { 'jpg', 'png', }

M.NOT_IMAGE_EXTS = {
  'doc', 'docx',
  'html',
  'pdf',
  'wav', 'mp3',
}

M.BIN_EXTS = {
  'bin',
  'wav', 'mp3',
}

M.NOT_BIN_EXTS = {
  'lua',
  'c', 'h',
  'txt',
  'xm', 'lst',
  'bat', 'cmd',
}

M.en_check_all = 1
M.en_not_image_must_system_open = 1
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

function M.enable_not_image_must_system_open()
  M.en_not_image_must_system_open = 1
end

function M.disable_not_image_must_system_open()
  M.en_not_image_must_system_open = nil
end

-- is
function M._is_in_markdown_fts(file)
  return B.is_file_in_extensions(M.MARKDOWN_EXTS, file)
end

function M._is_in_image_fts(file)
  return B.is_file_in_extensions(M.IMAGE_EXTS, file)
end

function M._is_in_not_image_fts(file)
  return B.is_file_in_extensions(M.NOT_IMAGE_EXTS, file)
end

function M._is_in_bin_fts(file)
  return B.is_file_in_extensions(M.BIN_EXTS, file)
end

function M._is_in_not_bin_fts(file)
  return B.is_file_in_extensions(M.NOT_BIN_EXTS, file)
end

function M._is_detected_as_bin(file)
  if M._is_in_not_bin_fts(file) then
    return nil
  end
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
M._image_paste_temp_name = 'nvim_paste_temp'

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
  if _image_fname_tail_root == M._image_paste_temp_name then
    _image_fname_tail_root = vim.fn.strftime '%Y%m%d-%A-%H%M%S'
  end
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
  M._copy_image_2_markdown(image_file, markdown_file, lnr)
  M._delete_buffer(image_file)
end

-- not_image
M._not_image_root_dir_name = '.not_images'
M._not_image_root_dir_md_name = '_.md'
M._not_image_paste_temp_name = 'nvim_paste_temp'

function M._copy_not_image_2_markdown(not_image_file, markdown_file, lnr)
  local _proj_root = vim.fn['ProjectRootGet'](markdown_file)
  if not B.is(_proj_root) then
    B.notify_info('not in a project root: ' .. markdown_file)
    return
  end
  local _not_image_root_dir = B.getcreate_dirpath { _proj_root, M._not_image_root_dir_name, }.filename
  local _not_image_root_dir_md_path = B.getcreate_filepath(_not_image_root_dir, M._not_image_root_dir_md_name)
  local _not_image_hash_64 = B.get_hash(not_image_file)
  local _not_image_hash_8 = string.sub(_not_image_hash_64, 1, 8)
  local _not_image_fname_tail = vim.fn.fnamemodify(not_image_file, ':t')
  local _not_image_fname_tail_root = vim.fn.fnamemodify(_not_image_fname_tail, ':r')
  if _not_image_fname_tail_root == M._not_image_paste_temp_name then
    _not_image_fname_tail_root = vim.fn.strftime '%Y%m%d-%A-%H%M%S'
  end
  local _not_image_fname_tail_ext = vim.fn.fnamemodify(_not_image_fname_tail, ':e')
  local _not_image_hash_name = _not_image_hash_8 .. '.' .. _not_image_fname_tail_ext
  local _not_image_target_file = B.getcreate_filepath(_not_image_root_dir, _not_image_hash_name).filename
  -- TODO: [Done] copy not_image_file to _not_image_root_dir
  vim.fn.system(string.format('copy /y "%s" "%s"', not_image_file, _not_image_target_file))
  -- TODO: [Done] create _not_image_root_dir_md_name not_image url
  local _not_image_root_dir_md_url = string.format('[%s](%s)\n', _not_image_fname_tail_root, _not_image_hash_name)
  -- TODO: [Done] write _not_image_root_dir_md_name not_image url
  _not_image_root_dir_md_path:write(_not_image_root_dir_md_url, 'a')
  -- TODO: [Done] create markdown_file not_image url
  local relative = vim.fn['repeat']('../', B.count_char(B.rep_slash_lower(string.sub(markdown_file, #_proj_root + 2, #markdown_file)), '\\'))
  local _not_image_root_dir_md_url_relative = string.format('[%s](%s%s/%s)', _not_image_fname_tail_root, relative, M._not_image_root_dir_name, _not_image_hash_name)
  -- TODO: [Done] append markdown_file not_image url
  B.cmd('e %s', markdown_file)
  vim.fn.append(lnr, _not_image_root_dir_md_url_relative)
end

function M._copy_not_image_2_markdown_and_delete_buffer(not_image_file, markdown_file, lnr)
  M._copy_not_image_2_markdown(not_image_file, markdown_file, lnr)
  M._delete_buffer(not_image_file)
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
    if not M._is_in_bin_fts(file) and not M._is_in_not_bin_fts(file) then
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
    { 'nop',           function() end, },
    { 'delete buffer', function() M._delete_buffer(file) end, },
  }
end

function M._add_callbacks_no_markdown(file)
  M._add_callbacks {
    { 'bin xxd and delete buffer',     function() M.bin_xxd_and_delete_buffer(file) end, },
    { 'system open and delete buffer', function() M.system_open_and_delete_buffer(file) end, },
  }
end

function M._add_callbacks_markdown(cur_file, last_file, last_lnr)
  M._add_callbacks {
    { 'copy as   image   to markdown and delete buffer', function() M._copy_image_2_markdown_and_delete_buffer(cur_file, last_file, last_lnr) end, },
    { 'copy as not_image to markdown and delete buffer', function() M._copy_not_image_2_markdown_and_delete_buffer(cur_file, last_file, last_lnr) end, },
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
      if M._is_in_not_image_fts(M._cur_file) then
        M._copy_not_image_2_markdown_and_delete_buffer(M._cur_file, M._last_file, M._last_lnr)
        return
      end
      if M._is_detected_as_bin(M._cur_file) then
        if not M._is_in_bin_fts(M._cur_file) then
          M._add_callbacks_basic(M._cur_file)
          M._add_callbacks_markdown(M._cur_file, M._last_file, M._last_lnr)
        end
      end
    else
      if M._is_detected_as_bin(M._cur_file) then
        if M.en_bin_must_xxd then
          M.bin_xxd_and_delete_buffer(M._cur_file)
          return
        end
        M._add_callbacks_no_markdown(M._cur_file)
      elseif M._is_in_not_image_fts(M._cur_file) then
        if M.en_not_image_must_system_open then
          M.system_open_and_delete_buffer(M._cur_file)
          return
        end
        M._add_callbacks_no_markdown(M._cur_file)
      end
      if #M._callbacks > 0 then
        M._add_callbacks_basic(M._cur_file)
      end
    end

    B.ui_sel(M._titles, 'Drag', function(_, index)
      if index then
        M._callbacks[index]()
      end
    end)
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

-- image_type: 'jpg', 'png'
function M._paste_image_2_markdown(image_type)
  if not vim.g.paste_image_allowed and not M._is_to_paste_image() then
    return
  end
  -- TODO: [Done] paste to file
  vim.g.temp_image_file_with_ext = B.getcreate_temp_dirpath 'nvim_paste_image':joinpath(M._image_paste_temp_name).filename
  vim.g.temp_image_file = image_type and vim.g.temp_image_file_with_ext .. '.' .. image_type or ''
  vim.g.temp_image_type = image_type and image_type or ''
  vim.g.paste_image_allowed = nil
  vim.cmd [[
    python << EOF
import vim
import subprocess
temp_image_file = vim.eval('g:temp_image_file')
temp_image_type = vim.eval('g:temp_image_type')
temp_image_file_with_ext = vim.eval('g:temp_image_file_with_ext')
script_code = f"""
Add-Type -AssemblyName System.Windows.Forms;
if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {{
  $imageObj = [System.Drawing.Bitmap][System.Windows.Forms.Clipboard]::GetDataObject().getimage();
}}
"""
if temp_image_type:
  script_code += f'''
  $imageObj.Save("{temp_image_file}", [System.Drawing.Imaging.ImageFormat]::{temp_image_type});
'''
else:
  script_code += f'''
  $imageObj.Save("{temp_image_file_with_ext}.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg);
  $imageObj.Save("{temp_image_file_with_ext}.png", [System.Drawing.Imaging.ImageFormat]::Png);
'''
completed_process = subprocess.run(["powershell.exe", "-Command", script_code], capture_output=True, text=True)
if completed_process.returncode:
  print(f"Error: {completed_process.stderr}")
else:
  vim.command('let g:paste_image_allowed = 1')
EOF
]]
  if vim.g.paste_image_allowed then
    if not image_type then
      image_type = vim.fn.getfsize(vim.g.temp_image_file_with_ext .. '.jpg') > vim.fn.getfsize(vim.g.temp_image_file_with_ext .. '.png') and 'png' or 'jpg'
    end
    M._copy_image_2_markdown(vim.g.temp_image_file_with_ext .. '.' .. image_type, vim.api.nvim_buf_get_name(0), vim.fn.line '.')
  else
  end
end

function M.paste_small_image_2_markdown()
  M._paste_image_2_markdown()
end

function M.paste_png_2_markdown()
  M._paste_image_2_markdown 'png'
end

function M._is_to_paste_image()
  vim.g.paste_image_allowed = nil
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
  vim.command('let g:paste_image_allowed = 1')
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
  return vim.g.paste_image_allowed
end

function M._middlemouse()
  if vim.fn.getmousepos()['line'] == 0 then
    return '<MiddleMouse>'
  end
  if M._is_to_paste_image() then
    return ':<c-u>Drag paste_small_image_2_markdown<cr>'
  end
  return '<MiddleMouse>'
end

function M._s_middlemouse()
  if vim.fn.getmousepos()['line'] == 0 then
    return '<S-MiddleMouse>'
  end
  if M._is_to_paste_image() then
    return ':<c-u>Drag paste_png_2_markdown<cr>'
  end
  return '<S-MiddleMouse>'
end

B.lazy_map {
  { '<MiddleMouse>',   M._middlemouse,   mode = { 'n', 'v', }, silent = true, desc = 'my.drag: _middlemouse',   expr = true, },
  { '<S-MiddleMouse>', M._s_middlemouse, mode = { 'n', 'v', }, silent = true, desc = 'my.drag: _s_middlemouse', expr = true, },
}

B.create_user_command_with_M(M, 'Drag')

return M
