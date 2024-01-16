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

function M.copy_cfile_path_clip()
  local cfile = B.get_cfile()
  if B.is(cfile) and B.file_exists(cfile) then
    vim.fn.setreg('+', cfile)
    B.notify_info(cfile .. ' path copied as text')
  end
end

function M.copy_cfile_clip()
  local cfile = B.get_cfile()
  if B.is(cfile) and B.file_exists(cfile) then
    local copy2clip_exe = require 'config.test.nvimtree'.copy2clip_exe
    B.system_run('start silent', '%s "%s"', copy2clip_exe, cfile)
    B.notify_info(cfile .. ' copied')
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

-- table

M.markdowntable_line = 0

function M.get_paragraph()
  local paragraph = {}
  local linenr = vim.fn.line '.'
  local lines = 0
  for i = linenr, 1, -1 do
    local line = vim.fn.getline(i)
    if #line > 0 then
      lines = lines + 1
      table.insert(paragraph, 1, line)
    else
      M.markdowntable_line = i + 1
      break
    end
  end
  for i = linenr + 1, vim.fn.line '$' do
    local line = vim.fn.getline(i)
    if #line > 0 then
      table.insert(paragraph, line)
      lines = lines + 1
    else
      break
    end
  end
  return paragraph
end

function M.align_table()
  if vim.opt.modifiable:get() == 0 then
    return
  end
  if vim.opt.ft:get() ~= 'markdown' then
    return
  end
  local ll = vim.fn.getpos '.'
  local lines = M.get_paragraph()
  local cols = 0
  for _, line in ipairs(lines) do
    local cells = vim.fn.split(vim.fn.trim(line), '|')
    if string.match(line, '|') and cols < #cells then
      cols = #cells
    end
  end
  if cols == 0 then
    return
  end
  local Lines = {}
  local Matrix = {}
  for _, line in ipairs(lines) do
    local cells = vim.fn.split(vim.fn.trim(line), '|')
    local Cells = {}
    local matrix = {}
    for i = 1, cols do
      local cell = cells[i]
      if cell then
        cell = string.gsub(cells[i], '^%s*(.-)%s*$', '%1')
      else
        cell = ''
      end
      table.insert(Cells, cell)
      table.insert(matrix, { vim.fn.strlen(cell), vim.fn.strwidth(cell), })
    end
    table.insert(Lines, Cells)
    table.insert(Matrix, matrix)
  end
  local Cols = {}
  for i = 1, cols do
    local m = 0
    for j = 1, #Matrix do
      if Matrix[j][i][2] > m then
        m = Matrix[j][i][2]
      end
    end
    table.insert(Cols, m)
  end
  local newLines = {}
  for i = 1, #Lines do
    local Cells = Lines[i]
    local newCell = '|'
    for j = 1, cols do
      newCell = newCell .. string.format(string.format(' %%-%ds |', Matrix[i][j][1] + (Cols[j] - Matrix[i][j][2])), Cells[j])
    end
    table.insert(newLines, newCell)
  end
  vim.fn.setline(M.markdowntable_line, newLines)
  B.cmd('norm %dgg0%d|', ll[2], ll[3])
end

return M
