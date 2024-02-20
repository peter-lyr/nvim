local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.last_fontsize_dir_path = B.getcreate_stddata_dirpath 'last-font-size'
M.last_fontsize_txt_path = M.last_fontsize_dir_path:joinpath 'last-font-size.txt'

M.normal_fontsize = 9

if not M.last_fontsize_txt_path:exists() then
  M.last_fontsize_txt_path:write(vim.inspect { [':::'] = 9, }, 'w')
end

function M._get_font_name_size()
  local fontname
  local fontsize
  for k, v in string.gmatch(vim.g.GuiFont, '(.*:h)(%d+)') do
    fontname, fontsize = k, v
  end
  return fontname, tonumber(fontsize)
end

local _, _fontsize = M._get_font_name_size()

M.projs_diff_font_size = B.read_table_from_file(M.last_fontsize_txt_path.filename)
M.lastfontsize = M.projs_diff_font_size[':::'] and M.projs_diff_font_size[':::'] or _fontsize

function M.save_last_fontsize()
  B.write_table_to_file(M.last_fontsize_txt_path.filename, M.projs_diff_font_size)
end

function M._change_font_size(name, size)
  local cmd = 'GuiFont! ' .. name .. size
  local _, __fontsize = M._get_font_name_size()
  if size ~= __fontsize then
    B.set_timeout(100, function() B.notify_info(cmd) end)
  end
  vim.cmd(cmd)
  local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if B.is(root_dir) then
    M.projs_diff_font_size[root_dir] = size
  end
end

function M.fontsize_up()
  local fontname, fontsize = M._get_font_name_size()
  if fontsize < 72 then
    M.lastfontsize = fontsize
    M._change_font_size(fontname, fontsize + 1)
  end
end

function M.fontsize_down()
  local fontname, fontsize = M._get_font_name_size()
  if fontsize > 1 then
    M.lastfontsize = fontsize
    M._change_font_size(fontname, fontsize - 1)
  end
end

function M.fontsize_normal()
  local fontname, fontsize = M._get_font_name_size()
  if B.is(fontsize == M.normal_fontsize) then
    M._change_font_size(fontname, M.lastfontsize)
  else
    M._change_font_size(fontname, M.normal_fontsize)
  end
end

function M.fontsize_min()
  local fontname, _ = M._get_font_name_size()
  M.lastfontsize = 1
  M._change_font_size(fontname, 1)
end

function M.fontsize_frameless() vim.fn['GuiWindowFrameless'](1 - vim.g.GuiWindowFrameless) end

function M.fontsize_fullscreen() vim.fn['GuiWindowFullScreen'](1 - vim.g.GuiWindowFullScreen) end

B.aucmd({ 'TabEnter', }, 'my.gui.TabEnter', {
  callback = function()
    local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
    if B.is(vim.tbl_contains(vim.tbl_keys(M.projs_diff_font_size), root_dir)) then
      local fontname, _ = M._get_font_name_size()
      M._change_font_size(fontname, M.projs_diff_font_size[root_dir])
    end
  end,
})

-- mappings
B.del_map({ 'n', 'v', }, '<c-0>')

require 'which-key'.register { ['<c-0>'] = { name = 'my.gui', }, }

B.lazy_map {
  { '<c-0>_',     M.fontsize_min,        mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size min', },
  { '<c-0><c-->', M.fontsize_frameless,  mode = { 'n', 'v', }, silent = true, desc = 'my.gui: frameless', },
  { '<c-0><c-=>', M.fontsize_fullscreen, mode = { 'n', 'v', }, silent = true, desc = 'my.gui: fullscreen', },
}

-- B.create_user_command_with_M(M, 'Gui')

return M
