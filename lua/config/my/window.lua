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
    vim.cmd 'wincmd _'
  end
end

function M.toggle_max_height()
  if M.max_height_en then
    M.max_height_en = nil
  else
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

function M.refresh()
  vim.cmd 'e!'
  vim.cmd 'ProjectRootCD'
  B.set_timeout(200, function()
    require 'config.my.tabline'.update_bufs_and_refresh_tabline()
  end)
end

function M.bdelete_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bdelete! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.Bdelete_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.bwipeout_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  local curbuf = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbuf and curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bwipeout! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.Bwipeout_other()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
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
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    end
  end
  M.close_cur_tab()
  M.refresh()
end

function M.bdelete_cur_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
    end
  end
  M.close_cur_tab()
  M.refresh()
end

function M.bwipeout_other_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot ~= B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    end
  end
  M.refresh()
end

function M.bdelete_other_proj()
  local curroot = B.rep_backslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
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
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    print('Bwipeout! -> ' .. vim.fn.bufname(bufnr))
  end
end

function M.reopen_deleted()
  local deleted_bufnames = {}
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    deleted_bufnames[#deleted_bufnames + 1] = vim.api.nvim_buf_get_name(bufnr)
  end
  if #deleted_bufnames == 0 then
    return
  end
  vim.ui.select(deleted_bufnames, { prompt = 'reopen deleted buffers', }, function(choice, _)
    if not choice then
      return
    end
    vim.cmd('e ' .. choice)
  end)
end

B.lazy_map {
  { '<leader>wa',       function() M.change_around 'h' end,     mode = { 'n', 'v', }, desc = 'my.window: change_around', },
  { '<leader>ws',       function() M.change_around 'j' end,     mode = { 'n', 'v', }, desc = 'my.window: change_around', },
  { '<leader>ww',       function() M.change_around 'k' end,     mode = { 'n', 'v', }, desc = 'my.window: change_around', },
  { '<leader>wd',       function() M.change_around 'l' end,     mode = { 'n', 'v', }, desc = 'my.window: change_around', },

  { '<leader>w;',       function() M.toggle_max_height() end,   mode = { 'n', 'v', }, desc = 'my.window: go window up', },
  { '<leader>wh',       function() M.go_window 'l' end,         mode = { 'n', 'v', }, desc = 'my.window: go window up', },
  { '<leader>wj',       function() M.go_window 'j' end,         mode = { 'n', 'v', }, desc = 'my.window: go window down', },
  { '<leader>wk',       function() M.go_window 'k' end,         mode = { 'n', 'v', }, desc = 'my.window: go window left', },
  { '<leader>wl',       function() M.go_window 'l' end,         mode = { 'n', 'v', }, desc = 'my.window: go window right', },

  { '<leader>wm',       '<c-w>_',                               mode = { 'n', 'v', }, desc = 'my.window: window highest', },

  { '<leader>wu',       ':<c-u>new  to<cr>',                    mode = { 'n', 'v', }, desc = 'my.window: create new up window', },
  { '<leader>wi',       ':<c-u>new  bo<cr>',                    mode = { 'n', 'v', }, desc = 'my.window: create new down window', },
  { '<leader>wo',       ':<c-u>vnew to<cr>',                    mode = { 'n', 'v', }, desc = 'my.window: create new left window', },
  { '<leader>wp',       ':<c-u>vnew bo<cr>',                    mode = { 'n', 'v', }, desc = 'my.window: create new right window', },

  { '<leader>wc',       '<c-w>H',                               mode = { 'n', 'v', }, desc = 'my.window: be most up window', },
  { '<leader>wv',       '<c-w>J',                               mode = { 'n', 'v', }, desc = 'my.window: be most down window', },
  { '<leader>wf',       '<c-w>K',                               mode = { 'n', 'v', }, desc = 'my.window: be most left window', },
  { '<leader>wb',       '<c-w>L',                               mode = { 'n', 'v', }, desc = 'my.window: be most right window', },

  { '<leader>wn',       '<c-w>w',                               mode = { 'n', 'v', }, desc = 'my.window: go next window', },
  { '<leader>wg',       '<c-w>W',                               mode = { 'n', 'v', }, desc = 'my.window: go prev window', },

  { '<leader>w<left>',  ':<c-u>vsplit to<cr>',                  mode = { 'n', 'v', }, desc = 'my.window: split to up window', },
  { '<leader>w<down>',  ':<c-u>split  bo<cr>',                  mode = { 'n', 'v', }, desc = 'my.window: split to down window', },
  { '<leader>w<up>',    ':<c-u>split  to<cr>',                  mode = { 'n', 'v', }, desc = 'my.window: split to left window', },
  { '<leader>w<right>', ':<c-u>vsplit bo<cr>',                  mode = { 'n', 'v', }, desc = 'my.window: split to right window', },

  { '<leader>xh',       function() M.close_win_left() end,      mode = { 'n', 'v', }, desc = 'my.window: close_win_left', },
  { '<leader>xj',       function() M.close_win_down() end,      mode = { 'n', 'v', }, desc = 'my.window: close_win_down', },
  { '<leader>xk',       function() M.close_win_up() end,        mode = { 'n', 'v', }, desc = 'my.window: close_win_up', },
  { '<leader>xl',       function() M.close_win_right() end,     mode = { 'n', 'v', }, desc = 'my.window: close_win_right', },
  { '<leader>xt',       function() M.close_cur_tab() end,       mode = { 'n', 'v', }, desc = 'my.window: close_cur_tab', },

  { '<leader>xw',       function() M.Bwipeout_cur() end,        mode = { 'n', 'v', }, desc = 'my.window: Bwipeout_cur', },
  { '<leader>x<c-w>',   function() M.bwipeout_cur() end,        mode = { 'n', 'v', }, desc = 'my.window: bwipeout_cur', },
  { '<leader>xW',       function() M.bwipeout_cur() end,        mode = { 'n', 'v', }, desc = 'my.window: bwipeout_cur', },
  { '<leader>xd',       function() M.Bdelete_cur() end,         mode = { 'n', 'v', }, desc = 'my.window: Bdelete_cur', },
  { '<leader>x<c-d>',   function() M.bdelete_cur() end,         mode = { 'n', 'v', }, desc = 'my.window: bdelete_cur', },
  { '<leader>xD',       function() M.bdelete_cur() end,         mode = { 'n', 'v', }, desc = 'my.window: bdelete_cur', },

  { '<leader>xow',      function() M.Bwipeout_other() end,      mode = { 'n', 'v', }, desc = 'my.window: Bwipeout_other', },
  { '<leader>xo<c-w>',  function() M.bwipeout_other() end,      mode = { 'n', 'v', }, desc = 'my.window: bwipeout_other', },
  { '<leader>xoW',      function() M.bwipeout_other() end,      mode = { 'n', 'v', }, desc = 'my.window: bwipeout_other', },
  { '<leader>xod',      function() M.Bdelete_other() end,       mode = { 'n', 'v', }, desc = 'my.window: Bdelete_other', },
  { '<leader>xo<c-d>',  function() M.bdelete_other() end,       mode = { 'n', 'v', }, desc = 'my.window: bdelete_other', },
  { '<leader>xoD',      function() M.bdelete_other() end,       mode = { 'n', 'v', }, desc = 'my.window: bdelete_other', },

  { '<leader>xc',       function() M.close_cur() end,           mode = { 'n', 'v', }, desc = 'my.window: close_cur', },

  { '<leader>xp',       function() M.bdelete_cur_proj() end,    mode = { 'n', 'v', }, desc = 'my.window: bdelete_cur_proj', },
  { '<leader>x<c-p>',   function() M.bwipeout_cur_proj() end,   mode = { 'n', 'v', }, desc = 'my.window: bwipeout_cur_proj', },
  { '<leader>xP',       function() M.bwipeout_cur_proj() end,   mode = { 'n', 'v', }, desc = 'my.window: bwipeout_cur_proj', },

  { '<leader>xop',      function() M.bdelete_other_proj() end,  mode = { 'n', 'v', }, desc = 'my.window: bdelete_other_proj', },
  { '<leader>xo<c-p>',  function() M.bwipeout_other_proj() end, mode = { 'n', 'v', }, desc = 'my.window: bwipeout_other_proj', },
  { '<leader>xoP',      function() M.bwipeout_other_proj() end, mode = { 'n', 'v', }, desc = 'my.window: bwipeout_other_proj', },

  { '<leader>x<del>',   function() M.bwipeout_deleted() end,    mode = { 'n', 'v', }, desc = 'my.window: bwipeout_deleted', },
  { '<leader>x<cr>',    function() M.reopen_deleted() end,      mode = { 'n', 'v', }, desc = 'my.window: reopen_deleted', },
}

return M
