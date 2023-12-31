local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

vim.g.mkdp_highlight_css = B.get_filepath(B.getcreate_dir(M.source .. '.css'), 'mkdp_highlight.css').filename

-------------

M.markdown_export_py = B.get_filepath(B.getcreate_dir(M.source .. '.py'), 'markdown_export.py').filename

vim.api.nvim_create_user_command('MarkdownExportCreate', function()
  B.system_run('start', 'python %s %s & pause', M.markdown_export_py, vim.api.nvim_buf_get_name(0))
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

return M
