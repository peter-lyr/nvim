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
    B.histadd_en = 1
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
  table.sort(run_what_keys)
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
    B.histadd_en = 1
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

function M.refresh_hl()
  vim.cmd [[
    hi NvimTreeOpenedFile guibg=#238789
    hi NvimTreeModifiedFile guibg=#87237f
    hi NvimTreeSpecialFile guifg=brown gui=bold,underline
  ]]
end

M.refresh_hl()

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

function M._explorer_dtarget(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  B.system_run('start silent', 'start "" "%s"', dtarget)
end

function M._delete(node)
  if node.type == 'directory' then
    local files = B.scan_files(node.absolute_path)
    for _, file in ipairs(files) do
      if vim.api.nvim_buf_is_loaded(vim.fn.bufnr(file)) == true then
        B.print('Bdelete %s', file)
        B.cmd('Bdelete %s', file)
      end
    end
  end
  if node.type == 'file' then
    B.cmd('Bdelete %s', node.absolute_path)
  end
  require 'config.my.tabline'.update_bufs_and_refresh_tabline()
  vim.cmd 'norm j'
end

function M.cur_root_sel(node)
  local dtarget = M._get_dtarget(node)
  if not dtarget then
    return
  end
  require 'config.nvim.telescope'.cur_root_sel_do(dtarget)
end

M.ausize_en = 1

---------------------------------------

function M.ausize_do(winid)
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
    vim.api.nvim_win_set_width(winid, max + 2 + #tostring(vim.fn.line '$'))
  end
end

function M.ausize_toggle()
  M.ausize_en = 1 - M.ausize_en
  print('ausize_en:', M.ausize_en)
  if M.ausize_en == 0 then
    if B.is_buf_fts('NvimTree', vim.fn.bufnr()) then
      vim.api.nvim_win_set_width(0, require 'nvim-tree.view'.View.width)
    else
      for winnr = 1, vim.fn.winnr '$' do
        if B.is_buf_fts('NvimTree', vim.fn.winbufnr(winnr)) then
          vim.api.nvim_win_set_width(vim.fn.win_getid(winnr), require 'nvim-tree.view'.View.width)
        end
      end
    end
  else
    if B.is_buf_fts('NvimTree', vim.fn.bufnr()) then
      M.ausize_do(vim.fn.win_getid())
    else
      local old_winid = vim.fn.win_getid()
      local nvt_winid = nil
      for winnr = 1, vim.fn.winnr '$' do
        if B.is_buf_fts('NvimTree', vim.fn.winbufnr(winnr)) then
          nvt_winid = vim.fn.win_getid(winnr)
          vim.fn.win_gotoid(nvt_winid)
          break
        end
      end
      if nvt_winid then
        M.ausize_do(nvt_winid)
        vim.fn.win_gotoid(old_winid)
      end
    end
  end
end

if not M.dirs then
  M.dirs = {}
end

function M.dirs_append(dir)
  B.stack_item_uniq(M.dirs, B.rep_slash_lower(dir))
end

B.aucmd({ 'BufEnter', 'DirChanged', 'CursorHold', }, 'nvimtree.BufEnter', {
  callback = function(ev)
    if vim.bo.ft == 'NvimTree' and B.is(M.ausize_en) then
      local winid = vim.fn.win_getid(vim.fn.bufwinnr(ev.buf))
      vim.fn.timer_start(10, function()
        if B.is_buf_fts('NvimTree', ev.buf) then
          M.ausize_do(winid)
        end
      end)
    end
    if vim.bo.ft == 'NvimTree' then
      vim.cmd 'set nowinfixheight'
    end
    if ev.event == 'DirChanged' then
      M.dirs_append(vim.loop.cwd())
    end
  end,
})

function M.sel_dirs() M._sel_dirs_do(M.dirs, 'dirs') end

function M.is_nvim_tree_opened()
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    if B.is_buf_fts('NvimTree', bufnr) then
      return 1
    end
  end
  return nil
end

B.aucmd({ 'TabEnter', }, 'nvimtree.TabEnter', {
  callback = function()
    local cur_nvim_tree = nil
    if B.is_buf_fts 'NvimTree' then
      cur_nvim_tree = 1
    end
    if M.is_nvim_tree_opened() then
      vim.cmd 'NvimTreeClose'
      B.set_timeout(10, function()
        vim.cmd 'NvimTreeFindFile'
        if not cur_nvim_tree then
          vim.cmd 'wincmd p'
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
  if B.is_sure('Confirm deletion %d', #marks) then
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
  if B.is_sure('%s\nConfirm movment %d', dtarget, #marks) then
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
  if B.is_sure('%s\nConfirm copy %d', dtarget, #marks) then
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
  dir = B.rep_backslash_lower(dir)
  vim.cmd 'NvimTreeOpen'
  require 'nvim-tree'.change_dir(dir)
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

function M.toggle()
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype') == 'NvimTree' then
    vim.api.nvim_win_set_width(0, 0)
    vim.cmd 'wincmd p'
    vim.cmd 'wincmd >'
    return
  end
  local opened = nil
  for winnr = 1, vim.fn.winnr '$' do
    if vim.api.nvim_buf_get_option(vim.fn.winbufnr(winnr), 'filetype') == 'NvimTree' then
      local winid = vim.fn.win_getid(winnr)
      vim.fn.win_gotoid(winid)
      vim.api.nvim_win_set_width(winid, require 'nvim-tree.view'.View.width)
      opened = 1
      break
    end
  end
  if not opened then
    vim.cmd 'NvimTreeOpen'
  end
end

B.aucmd({ 'CursorHold', 'CursorHoldI', }, 'nvimtree.CursorHold', {
  callback = function(ev)
    if B.is_buf_fts('NvimTree', ev.buf) then
      M._last_dir = vim.loop.cwd()
    end
  end,
})

-----------

function M.open_next_tree_node()
  vim.cmd 'NvimTreeFindFile'
  vim.cmd 'norm j'
  vim.cmd [[call feedkeys("\<cr>")]]
end

function M.open_prev_tree_node()
  vim.cmd 'NvimTreeFindFile'
  vim.cmd 'norm k'
  vim.cmd [[call feedkeys("\<cr>")]]
end

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
  B.powershell_run('Get-Clipboard -Format FileDropList | ForEach-Object { Copy-Item -Path $_.FullName -Recurse -Destination "%s" }', dtarget)
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

function M._open_or_expand_or_dir_up()
  return function(node)
    if node.name == '..' then
      require 'nvim-tree.actions.root.change-dir'.fn '..'
    elseif node.nodes then
      require 'nvim-tree.lib'.expand_or_collapse(node)
    else
      local path = node.absolute_path
      if node.link_to and not node.nodes then
        path = node.link_to
      end
      local winid = B.find_its_place_to_open(path)
      if winid then
        vim.fn.win_gotoid(winid)
        B.cmd('e %s', path)
      else
        require 'nvim-tree.actions.node.open-file'.fn('edit_no_picker', path)
      end
    end
  end
end

-----------------------------------------------------
-- setup
-----------------------------------------------------

function M.reset_nvimtree()
  package.loaded[M.lua] = nil
  require 'config.nvim.nvimtree'
  B.echo 'reset_nvimtree: config.nvim.nvimtree'
end

local opts = {
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  git = {
    enable = true,
  },
  view = {
    width = 30,
    -- number = true,
    -- relativenumber = true,
    signcolumn = 'auto',
  },
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  filesystem_watchers = {
    enable = false,
    -- debounce_delay = 50,
    -- ignore_dirs = { '*.git*', },
  },
  filters = {
    dotfiles = true,
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
    indent_width = 1,
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

function M.decrypt(node)
  B.cmd('CryptDe %s', node.absolute_path)
end

function M.encrypt(node)
  B.cmd('CryptEn %s', node.absolute_path)
end

function M.git_add_force(node)
  B.system_run('start silent', 'git add -f %s', node.absolute_path)
  B.set_timeout(100, function()
    require 'nvim-tree.api'.tree.reload()
  end)
end

function M.git_rm_cached(node)
  B.system_run('start silent', 'git rm --cached %s', node.absolute_path)
  B.set_timeout(100, function()
    require 'nvim-tree.api'.tree.reload()
  end)
end

function M.cur_root_do()
  local cwd = B.rep_backslash_lower(vim.loop.cwd())
  if not M.cur_root_sta then
    M.cur_root_sta = {}
  end
  if not M.cur_root_sta[cwd] then
    M.cur_root_sta[cwd] = 0
  end
  if M.cur_root_sta[cwd] == 1 then
    local cur_root = require 'config.nvim.telescope'.cur_root[B.rep_backslash_lower(cwd)]
    if B.is(cur_root) then
      cwd = cur_root
    end
  end
  require 'nvim-tree'.change_dir(cwd)
  M.dirs_append(cwd)
end

function M.toggle_cur_root()
  local cwd = B.rep_backslash_lower(vim.loop.cwd())
  if not M.cur_root_sta then
    M.cur_root_sta = {}
  end
  if not M.cur_root_sta[cwd] then
    M.cur_root_sta[cwd] = 0
  end
  M.cur_root_sta[cwd] = 1 - M.cur_root_sta[cwd]
  M.cur_root_do()
end

B.aucmd('DirChanged', 'nvimtree.DirChanged', {
  callback = function()
    B.set_timeout(30, function()
      M.cur_root_do()
    end)
  end,
})

function M._on_attach(bufnr)
  local api = require 'nvim-tree.api'
  B.lazy_map {
    { 'gf',            api.node.show_info_popup,                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Info', },
    { 'dk',            api.node.open.tab,                           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: New Tab', },
    { 'dl',            api.node.open.vertical,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: Vertical Split', },
    { 'dj',            api.node.open.horizontal,                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: Horizontal Split', },
    { 'a',             api.node.open.edit,                          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open', },

    { '<Tab>',         M._tab,                                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open Preview', },
    { '<S-Tab>',       M._s_tab,                                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open Preview', },

    { '<2-LeftMouse>', M._wrap_node(M._open_or_expand_or_dir_up()), mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: No Window Picker', },
    { '<CR>',          M._wrap_node(M._open_or_expand_or_dir_up()), mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: No Window Picker', },
    { 'o',             M._wrap_node(M._open_or_expand_or_dir_up()), mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: No Window Picker', },
    { 'do',            M._wrap_node(M._open_or_expand_or_dir_up()), mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Open: No Window Picker', },

    { 'c',             api.fs.create,                               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Create', },
    -- { 'D',             api.fs.remove,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Delete', },
    -- { 'C',             api.fs.copy.node,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Copy', },
    -- { 'X',             api.fs.cut,                         mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Cut', },
    -- { 'p',             api.fs.paste,                       mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Paste', },

    -- { 'gr',            api.fs.rename_sub,                  mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Rename: Omit Filename', },
    { 'R',             api.fs.rename,                               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Rename', },
    { 'r',             api.fs.rename_basename,                      mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Rename: Basename', },

    { 'gy',            api.fs.copy.absolute_path,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Copy Absolute Path', },
    { 'Y',             api.fs.copy.relative_path,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Copy Relative Path', },
    { 'y',             api.fs.copy.filename,                        mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Copy Name', },
    { '<a-y>',         M._wrap_node(M._copy_dtarget),               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _copy_dtarget', },

    { 'vo',            api.tree.change_root_to_node,                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: CD', },
    { 'u',             api.tree.change_root_to_parent,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Up', },

    -- { 'gb',            api.tree.toggle_no_buffer_filter,   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Toggle No Buffer', },
    { 'g.',            api.tree.toggle_git_clean_filter,            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Toggle Git Clean', },
    { '?',             api.tree.toggle_help,                        mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Help', },
    { '.',             api.tree.toggle_hidden_filter,               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Toggle Dotfiles', },
    { 'i',             api.tree.toggle_gitignore_filter,            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Toggle Git Ignore', },

    { '<F5>',          api.tree.reload,                             mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Refresh', },
    { 'E',             api.tree.expand_all,                         mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Expand All', },
    { 'W',             api.tree.collapse_all,                       mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Collapse', },
    { 'q',             M._close,                                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Close', },
    { '<c-q>',         M._close,                                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Close', },

    { '<leader>k',     api.node.navigate.git.prev,                  mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Prev Git', },
    { '<leader>j',     api.node.navigate.git.next,                  mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Next Git', },
    { '<leader>m',     api.node.navigate.diagnostics.next,          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Next Diagnostic', },
    { '<leader>n',     api.node.navigate.diagnostics.prev,          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Prev Diagnostic', },
    { '<c-i>',         api.node.navigate.opened.prev,               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Prev Opened', },
    { '<c-o>',         api.node.navigate.opened.next,               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Next Opened', },

    { '<c-b>',         api.node.navigate.sibling.next,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Next Sibling', },
    { '<c-v>',         api.node.navigate.sibling.prev,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Previous Sibling', },
    { '<c-m>',         api.node.navigate.sibling.last,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Last Sibling', },
    { '<c-n>',         api.node.navigate.sibling.first,             mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: First Sibling', },

    { '<c-h>',         api.node.navigate.parent,                    mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Parent Directory', },
    { '<c-u>',         api.node.navigate.parent_close,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Close Directory', },

    { 'x',             api.node.run.system,                         mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Run System', },
    { 'gx',            M._wrap_node(M._explorer_dtarget),           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: explorer dtarget', },
    -- { '<MiddleMouse>', api.node.run.system,                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Run System', },
    { '<c-x>',         M._system_run_and_close,                     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Run System', },
    { '!',             api.node.run.cmd,                            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Run Command', },

    -- { 'f',             api.live_filter.start,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Filter', },
    -- { 'gf',            api.live_filter.clear,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: Clean Filter', },

    ----------

    { "'",             M._wrap_node(M._toggle_sel),                 mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: toggle and go next', },
    { '"',             M._wrap_node(M._toggle_sel_up),              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: toggle and go prev', },
    { 'de',            M._empty_sel,                                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: empty all selections', },
    { 'dd',            M._delete_sel,                               mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: delete all selections', },
    { 'dm',            M._wrap_node(M._move_sel),                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: move all selections', },
    { 'dc',            M._wrap_node(M._copy_sel),                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: copy all selections', },

    { 'dy',            M._wrap_node(M._copy_2_clip),                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _copy_2_clip', },
    { 'dp',            M._wrap_node(M._paste_from_clip),            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _paste_from_clip', },

    { 'da',            M.ausize_toggle,                             mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: ausize_toggle', },

    { 'd;',            M._wrap_node(M._delete),                     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: delete buf', },

    { 'dr',            M._wrap_node(M.cur_root_sel),                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: delete buf', },
  }

  B.lazy_map {
    { { 'pw', '<MiddleMouse>', }, M._run_what,                                 mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _run_what', },
    { { 'ps', '<RightMouse>', },  M._run_whats,                                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _run_whats', },
    { 'pp',                       function() M._run_what '"wmplayer.exe"' end, mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: wmplayer', },
    { 'pb',                       function() M._run_whats '"bcomp.exe"' end,   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: bcomp', },
    { 'pr',                       M._wrap_node(M.rg),                          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: rg', },
    { 'pf',                       M._wrap_node(M.fd),                          mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: fd', },
    { 'p<c-w>',                   function() M._run_what_add() end,            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _run_what_add', },
    { 'p<c-s>',                   function() M._run_whats_add() end,           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: _run_whats_add', },

    { 'pc',                       M._wrap_node(M.decrypt),                     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: decrypt', },
    { 'pd',                       M._wrap_node(M.encrypt),                     mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: encrypt', },
  }

  B.lazy_map {
    { 'ga', M._wrap_node(M.git_add_force), mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: git_add_force', },
    { 'gd', M._wrap_node(M.git_rm_cached), mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'nvimtree: git_rm_cached', },
  }
  vim.cmd [[call feedkeys("d\<esc>")]]
end

vim.cmd [[
  anoremenu PopUp.-2-              <Nop>
  nnoremenu PopUp.NvimTree\ Toggle :NvimTreeToggle<cr>
  vnoremenu PopUp.NvimTree\ Toggle :<C-U>NvimTreeToggle<cr>
  inoremenu PopUp.NvimTree\ Toggle <C-O>:<C-u>NvimTreeToggle<cr>
]]

opts['on_attach'] = M._on_attach

require 'nvim-tree'.setup(opts)

function M.open_all()
  local cur_bufnr = vim.fn.bufnr()
  local roots = {}
  vim.cmd 'NvimTreeClose'
  vim.cmd 'NvimTreeOpen'
  vim.cmd 'wincmd p'
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(bufnr))
    if B.is(fname) and B.is_file(fname) then
      local root = B.rep_slash_lower(vim.fn['ProjectRootGet'](fname))
      if not roots[root] then
        roots[root] = {}
      end
      B.stack_item_uniq(roots[root], string.sub(fname, #root + 2, #fname))
    end
  end
  for root, _ in pairs(roots) do
    local fname = B.get_filepath(root, roots[root][1]).filename
    B.cmd('e %s', fname)
    require 'nvim-tree.actions.tree.find-file'.fn()
  end
  B.cmd('b%d', cur_bufnr)
end

function M.map()
  require 'which-key'.register {
    ['<c-f>'] = { function() M.toggle() end, 'nvimtree: toggle', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-cr>'] = { function() M.last_dir() end, 'nvimtree: open tree in last dir', mode = { 'n', 'v', }, silent = true, },
    ['<c-`>'] = { function() M.sel_dirvers() end, 'nvimtree: open tree in dirvers(sel)', mode = { 'n', 'v', }, silent = true, },
    ['<c-1>'] = { function() M.sel_parent_dirs() end, 'nvimtree: open tree in parent dirs(sel)', mode = { 'n', 'v', }, silent = true, },
    ['<c-2>'] = { function() M.sel_my_dirs() end, 'nvimtree: open tree in my dirs(sel)', mode = { 'n', 'v', }, silent = true, },
    ['<c-3>'] = { function() M.sel_SHGetFolderPath() end, 'nvimtree: open tree in SHGetFolderPath(sel)', mode = { 'n', 'v', }, silent = true, },
    ['<c-4>'] = { function() M.sel_all_git_repos() end, 'nvimtree: open tree in all git repos(sel)', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-4>'] = { function() require 'config.my.git'.get_all_git_repos(1) end, 'nvimtree: open tree in all git repos(sel)(force)', mode = { 'n', 'v', }, silent = true, },
    ['<c-5>'] = { function() M.sel_dirs() end, 'nvimtree: open tree in dirs(sel)', mode = { 'n', 'v', }, silent = true, },
    ['<leader>d'] = { name = 'nvim/qf', },
    ['<leader>dj'] = { function() M.open_next_tree_node() end, 'quick open: nvimtree next node', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dk'] = { function() M.open_prev_tree_node() end, 'quick open: nvimtree prev node', mode = { 'n', 'v', }, silent = true, },
    ['<leader>do'] = { function() M.open_all() end, 'nvimtree: open_all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>de'] = { function() M.refresh_hl() end, 'nvimtree: refresh hl', mode = { 'n', 'v', }, silent = true, },
    ['<leader>da'] = { function() M.ausize_toggle() end, 'nvimtree: ausize toggle', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dc'] = { function() M.toggle_cur_root() end, 'nvimtree: toggle cur root', mode = { 'n', 'v', }, silent = true, },
    ['<leader>dr'] = { function() M.reset_nvimtree() end, 'nvimtree: reset nvimtree', mode = { 'n', }, silent = true, },
  }
end

L(M, M.map)

return M
