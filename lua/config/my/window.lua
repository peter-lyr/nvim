local M = {}

local B = require 'base'

M.donot_change_fts = {
  'NvimTree',
  'aerial',
  'qf',
  'fugitive',
}

function M.change_around(dir)
  local winid1, bufnr1, winid2, bufnr2
  if B.is_in_tbl(vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype'), M.donot_change_fts) then
    return
  end
  winid1 = vim.fn.win_getid()
  bufnr1 = vim.fn.bufnr()
  vim.cmd('wincmd ' .. dir)
  winid2 = vim.fn.win_getid()
  if B.is_in_tbl(vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype'), M.donot_change_fts) then
    vim.fn.win_gotoid(winid1)
    return
  end
  if winid1 ~= winid2 then
    bufnr2 = vim.fn.bufnr()
    vim.cmd('b' .. tostring(bufnr1))
    vim.fn.win_gotoid(winid1)
    vim.cmd 'set nowinfixheight'
    vim.cmd 'set nowinfixwidth'
    vim.cmd('b' .. tostring(bufnr2))
    vim.fn.win_gotoid(winid2)
    vim.cmd 'set nowinfixheight'
    vim.cmd 'set nowinfixwidth'
  end
end

M.max_height_en = nil

function M.go_window(dir)
  B.cmd('wincmd %s', dir)
  if B.is_in_tbl(dir, { 'j', 'k', }) and M.max_height_en then
    if not B.is(vim.o.winfixheight) then
      B.win_max_height()
    end
  end
end

B.aucmd({ 'BufEnter', }, 'my.window.BufEnter', {
  callback = function(ev)
    if vim.api.nvim_win_get_height(0) == 1 and B.is(vim.o.winbar) then
      vim.api.nvim_win_set_height(vim.fn.win_getid(vim.fn.bufwinnr(ev.buf)), 2)
    end
  end,
})

function M.toggle_max_height()
  if M.max_height_en then
    vim.cmd 'wincmd ='
    M.max_height_en = nil
  else
    B.win_max_height()
    M.max_height_en = 1
  end
  B.echo('M.max_height_en: ' .. tostring(M.max_height_en))
end

function M.close_win_up()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd k'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

function M.close_win_down()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd j'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

function M.close_win_right()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd l'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

function M.go_last_window()
  local winid = vim.fn.win_getid(vim.fn.winnr '$')
  vim.fn.win_gotoid(winid)
end

function M.close_win_left()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd h'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

function M.close_cur()
  vim.cmd [[
    try
      close!
    catch
    endtry
  ]]
end

function M.bdelete_cur()
  vim.cmd [[
    try
      bdelete!
      e!
    catch
    endtry
  ]]
  require 'config.my.tabline'.update_bufs_and_refresh_tabline()
end

function M.Bdelete_cur()
  vim.cmd [[
    try
      Bdelete!
      e!
    catch
    endtry
  ]]
  require 'config.my.tabline'.update_bufs_and_refresh_tabline()
end

function M.bwipeout_cur()
  vim.cmd [[
    try
      bwipeout!
    catch
    endtry
  ]]
  require 'config.my.tabline'.update_bufs_and_refresh_tabline()
end

function M.Bwipeout_cur()
  vim.cmd [[
    try
      Bwipeout!
    catch
    endtry
  ]]
  require 'config.my.tabline'.update_bufs_and_refresh_tabline()
end

function M.bdelete_proj(dir)
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local winid = vim.fn.win_getid()
  B.cmd('wincmd %s', dir)
  if curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0())) then
    vim.fn.win_gotoid(winid)
    return
  end
  M.bdelete_cur_proj()
end

function M.bwipeout_proj(dir)
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local winid = vim.fn.win_getid()
  B.cmd('wincmd %s', dir)
  if curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0())) then
    vim.fn.win_gotoid(winid)
    return
  end
  M.bwipeout_cur_proj()
end

function M.listed_cur_root_files(all)
  local cwd = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local cur_root = require 'config.nvim.telescope'.cur_root[cwd]
  if cur_root and cur_root ~= cwd or all then
    if not cur_root then
      cur_root = cwd
    end
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local fname = B.rep_backslash_lower(vim.api.nvim_buf_get_name(bufnr))
      if cwd == B.rep_backslash_lower(vim.fn['ProjectRootGet'](fname)) then
        if string.sub(fname, 1, #cur_root) == cur_root and string.sub(fname, #cur_root + 1, #cur_root + 1) == '/' then
          vim.api.nvim_buf_set_option(bufnr, 'buflisted', true)
        end
      end
    end
    M.refresh()
  end
end

function M.bdelete_ex_cur_root()
  local cwd = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local cur_root = require 'config.nvim.telescope'.cur_root[cwd]
  if cur_root and cur_root ~= cwd then
    local curbuf = vim.fn.bufnr()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local fname = B.rep_backslash_lower(vim.api.nvim_buf_get_name(bufnr))
      if B.is_file(fname) and cwd == B.rep_backslash_lower(vim.fn['ProjectRootGet'](fname)) then
        if string.sub(fname, 1, #cur_root) ~= cur_root or string.sub(fname, #cur_root + 1, #cur_root + 1) ~= '/' then
          if bufnr == curbuf then
            pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
          else
            pcall(vim.cmd, 'bdelete! ' .. tostring(bufnr))
          end
        end
      end
    end
    M.refresh()
  end
end

function M.refresh()
  vim.cmd 'e!'
  vim.cmd 'ProjectRootCD'
  B.set_timeout(200, function()
    require 'config.my.tabline'.update_bufs_and_refresh_tabline()
  end)
end

function M.bdelete_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bdelete! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.Bdelete_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.bwipeout_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bwipeout! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.Bwipeout_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.close_cur_tab()
  vim.cmd [[
    try
      tabclose!
    catch
    endtry
  ]]
end

function M.bwipeout_cur_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    end
  end
  M.close_cur_tab()
  B.try_close_cur_buffer()
  M.refresh()
end

function M.bdelete_cur_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
    end
  end
  M.close_cur_tab()
  B.try_close_cur_buffer()
  M.refresh()
end

function M.bwipeout_other_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot ~= B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.bdelete_other_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot ~= B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.get_deleted_bufnrs()
  return vim.tbl_filter(function(bufnr)
    if 1 ~= vim.fn.buflisted(bufnr) then
      local pfname = require 'plenary.path':new(vim.api.nvim_buf_get_name(bufnr))
      if (string.match(pfname.filename, 'diffview://') or pfname:exists()) and not pfname:is_dir() then
        return true
      end
      return false
    end
    return false
  end, vim.api.nvim_list_bufs())
end

function M.bwipeout_deleted()
  local info = {}
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    info[#info + 1] = 'bwipeout -> ' .. vim.fn.bufname(bufnr)
    pcall(vim.cmd, 'bwipeout ' .. tostring(bufnr))
  end
  table.insert(info, 1, string.format('%d buffer(s) deleted', #info))
  B.notify_info(info)
end

function M.reopen_deleted()
  local deleted_bufnames = {}
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    deleted_bufnames[#deleted_bufnames + 1] = vim.api.nvim_buf_get_name(bufnr)
  end
  if #deleted_bufnames == 0 then
    return
  end
  vim.ui.select(deleted_bufnames, { prompt = 'reopen bwipeout buffers', }, function(choice, _)
    if not choice then
      return
    end
    B.jump_or_split(choice)
  end)
end

function M.get_unloaded_bufnrs()
  return vim.tbl_filter(function(bufnr)
    if 1 ~= vim.fn.bufloaded(bufnr) then
      return true
    end
    return false
  end, vim.api.nvim_list_bufs())
end

function M.bwipeout_unloaded()
  local info = {}
  for _, bufnr in ipairs(M.get_unloaded_bufnrs()) do
    info[#info + 1] = 'bwipeout -> ' .. vim.fn.bufname(bufnr)
    pcall(vim.cmd, 'bwipeout ' .. tostring(bufnr))
  end
  table.insert(info, 1, string.format('%d buffer(s) bwipeout', #info))
  B.notify_info(info)
end

function M.bwipeout_unmodified()
  local info = {}
  local cwd = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local modified_files = B.get_git_modified_files()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if B.is(vim.fn.bufloaded(bufnr)) then
      local fname = B.rep_backslash_lower(vim.api.nvim_buf_get_name(bufnr))
      if cwd == B.rep_backslash_lower(vim.fn['ProjectRootGet'](fname)) then
        fname = string.sub(fname, #cwd + 2, #fname)
        if B.is(fname) and not B.is_in_tbl(fname, modified_files) then
          pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
          info[#info + 1] = 'Bdelete -> ' .. fname
        end
      end
    end
  end
  table.insert(info, 1, string.format('%d buffer(s) bdelete', #info))
  B.notify_info(info)
  M.refresh()
end

return M
