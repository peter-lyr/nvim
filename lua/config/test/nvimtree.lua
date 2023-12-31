local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

M.run_what_list = {
  '"Adobe Audition.exe"',
  '"wmplayer.exe"',
  '"notepad.exe"',
  'cmd /c start ""',
}

M.run_whats_list = {
  '"bcomp.exe"',
  '"BCompare.exe"',
}

M._run_what_dict = {}

function M._wrap_run_what(exe)
  return function(file)
    B.system_run('start silent', '%s \"%s\"', exe, file)
  end
end

for _, exe in ipairs(M.run_what_list) do
  M._run_what_dict[exe] = M._wrap_run_what(exe)
end

function M._run_what(what)
  local node = require 'nvim-tree.lib'.get_node_at_cursor()
  local file = node.absolute_path
  local run_what_keys = vim.tbl_keys(M._run_what_dict)
  if what then
    if B.is_in_tbl(what, run_what_keys) then
      M._run_what_dict[what](file)
    else
      B.notify_info(what .. ' is not in run_what_list')
    end
    return
  end
  if #run_what_keys == 0 then
  elseif #run_what_keys == 1 then
    M._run_what_dict[run_what_keys[1]](file)
  else
    B.ui_sel(run_what_keys, 'run_what with ' .. file, function(run_what)
      if run_what then
        M._run_what_dict[run_what](file)
      end
    end)
  end
end

function M._run_what_add_do(what)
  M._run_what_dict[what] = M._wrap_run_what(what)
  M._run_what(what)
end

function M._run_what_add()
  local run_what_keys = vim.tbl_keys(M._run_what_dict)
  table.insert(run_what_keys, 1, '_run_what_add')
  B.notify_info(run_what_keys)
  local what = vim.fn.input 'Add new: '
  if B.is(what) then
    M._run_what_add_do(what)
  end
end

-----

M._run_whats_dict = {}

function M._wrap_run_whats(exe)
  return function(files)
    B.system_run('start silent', '%s \"%s\"', exe, vim.fn.join(files, '\" \"'))
  end
end

for _, exe in ipairs(M.run_whats_list) do
  M._run_whats_dict[exe] = M._wrap_run_whats(exe)
end

function M._run_whats(what)
  local files = {}
  local marks = require 'nvim-tree.marks'.get_marks()
  for _, v in ipairs(marks) do
    local absolute_path = v.absolute_path:match '^(.-)\\*$'
    files[#files + 1] = absolute_path
  end
  if #files == 0 then
    return
  end
  require 'nvim-tree.marks'.clear_marks()
  require 'nvim-tree.api'.tree.reload()
  local run_whats_keys = vim.tbl_keys(M._run_whats_dict)
  if what then
    if B.is_in_tbl(what, run_whats_keys) then
      M._run_whats_dict[what](files)
    else
      B.notify_info(what .. ' is not in run_whats_list')
    end
    return
  end
  if #run_whats_keys == 0 then
  elseif #run_whats_keys == 1 then
    M._run_whats_dict[run_whats_keys[1]](files)
  else
    B.ui_sel(run_whats_keys, string.format('run whats with %d files', #files), function(run_whats)
      if run_whats then
        M._run_whats_dict[run_whats](files)
      end
    end)
  end
end

function M._run_whats_add_do(what)
  M._run_whats_dict[what] = M._wrap_run_whats(what)
  M._run_whats(what)
end

function M._run_whats_add()
  local run_whats_keys = vim.tbl_keys(M._run_whats_dict)
  table.insert(run_whats_keys, 1, '_run_whats_add')
  B.notify_info(run_whats_keys)
  local what = vim.fn.input 'Add new: '
  if B.is(what) then
    M._run_whats_add_do(what)
  end
end

---------------------------------------

vim.cmd [[
  hi NvimTreeOpenedFile guibg=#238789
  hi NvimTreeModifiedFile guibg=#87237f
  hi NvimTreeSpecialFile guifg=brown gui=bold,underline
]]

function M._tab()
  local api = require 'nvim-tree.api'
  api.node.open.preview()
  vim.cmd 'norm j'
end

function M._s_tab()
  local api = require 'nvim-tree.api'
  api.node.open.preview()
  vim.cmd 'norm k'
end

function M._close() vim.cmd 'NvimTreeClose' end

function M._system_run_and_close()
  require 'nvim-tree.api'.node.run.system()
  M._close()
end

function M._delete(node)
  B.cmd('Bdelete %s', node.absolute_path)
  require 'config.my.tabline'.update_bufs_and_refresh_tabline()
  vim.cmd 'norm j'
end

M.ausize_en = 1

function M._ausize_toggle()
  M.ausize_en = 1 - M.ausize_en
  print('ausize_en:', M.ausize_en)
end

---------------------------------------

B.aucmd({ 'BufEnter', 'DirChanged', 'CursorHold', }, 'test.nvimtree.BufEnter', {
  callback = function(ev)
    if vim.bo.ft == 'NvimTree' and B.is(M.ausize_en) then
      local winid = vim.fn.win_getid(vim.fn.bufwinnr(ev.buf))
      vim.fn.timer_start(10, function()
        if B.is_buf_fts('NvimTree', ev.buf) then
          local max = 0
          local min_nr = vim.fn.line 'w0'
          if min_nr == 1 then
            min_nr = 2
          end
          local max_nr = vim.fn.line 'w$'
          for line = min_nr, max_nr do
            local cnt = vim.fn.strdisplaywidth(vim.fn.getline(line))
            if max < cnt then
              max = cnt
            end
          end
          if max + 1 + 1 + #tostring(vim.fn.line 'w$') + 1 + 2 > require 'nvim-tree.view'.View.width then
            vim.api.nvim_win_set_width(winid, max + 5 + #tostring(vim.fn.line '$'))
          end
        end
      end)
    end
  end,
})

function M._toggle_sel(node)
  require 'nvim-tree.marks'.toggle_mark(node)
  local marks = require 'nvim-tree.marks'.get_marks()
  print('selected', #marks, 'items.')
  vim.cmd 'norm j'
end

function M._toggle_sel_up(node)
  require 'nvim-tree.marks'.toggle_mark(node)
  local marks = require 'nvim-tree.marks'.get_marks()
  print('selected', #marks, 'items.')
  vim.cmd 'norm k'
end

function M._empty_sel()
  require 'nvim-tree.marks'.clear_marks()
  require 'nvim-tree.api'.tree.reload()
  print 'empty selected.'
end

function M._delete_sel()
  local marks = require 'nvim-tree.marks'.get_marks()
  local res = vim.fn.input('Confirm deletion ' .. #marks .. ' [N/y] ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    for _, v in ipairs(marks) do
      local absolute_path = v['absolute_path']
      absolute_path = absolute_path:match '^(.-)\\*$'
      local path = require 'plenary.path':new(absolute_path)
      if path:is_dir() then
        local entries = require 'plenary.scandir'.scan_dir(absolute_path, { hidden = true, depth = 10, add_dirs = false, })
        for _, entry in ipairs(entries) do
          pcall(vim.cmd, 'bw! ' .. entry)
          B.delete_file(entry)
        end
        B.delete_folder(absolute_path)
      else
        pcall(vim.cmd, 'bw! ' .. absolute_path)
        B.delete_file(absolute_path)
      end
    end
    require 'nvim-tree.marks'.clear_marks()
    require 'nvim-tree.api'.tree.reload()
  else
    print 'canceled!'
  end
end

function M._get_dtarget(node)
  if node.name == '..' then
    return vim.fn.trim(B.rep_slash(vim.loop.cwd()), '\\')
  end
  if node.type == 'directory' then
    return vim.fn.trim(B.rep_slash(node.absolute_path), '\\')
  end
  if node.type == 'file' then
    return vim.fn.trim(B.rep_slash(node.parent.absolute_path), '\\')
  end
  return nil
end

function M._move_sel(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  local marks = require 'nvim-tree.marks'.get_marks()
  local res = vim.fn.input(dtarget .. '\nConfirm movment ' .. #marks .. ' [N/y] ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    for _, v in ipairs(marks) do
      local absolute_path = v['absolute_path']
      if require 'plenary.path':new(absolute_path):is_dir() then
        local dname = B.get_fname_tail(absolute_path)
        dname = string.format('%s\\%s', dtarget, dname)
        if require 'plenary.path':new(dname):exists() then
          vim.cmd 'redraw'
          local dname_new = vim.fn.input(absolute_path .. ' ->\nExisted! Rename? ', dname)
          if #dname_new > 0 and dname_new ~= dname then
            vim.fn.system(string.format('move "%s" "%s"', absolute_path, dname_new))
          elseif #dname_new == 0 then
            print 'cancel all!'
            return
          else
            vim.cmd 'redraw'
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          vim.fn.system(string.format('move "%s" "%s"', absolute_path, dname))
        end
      else
        local fname = B.get_fname_tail(absolute_path)
        fname = string.format('%s\\%s', dtarget, fname)
        if require 'plenary.path':new(fname):exists() then
          vim.cmd 'redraw'
          local fname_new = vim.fn.input(absolute_path .. ' ->\nExisted! Rename? ', fname)
          if #fname_new > 0 and fname_new ~= fname then
            vim.fn.system(string.format('move "%s" "%s"', absolute_path, fname_new))
          elseif #fname_new == 0 then
            print 'cancel all!'
            return
          else
            vim.cmd 'redraw'
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          vim.fn.system(string.format('move "%s" "%s"', absolute_path, fname))
        end
      end
      pcall(vim.cmd, 'bw! ' .. B.rep_slash_lower(absolute_path))
      ::continue::
    end
    require 'nvim-tree.marks'.clear_marks()
    require 'nvim-tree.api'.tree.reload()
  else
    print 'canceled!'
  end
end

function M._copy_sel(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  local marks = require 'nvim-tree.marks'.get_marks()
  local res = vim.fn.input(dtarget .. '\nConfirm copy ' .. #marks .. ' [N/y] ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    for _, v in ipairs(marks) do
      local absolute_path = v['absolute_path']
      if require 'plenary.path':new(absolute_path):is_dir() then
        local dname = B.get_fname_tail(absolute_path)
        dname = string.format('%s\\%s', dtarget, dname)
        if require 'plenary.path':new(dname):exists() then
          vim.cmd 'redraw'
          local dname_new = vim.fn.input(absolute_path .. ' ->\nExisted! Rename? ', dname)
          if #dname_new > 0 and dname_new ~= dname then
            if string.sub(dname_new, #dname_new, #dname_new) ~= '\\' then
              dname_new = dname_new .. '\\'
            end
            vim.fn.system(string.format('xcopy "%s" "%s" /s /e /f', absolute_path, dname_new))
          elseif #dname_new == 0 then
            print 'cancel all!'
            return
          else
            vim.cmd 'redraw'
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          if string.sub(dname, #dname, #dname) ~= '\\' then
            dname = dname .. '\\'
          end
          vim.fn.system(string.format('xcopy "%s" "%s" /s /e /f', absolute_path, dname))
        end
      else
        local fname = B.get_fname_tail(absolute_path)
        fname = string.format('%s\\%s', dtarget, fname)
        if require 'plenary.path':new(fname):exists() then
          vim.cmd 'redraw'
          local fname_new = vim.fn.input(absolute_path .. '\n ->Existed! Rename? ', fname)
          if #fname_new > 0 and fname_new ~= fname then
            vim.fn.system(string.format('copy "%s" "%s"', absolute_path, fname_new))
          elseif #fname_new == 0 then
            print 'cancel all!'
            return
          else
            vim.cmd 'redraw'
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          vim.fn.system(string.format('copy "%s" "%s"', absolute_path, fname))
        end
      end
      ::continue::
    end
    require 'nvim-tree.marks'.clear_marks()
    require 'nvim-tree.api'.tree.reload()
  else
    print 'canceled!'
  end
end

function M._copy_dtarget(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  vim.fn.setreg('+', dtarget)
  B.print('Copied %s to system clipboard!', dtarget)
end

---------------------------------

function M.open(dir)
  vim.cmd 'NvimTreeOpen'
  B.set_timeout(20, function() B.cmd('cd %s', dir) end)
end

function M._sel_dirs_do(dirs, prompt)
  B.ui_sel(dirs, prompt, function(dir) if dir then M.open(dir) end end)
  B.set_timeout(20, function() vim.cmd [[call feedkeys("\<esc>")]] end)
end

function M.sel_dirvers()
  local drivers = {}
  for i = 1, 26 do
    local driver = vim.fn.nr2char(64 + i) .. ':\\'
    if B.is(vim.fn.isdirectory(driver)) then drivers[#drivers + 1] = driver end
  end
  M._sel_dirs_do(drivers, 'drivers')
end

function M.sel_parent_dirs() M._sel_dirs_do(B.get_file_dirs(vim.loop.cwd()), 'parent_dirs') end

function M.sel_my_dirs() M._sel_dirs_do(B.get_my_dirs(), 'my_dirs') end

function M.sel_SHGetFolderPath() M._sel_dirs_do(B.get_SHGetFolderPath(), 'SHGetFolderPath') end

function M.sel_all_git_repos() M._sel_dirs_do(require 'config.my.git'.get_all_git_repos(), 'all_git_repos') end

function M.last_dir() if B.is(M._last_dir) then M.open(M._last_dir) end end

B.aucmd({ 'CursorHold', 'CursorHoldI', }, 'test.nvimtree.CursorHold', {
  callback = function(ev)
    if B.is_buf_fts('NvimTree', ev.buf) then
      M._last_dir = vim.loop.cwd()
    end
  end,
})

---------

M.nvimtree_dir = B.getcreate_dir(M.source .. '.exe')

M.copy2clip_exe = B.get_filepath(M.nvimtree_dir, 'copy2clip.exe').filename

M._copy_2_clip = function()
  local marks = require 'nvim-tree.marks'.get_marks()
  local files = ''
  for _, v in ipairs(marks) do
    files = files .. ' ' .. '"' .. v.absolute_path .. '"'
  end
  B.system_run('start silent', '%s%s', M.copy2clip_exe, files)
  require 'nvim-tree.marks'.clear_marks()
  require 'nvim-tree.api'.tree.reload()
end

M._paste_from_clip = function(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  B.powershell_run('Get-Clipboard -Format FileDropList | ForEach-Object { Copy-Item -Path $_.FullName -Destination "%s" }', dtarget)
end

-----------------------------------

-- M._change_root = function(path, bufnr)
-- end
--
-- require 'nvim-tree'.change_root = M._change_root

function M._wrap_node(fn)
  return function(node, ...)
    node = node or require 'nvim-tree.lib'.get_node_at_cursor()
    fn(node, ...)
  end
end

-----------------------------------------------------
-- setup
-----------------------------------------------------

function M._reopen()
  package.loaded[M.lua] = nil
  require 'config.test.nvimtree'
  print 'config.test.nvimtree'
end

local opts = {
  update_focused_file = {
    -- enable = true,
    update_root = false,
  },
  git = {
    enable = true,
  },
  view = {
    width = 30,
    number = true,
    relativenumber = true,
  },
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = { '*.git*', },
  },
  filters = {
    -- dotfiles = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  modified = {
    enable = true,
    show_on_dirs = false,
    show_on_open_dirs = false,
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = 'name',
    highlight_modified = 'name',
    special_files = { 'README.md', 'readme.md', },
    indent_markers = {
      enable = true,
    },
  },
  actions = {
    open_file = {
      window_picker = {
        chars = 'ASDFQWERJKLHNMYUIOPZXCVGTB1234789056',
        exclude = {
          filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame', 'minimap', 'aerial', },
          buftype = { 'nofile', 'terminal', 'help', },
        },
      },
    },
  },
}

function M.fd(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  B.cmd('Telescope find_files cwd=%s previewer=true', dtarget .. '\\\\')
end

function M.rg(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  B.cmd('Telescope live_grep cwd=%s previewer=true', dtarget .. '\\\\')
end

function M._on_attach(bufnr)
  local api = require 'nvim-tree.api'
  B.lazy_map {
    { 'gd',            M._wrap_node(M._delete),            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: delete buf', },

    { '<c-f>',         api.node.show_info_popup,           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Info', },
    { 'dk',            api.node.open.tab,                  mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open: New Tab', },
    { 'dl',            api.node.open.vertical,             mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open: Vertical Split', },
    { 'dj',            api.node.open.horizontal,           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open: Horizontal Split', },
    { 'a',             api.node.open.edit,                 mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open', },

    { '<Tab>',         M._tab,                             mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open Preview', },
    { '<S-Tab>',       M._s_tab,                           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open Preview', },

    { '<2-LeftMouse>', api.node.open.no_window_picker,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open', },
    { '<CR>',          api.node.open.no_window_picker,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open: No Window Picker', },
    { 'o',             api.node.open.no_window_picker,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open: No Window Picker', },
    { 'do',            api.node.open.no_window_picker,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open: No Window Picker', },

    { 'c',             api.fs.create,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Create', },
    { 'D',             api.fs.remove,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Delete', },
    { 'C',             api.fs.copy.node,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Copy', },
    { 'X',             api.fs.cut,                         mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Cut', },
    { 'p',             api.fs.paste,                       mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Paste', },

    { 'gr',            api.fs.rename_sub,                  mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Rename: Omit Filename', },
    { 'R',             api.fs.rename,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Rename', },
    { 'r',             api.fs.rename_basename,             mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Rename: Basename', },

    { 'gy',            api.fs.copy.absolute_path,          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Copy Absolute Path', },
    { 'Y',             api.fs.copy.relative_path,          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Copy Relative Path', },
    { 'y',             api.fs.copy.filename,               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Copy Name', },
    { '<c-s-y>',       M._wrap_node(M._copy_dtarget),      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _copy_dtarget', },

    { 'vo',            api.tree.change_root_to_node,       mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: CD', },
    { 'u',             api.tree.change_root_to_parent,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Up', },

    { 'gb',            api.tree.toggle_no_buffer_filter,   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Toggle No Buffer', },
    { 'g.',            api.tree.toggle_git_clean_filter,   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Toggle Git Clean', },
    { '?',             api.tree.toggle_help,               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Help', },
    { '.',             api.tree.toggle_hidden_filter,      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Toggle Dotfiles', },
    { 'i',             api.tree.toggle_gitignore_filter,   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Toggle Git Ignore', },

    { '<c-r>',         api.tree.reload,                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Refresh', },
    { 'E',             api.tree.expand_all,                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Expand All', },
    { 'W',             api.tree.collapse_all,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Collapse', },
    { 'q',             M._close,                           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Close', },
    { '<c-q>',         M._close,                           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Close', },

    { '<leader>k',     api.node.navigate.git.prev,         mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Prev Git', },
    { '<leader>j',     api.node.navigate.git.next,         mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Next Git', },
    { '<leader>m',     api.node.navigate.diagnostics.next, mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Next Diagnostic', },
    { '<leader>n',     api.node.navigate.diagnostics.prev, mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Prev Diagnostic', },
    { '<c-i>',         api.node.navigate.opened.prev,      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Prev Opened', },
    { '<c-o>',         api.node.navigate.opened.next,      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Next Opened', },

    { '<a-m>',         api.node.navigate.sibling.next,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Next Sibling', },
    { '<a-n>',         api.node.navigate.sibling.prev,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Previous Sibling', },
    { '<c-m>',         api.node.navigate.sibling.last,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Last Sibling', },
    { '<c-n>',         api.node.navigate.sibling.first,    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: First Sibling', },

    { '<c-h>',         api.node.navigate.parent,           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Parent Directory', },
    { '<c-u>',         api.node.navigate.parent_close,     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Close Directory', },

    { 'x',             api.node.run.system,                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run System', },
    -- { '<MiddleMouse>', api.node.run.system,                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run System', },
    { '<c-x>',         M._system_run_and_close,            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run System', },
    { 'gx',            api.node.run.cmd,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run Command', },

    { 'f',             api.live_filter.start,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Filter', },
    { 'gf',            api.live_filter.clear,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Clean Filter', },

    ----------

    { "'",             M._wrap_node(M._toggle_sel),        mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: toggle and go next', },
    { '"',             M._wrap_node(M._toggle_sel_up),     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: toggle and go prev', },
    { 'de',            M._empty_sel,                       mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: empty all selections', },
    { 'dd',            M._delete_sel,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: delete all selections', },
    { 'dm',            M._wrap_node(M._move_sel),          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: move all selections', },
    { 'dc',            M._wrap_node(M._copy_sel),          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: copy all selections', },

    { 'dy',            M._wrap_node(M._copy_2_clip),       mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _copy_2_clip', },
    { 'dp',            M._wrap_node(M._paste_from_clip),   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _paste_from_clip', },

    { 'da',            M._ausize_toggle,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _ausize_toggle', },

  }

  B.lazy_map {
    { '<c-1>',         M._run_what,                                 mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _run_what', },
    { '<MiddleMouse>', M._run_what,                                 mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _run_what', },
    { '<c-2>',         M._run_whats,                                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _run_whats', },
    { '<RightMouse>',  M._run_whats,                                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _run_whats', },
    { '<c-3>',         function() M._run_what '"wmplayer.exe"' end, mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: wmplayer', },
    { '<c-4>',         function() M._run_whats '"bcomp.exe"' end,   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: bcomp', },
    { '<f1>',          M._wrap_node(M.rg),                          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: rg', },
    { '<f2>',          M._wrap_node(M.fd),                          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: fd', },
    { '<f3>',          function() M._run_what_add() end,            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _run_what_add', },
    { '<f4>',          function() M._run_whats_add() end,           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: _run_whats_add', },
  }
end

B.lazy_map {
  { '<a-s-cr>', M._reopen, mode = { 'n', }, silent = true, desc = 'test.nvim: _reopen', },
}

B.del_map({ 'n', 'v', }, '<RightMouse>')

vim.cmd [[
  anoremenu PopUp.-2-              <Nop>
  nnoremenu PopUp.NvimTree\ Toggle :NvimTreeToggle<cr>
  vnoremenu PopUp.NvimTree\ Toggle :<C-U>NvimTreeToggle<cr>
  inoremenu PopUp.NvimTree\ Toggle <C-O>:<C-u>NvimTreeToggle<cr>
]]

opts['on_attach'] = M._on_attach

require 'nvim-tree'.setup(opts)

return M
