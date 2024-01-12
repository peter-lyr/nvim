local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

vim.g.mkdp_highlight_css = B.get_filepath(B.getcreate_dir(M.source .. '.preview'), 'mkdp_highlight.css').filename

-------------

M.markdown_export_py = B.get_filepath(B.getcreate_dir(M.source .. '.export'), 'markdown_export.py').filename

vim.api.nvim_create_user_command('MarkdownExportCreate', function()
  B.system_run('asyncrun', 'python %s %s & pause', M.markdown_export_py, vim.api.nvim_buf_get_name(0))
end, {
  nargs = 0,
  desc = 'MarkdownExportCreate',
})

M.fts = {
  'pdf', 'html', 'docx',
}

vim.api.nvim_create_user_command('MarkdownExportDelete', function()
  local files = B.scan_files_deep(nil, { filetypes = M.fts, })
  for _, file in ipairs(files) do
    B.delete_file(file)
  end
  B.notify_info(#files .. ' files deleting.')
end, {
  nargs = 0,
  desc = 'MarkdownExportDelete',
})

function M.system_open_cfile() B.system_open_file_silent('%s', B.get_cfile()) end

function M.buffer_open_cfile()
  local cfile = B.get_cfile()
  if B.is(cfile) and B.file_exists(cfile) then
    B.cmd('e %s', cfile)
  end
end

function M.copy_cfile_clip()
  local cfile = B.get_cfile()
  if B.is(cfile) and B.file_exists(cfile) then
    vim.fn.setreg('+', cfile)
    B.notify_info(cfile)
  end
end

function M.make_url()
  local file = vim.fn.getreg '+'
  if not B.file_exists(file) then
    return
  end
  local cur_file = vim.fn.expand '%:p:h'
  if not B.is(cur_file) then
    return
  end
  local rel = B.relpath(file, cur_file)
  if B.is(rel) then
    vim.fn.append('.', rel)
  else
    B.notify_info_append(string.format('not making rel: %s, %s', file, cur_file))
  end
end

return M
