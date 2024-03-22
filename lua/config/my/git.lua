local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

require 'telescope'.load_extension 'ui-select'

function M.get_info(info)
  info = string.gsub(info, '"', "'")
  info = string.gsub(info, '#', ' ')
  info = string.gsub(info, '\r', '\n')
  info = string.gsub(info, '\r\n', '\n')
  info = string.gsub(info, ':\n+', '. ')
  info = string.gsub(info, '\n+', '. ')
  info = vim.fn.trim(info)
  return info
end

function M.get_commit_history()
  local f = io.popen 'git log --pretty=format:"%h - %an, %ar :::: %s"'
  if f then
    local commits = {}
    for commit in string.gmatch(f:read '*a', '([%S ]+)') do
      if not B.is_in_tbl(commit, commits) then
        commits[#commits + 1] = commit
      end
    end
    f:close()
    return commits
  end
  return {}
end

function M.show_commit_history() B.ui_sel(M.get_commit_history(), 'Show Commit History', function() end) end

M.commit_history_en = nil

function GitCompletion()
  return B.get_git_modified_files()
end

function M.get_commit_and_do(prompt, callback)
  if M.commit_history_en then
    local commits = M.get_commit_history()
    B.ui_sel(commits, prompt, function(commit)
      if not commit then
        commit = ''
      else
        commit = string.match(commit, '.*:::: (.+)')
      end
      vim.ui.input({ prompt = prompt, default = commit, completion = 'customlist,v:lua.GitCompletion', }, function(input)
        if B.is(input) then
          callback(input)
        end
      end)
    end)
  else
    vim.ui.input({ prompt = prompt, completion = 'customlist,v:lua.GitCompletion', }, function(input)
      if B.is(input) then
        callback(input)
      end
    end)
  end
  M.commit_history_en = nil
end

-- gitpush
function M.addcommitpush_do(info)
  if info and #info > 0 then
    B.set_timeout(10, function()
      info = M.get_info(info)
      B.notify_info_append('addcommitpush: ' .. info)
      B.system_run('asyncrun', 'git add -A && git status && git commit -m "%s" && git push', info)
    end)
  end
end

function M.addcommitpush(info, commit_history_en)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'status', '-s', }
  if #result > 0 then
    B.notify_info { 'git status -s', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      M.commit_history_en = commit_history_en
      M.get_commit_and_do('commit info (Add all and push): ', M.addcommitpush_do)
    end
    M.addcommitpush_do(info)
  else
    vim.notify 'no changes'
  end
end

function M.addcommitpush_curline()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.curline)
end

function M.addcommitpush_single_quote()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.single_quote)
end

function M.addcommitpush_double_quote()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.double_quote)
end

function M.addcommitpush_parentheses()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.parentheses)
end

function M.addcommitpush_bracket()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.bracket)
end

function M.addcommitpush_brace()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.brace)
end

function M.addcommitpush_back_quote()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.back_quote)
end

function M.addcommitpush_angle_bracket()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.g.angle_bracket)
end

function M.addcommitpush_cword()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.fn.expand '<cword>')
end

function M.addcommitpush_cWORD()
  require 'config.my.imaps'.setreg()
  M.addcommitpush(vim.fn.expand '<cWORD>')
end

function M.commit_push_do(info)
  if info and #info > 0 then
    B.set_timeout(10, function()
      info = M.get_info(info)
      B.notify_info_append('commit_push: ' .. info)
      B.system_run('asyncrun', 'git commit -m "%s" && git push', info)
    end)
  end
end

function M.commit_push(info, commit_history_en)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'diff', '--staged', '--stat', }
  if #result > 0 then
    B.notify_info { 'git diff --staged --stat', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      M.commit_history_en = commit_history_en
      M.get_commit_and_do('commit info (commit and push): ', M.commit_push_do)
    end
    M.commit_push_do(info)
  else
    vim.notify 'no staged'
  end
end

function M.commit_do(info)
  if info and #info > 0 then
    B.set_timeout(10, function()
      info = M.get_info(info)
      B.notify_info_append('commit: ' .. info)
      B.system_run('asyncrun', 'git commit -m "%s"', info)
    end)
  end
end

function M.commit(info, commit_history_en)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'diff', '--staged', '--stat', }
  if #result > 0 then
    B.notify_info { 'git diff --staged --stat', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      M.commit_history_en = commit_history_en
      M.get_commit_and_do('commit info (just commit): ', M.commit_do)
    end
    M.commit_do(info)
  else
    vim.notify 'no staged'
  end
end

function M.graph_asyncrun()
  B.system_run('asyncrun', 'git log --all --graph --decorate --oneline')
end

function M.graph_start()
  B.system_run('start', 'git log --all --graph --decorate --oneline && pause')
end

function M.git_browser()
  local _, url = B.get_git_remote_url()
  if B.is(url) then
    B.system_run('start silent', 'start https://%s', url)
  end
end

function M.push()
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'cherry', '-v', }
  if #result > 0 then
    B.notify_info { 'git cherry -v', vim.loop.cwd(), table.concat(result, '\n'), }
    B.set_timeout(10, function()
      B.system_run('asyncrun', 'git push')
    end)
  else
    vim.notify 'cherry empty'
  end
end

function M.init_do(git_root_dir)
  local remote_name = B.get_fname_tail(git_root_dir)
  if remote_name == '' then
    return
  end
  remote_name = '.git-' .. remote_name
  local remote_dir_path = B.get_dirpath { git_root_dir, remote_name, }
  if remote_dir_path:exists() then
    B.notify_info('remote path already existed: ' .. remote_dir_path.filename)
    return
  end
  local file_path = B.get_filepath(git_root_dir, '.gitignore')
  if file_path:exists() then
    local lines = file_path:readlines()
    if vim.tbl_contains(lines, remote_name) == false then
      file_path:write(remote_name, 'a')
      file_path:write('\r\n.clang-format', 'a')
      file_path:write('\r\n.clangd', 'a')
    end
  else
    file_path:write(remote_name, 'w')
    file_path:write('\r\n.clang-format', 'a')
    file_path:write('\r\n.clangd', 'a')
  end
  B.asyncrun_prepare_add(function()
    M.addcommitpush 's1'
  end)
  B.system_run('asyncrun', {
    B.system_cd(git_root_dir),
    'md "%s"',
    'cd %s',
    'git init --bare',
    'cd ..',
    'git init',
    'git add .gitignore',
    [[git commit -m ".gitignore"]],
    [[git remote add origin "%s"]],
    [[git branch -M "main"]],
    [[git push -u origin "main"]],
  }, remote_name, remote_name, remote_name)
end

function M.init()
  B.ui_sel(B.get_file_dirs(B.buf_get_name_0()), 'git init', function(choice)
    if choice then
      M.init_do(choice)
    end
  end)
end

function M.addall()
  pcall(vim.call, 'ProjectRootCD')
  B.system_run('asyncrun', 'git add -A')
end

function M.pull()
  pcall(vim.call, 'ProjectRootCD')
  B.notify_info 'git pull'
  B.system_run('asyncrun', 'git pull')
end

M.pull_all_prepared = nil

function M.pull_all_prepare()
  M.pull_all_prepared = 1
  M.repos_dir = { B.nvim_dir, }
  local _gits = B.get_dirs_equal('.git', B.get_repos_dir(), { hidden = true, depth = 2, })
  for _, dir in ipairs(_gits) do
    M.repos_dir[#M.repos_dir + 1] = B.file_parent(dir)
  end
end

function M.pull_all()
  if not M.pull_all_prepared then
    M.pull_all_prepare()
  end
  local info = ''
  for _, dir in ipairs(M.repos_dir) do
    local type, url = B.get_git_remote_url(dir)
    if type == 'https' then
      B.system_run('start', '%s && git remote remove origin && git remote add origin git@%s:%s && git pull', B.system_cd(dir), url, string.match(url, '[^/]+/(.+)'))
    else
      B.system_run('start silent', '%s && git pull', B.system_cd(dir))
    end
    info = info .. dir .. '\n'
  end
  info = info .. 'total ' .. tostring(#M.repos_dir) .. ' git repos'
  B.notify_info { 'git pull_all', info, }
end

function M.reset_hard()
  if B.is_sure 'git reset --hard' then
    B.system_run('asyncrun', 'git reset --hard')
  end
end

function M.reset_hard_clean()
  if B.is_sure 'git reset --hard && git clean -fd' then
    B.system_run('asyncrun', 'git reset --hard && git clean -fd')
  end
end

function M.clean_ignored_files_and_folders()
  local result = vim.fn.systemlist { 'git', 'clean', '-xdn', }
  if #result > 0 then
    B.notify_info { 'git clean -xdn', vim.loop.cwd(), table.concat(result, '\n'), }
    if B.is_sure 'Sure to del all of them' then
      return
    end
  else
    return
  end
  vim.g.cwd = vim.fn['ProjectRootGet']()
  vim.cmd [[
    python << EOF
import subprocess
import vim
import re
import os
import shutil
cwd = vim.eval('g:cwd')
rm_exclude = [
  '.git-.*',
  '.svn'
]
out = subprocess.Popen(['git', 'clean', '-xdn'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=cwd)
stdout, stderr = out.communicate()
if not stderr:
  stdout = stdout.decode('utf-8').replace('\r', '').split('\n')
  c = 0
  for line in stdout:
    res = re.findall('Would remove (.+)', line)
    if res:
      ok = 1
      for p in rm_exclude:
        if re.match(p, res[0]):
          ok = 0
          break
      if ok:
        c += 1
        file = os.path.join(cwd, res[0])
        if re.match('.+/$', res[0]):
          shutil.rmtree(file)
        else:
          os.remove(file)
  vim.command(f"""lua require'base'.notify_info('del {c} Done!')""")
    EOF
]]
end

function M.clone()
  local dirs = B.merge_tables(
    B.get_my_dirs(),
    B.get_file_dirs(B.rep_backslash_lower(B.buf_get_name_0()))
  )
  B.ui_sel(dirs, 'git clone sel a dir', function(proj)
    if not proj then
      return
    end
    local author, repo = string.match(vim.fn.input('author/repo to clone: ', 'peter-lyr/2023'), '(.+)/(.+)')
    if B.is(author) and B.is(repo) then
      B.system_run('start', [[cd %s & git clone git@github.com:%s/%s.git]], proj, author, repo)
    end
  end)
end

-- gitsigns
require 'gitsigns'.setup {
  signs                        = {
    add = { text = '+', },
    change = { text = '~', },
    delete = { text = '_', },
    topdelete = { text = '‾', },
    changedelete = { text = '', },
    untracked = { text = '?', },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true,
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 100,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  yadm                         = {
    enable = false,
  },
}

M.word_diff_en = 1
M.word_diff = 1
M.moving = nil

B.aucmd({ 'InsertEnter', 'CursorMoved', }, 'my.git.signs.InsertEnter', {
  callback = function()
    M.moving = 1
    if M.word_diff then
      M.word_diff = require 'gitsigns'.toggle_word_diff(nil)
    end
  end,
})

B.aucmd('CursorHold', 'my.git.signs.CursorHold', {
  callback = function()
    M.moving = nil
    vim.fn.timer_start(500, function()
      vim.schedule(function()
        if not M.moving then
          if M.word_diff_en == 1 then
            M.word_diff = require 'gitsigns'.toggle_word_diff(1)
          end
        end
      end)
    end)
  end,
})

function M.leader_k()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() require 'gitsigns'.prev_hunk() end)
  return '<Ignore>'
end

function M.leader_j()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() require 'gitsigns'.next_hunk() end)
  return '<Ignore>'
end

function M.stage_hunk() require 'gitsigns'.stage_hunk() end

function M.stage_hunk_v() require 'gitsigns'.stage_hunk { vim.fn.line '.', vim.fn.line 'v', } end

function M.stage_buffer() require 'gitsigns'.stage_buffer() end

function M.undo_stage_hunk() require 'gitsigns'.undo_stage_hunk() end

function M.reset_hunk() require 'gitsigns'.reset_hunk() end

function M.reset_hunk_v() require 'gitsigns'.reset_hunk { vim.fn.line '.', vim.fn.line 'v', } end

function M.reset_buffer() require 'gitsigns'.reset_buffer() end

function M.preview_hunk() require 'gitsigns'.preview_hunk() end

function M.blame_line() require 'gitsigns'.blame_line { full = true, } end

function M.diffthis() require 'gitsigns'.diffthis() end

function M.diffthis_l() require 'gitsigns'.diffthis '~' end

function M.toggle_current_line_blame() require 'gitsigns'.toggle_current_line_blame() end

function M.toggle_deleted() require 'gitsigns'.toggle_deleted() end

function M.toggle_numhl() require 'gitsigns'.toggle_numhl() end

function M.toggle_linehl() require 'gitsigns'.toggle_linehl() end

function M.toggle_signs() require 'gitsigns'.toggle_signs() end

function M.toggle_word_diff()
  local temp = require 'gitsigns'.toggle_word_diff()
  if temp == false then
    M.word_diff_en = 0
  else
    M.word_diff_en = 1
  end
end

-- mapping
function M.gitsigns_opt(desc) return { silent = true, desc = 'my.git.signs: ' .. desc, } end

-- lazygit
function M.lazygit() B.system_run('start', 'lazygit') end

-- diffview
local actions = require 'diffview.actions'

M.diffview_filehistory = function(mode)
  if mode == 1 then
    vim.cmd 'DiffviewFileHistory'
  elseif mode == 2 then
    vim.cmd 'DiffviewFileHistory --max-count=64'
  elseif mode == 3 then
    vim.cmd 'DiffviewFileHistory --max-count=238778'
  end
end

M.diffview_stash = function() vim.cmd 'DiffviewFileHistory --walk-reflogs --range=stash' end

M.diffview_open = function() vim.cmd 'DiffviewOpen -u' end

M.diffview_close = function() vim.cmd 'DiffviewClose' end

require 'diffview'.setup {
  file_history_panel = {
    log_options = {
      git = {
        single_file = {
          max_count = 16,
        },
        multi_file = {
          max_count = 16,
        },
      },
    },
  },
  keymaps = {
    disable_defaults = true,
    view = {
      { 'n', '<tab>',      actions.select_next_entry,        { desc = 'Open the diff for the next file', }, },
      { 'n', '<s-tab>',    actions.select_prev_entry,        { desc = 'Open the diff for the previous file', }, },
      { 'n', 'gf',         actions.goto_file_edit,           { desc = 'Open the file in a new split in the previous tabpage', }, },
      { 'n', 'F',          actions.goto_file_split,          { desc = 'Open the file in a new split', }, },
      { 'n', 'gF',         actions.goto_file_tab,            { desc = 'Open the file in a new tabpage', }, },
      { 'n', '<leader>e',  actions.focus_files,              { desc = 'Bring focus to the file panel', }, },
      { 'n', '<leader>l',  actions.toggle_files,             { desc = 'Toggle the file panel.', }, },
      { 'n', '<A-x>',      actions.cycle_layout,             { desc = 'Cycle through available layouts.', }, },
      { 'n', '[x',         actions.prev_conflict,            { desc = 'In the merge-tool: jump to the previous conflict', }, },
      { 'n', ']x',         actions.next_conflict,            { desc = 'In the merge-tool: jump to the next conflict', }, },
      { 'n', '<leader>co', actions.conflict_choose 'ours',   { desc = 'Choose the OURS version of a conflict', }, },
      { 'n', '<leader>ct', actions.conflict_choose 'theirs', { desc = 'Choose the THEIRS version of a conflict', }, },
      { 'n', '<leader>cb', actions.conflict_choose 'base',   { desc = 'Choose the BASE version of a conflict', }, },
      { 'n', '<leader>ca', actions.conflict_choose 'all',    { desc = 'Choose all the versions of a conflict', }, },
      { 'n', 'dx',         actions.conflict_choose 'none',   { desc = 'Delete the conflict region', }, },
    },
    diff1 = {
      { 'n', '?', actions.help { 'view', 'diff1', }, { desc = 'Open the help panel', }, },
    },
    diff2 = {
      { 'n', '?', actions.help { 'view', 'diff2', }, { desc = 'Open the help panel', }, },
    },
    diff3 = {
      { { 'n', 'x', }, '2do', actions.diffget 'ours',            { desc = 'Obtain the diff hunk from the OURS version of the file', }, },
      { { 'n', 'x', }, '3do', actions.diffget 'theirs',          { desc = 'Obtain the diff hunk from the THEIRS version of the file', }, },
      { 'n',           '?',   actions.help { 'view', 'diff3', }, { desc = 'Open the help panel', }, },
    },
    diff4 = {
      { { 'n', 'x', }, '1do', actions.diffget 'base',            { desc = 'Obtain the diff hunk from the BASE version of the file', }, },
      { { 'n', 'x', }, '2do', actions.diffget 'ours',            { desc = 'Obtain the diff hunk from the OURS version of the file', }, },
      { { 'n', 'x', }, '3do', actions.diffget 'theirs',          { desc = 'Obtain the diff hunk from the THEIRS version of the file', }, },
      { 'n',           '?',   actions.help { 'view', 'diff4', }, { desc = 'Open the help panel', }, },
    },
    file_panel = {
      { 'n', 'j',             actions.next_entry,          { desc = 'Bring the cursor to the next file entry', }, },
      { 'n', '<down>',        actions.next_entry,          { desc = 'Bring the cursor to the next file entry', }, },
      { 'n', 'k',             actions.prev_entry,          { desc = 'Bring the cursor to the previous file entry.', }, },
      { 'n', '<up>',          actions.prev_entry,          { desc = 'Bring the cursor to the previous file entry.', }, },
      { 'n', '<cr>',          actions.select_entry,        { desc = 'Open the diff for the selected entry.', }, },
      { 'n', 'o',             actions.select_entry,        { desc = 'Open the diff for the selected entry.', }, },
      { 'n', 'a',             actions.select_entry,        { desc = 'Open the diff for the selected entry.', }, },
      { 'n', '<2-LeftMouse>', actions.select_entry,        { desc = 'Open the diff for the selected entry.', }, },
      { 'n', 's',             actions.toggle_stage_entry,  { desc = 'Stage / unstage the selected entry.', }, },
      { 'n', 'S',             actions.stage_all,           { desc = 'Stage all entries.', }, },
      { 'n', 'U',             actions.unstage_all,         { desc = 'Unstage all entries.', }, },
      { 'n', 'X',             actions.restore_entry,       { desc = 'Restore entry to the state on the left side.', }, },
      { 'n', '<c-l>',         actions.open_commit_log,     { desc = 'Open the commit log panel.', }, },
      { 'n', '<c-b>',         actions.scroll_view(-0.25),  { desc = 'Scroll the view up', }, },
      { 'n', '<c-f>',         actions.scroll_view(0.25),   { desc = 'Scroll the view down', }, },
      { 'n', '<tab>',         actions.select_next_entry,   { desc = 'Open the diff for the next file', }, },
      { 'n', '<s-tab>',       actions.select_prev_entry,   { desc = 'Open the diff for the previous file', }, },
      { 'n', 'gf',            actions.goto_file_edit,      { desc = 'Open the file in a new split in the previous tabpage', }, },
      { 'n', 'F',             actions.goto_file_split,     { desc = 'Open the file in a new split', }, },
      { 'n', 'gF',            actions.goto_file_tab,       { desc = 'Open the file in a new tabpage', }, },
      { 'n', 'i',             actions.listing_style,       { desc = "Toggle between 'list' and 'tree' views", }, },
      { 'n', 'f',             actions.toggle_flatten_dirs, { desc = 'Flatten empty subdirectories in tree listing style.', }, },
      { 'n', '<c-r>',         actions.refresh_files,       { desc = 'Update stats and entries in the file list.', }, },
      { 'n', '<leader>e',     actions.focus_files,         { desc = 'Bring focus to the file panel', }, },
      { 'n', '<leader>l',     actions.toggle_files,        { desc = 'Toggle the file panel', }, },
      { 'n', '<A-x>',         actions.cycle_layout,        { desc = 'Cycle available layouts', }, },
      { 'n', '[x',            actions.prev_conflict,       { desc = 'Go to the previous conflict', }, },
      { 'n', ']x',            actions.next_conflict,       { desc = 'Go to the next conflict', }, },
      { 'n', '?',             actions.help 'file_panel',   { desc = 'Open the help panel', }, },
    },
    file_history_panel = {
      { 'n', '!',             actions.options,                   { desc = 'Open the option panel', }, },
      { 'n', 'D',             actions.open_in_diffview,          { desc = 'Open the entry under the cursor in a diffview', }, },
      { 'n', 'y',             actions.copy_hash,                 { desc = 'Copy the commit hash of the entry under the cursor', }, },
      { 'n', '<c-l>',         actions.open_commit_log,           { desc = 'Show commit details', }, },
      { 'n', 'r',             actions.open_all_folds,            { desc = 'Expand all folds', }, },
      { 'n', 'm',             actions.close_all_folds,           { desc = 'Collapse all folds', }, },
      { 'n', 'j',             actions.next_entry,                { desc = 'Bring the cursor to the next file entry', }, },
      { 'n', '<down>',        actions.next_entry,                { desc = 'Bring the cursor to the next file entry', }, },
      { 'n', 'k',             actions.prev_entry,                { desc = 'Bring the cursor to the previous file entry.', }, },
      { 'n', '<up>',          actions.prev_entry,                { desc = 'Bring the cursor to the previous file entry.', }, },
      { 'n', 'o',             actions.select_entry,              { desc = 'Open the diff for the selected entry.', }, },
      { 'n', '<2-LeftMouse>', actions.select_entry,              { desc = 'Open the diff for the selected entry.', }, },
      { 'n', '<c-b>',         actions.scroll_view(-0.25),        { desc = 'Scroll the view up', }, },
      { 'n', '<c-f>',         actions.scroll_view(0.25),         { desc = 'Scroll the view down', }, },
      { 'n', '<tab>',         actions.select_next_entry,         { desc = 'Open the diff for the next file', }, },
      { 'n', '<s-tab>',       actions.select_prev_entry,         { desc = 'Open the diff for the previous file', }, },
      { 'n', 'gf',            actions.goto_file_edit,            { desc = 'Open the file in a new split in the previous tabpage', }, },
      { 'n', 'F',             actions.goto_file_split,           { desc = 'Open the file in a new split', }, },
      { 'n', 'gF',            actions.goto_file_tab,             { desc = 'Open the file in a new tabpage', }, },
      { 'n', '<leader>e',     actions.focus_files,               { desc = 'Bring focus to the file panel', }, },
      { 'n', '<leader>l',     actions.toggle_files,              { desc = 'Toggle the file panel', }, },
      { 'n', '<A-x>',         actions.cycle_layout,              { desc = 'Cycle available layouts', }, },
      { 'n', '?',             actions.help 'file_history_panel', { desc = 'Open the help panel', }, },
    },
    option_panel = {
      { 'n', '<tab>', actions.select_entry,        { desc = 'Change the current option', }, },
      { 'n', 'q',     actions.close,               { desc = 'Close the panel', }, },
      { 'n', '?',     actions.help 'option_panel', { desc = 'Open the help panel', }, },
    },
    help_panel = {
      { 'n', 'q',     actions.close, { desc = 'Close help menu', }, },
      { 'n', '<esc>', actions.close, { desc = 'Close help menu', }, },
      { 'n', '<c-3>', actions.close, { desc = 'Close help menu', }, },
      { 'n', '<c-2>', actions.close, { desc = 'Close help menu', }, },
      { 'n', '<c-1>', actions.close, { desc = 'Close help menu', }, },
      { 'n', '<c-4>', actions.close, { desc = 'Close help menu', }, },
    },
  },
}

-- repos
function M.get_all_git_repos(force)
  local all_git_repos_txt = B.getcreate_filepath(
    B.getcreate_stddata_dirpath 'all_git_repos'.filename,
    'all_git_repos.txt'
  ).filename
  local repos = vim.fn.readfile(all_git_repos_txt)
  if #repos == 0 or force then
    B.system_run('start', 'chcp 65001 && python "%s" "%s"',
      B.getcreate_filepath(M.source .. '.py', 'scan_git_repos.py').filename, all_git_repos_txt)
    B.notify_info 'scan_git_repos, try again later.'
    return nil
  end
  return repos
end

-- fugitive
M.fugitive_winid = 0

function M.fugitive_toggle()
  if B.is_buf_fts 'fugitive' then
    vim.cmd 'close'
    B.set_timeout(10, function()
      vim.fn.win_gotoid(M.fugitive_winid)
    end)
  else
    M.fugitive_winid = vim.fn.win_getid()
    vim.cmd 'Git'
    vim.api.nvim_win_set_height(0, vim.fn.line '$' + 3)
    vim.cmd 'set winfixheight'
  end
end

-- qf
M.quickfix_winid = 0

vim.cmd 'Lazy load nvim-bqf'

function M.nodupl()
  local title = vim.fn.getqflist { title = 0, }.title
  local l = {}
  local D = {}
  local different = nil
  for _, i in ipairs(vim.fn.getqflist()) do
    i.text = vim.fn.trim(i.text)
    local d = string.format('%d-%d-%d-%s', i.bufnr, i.col, i.lnum, i.text)
    if vim.tbl_contains(D, d) == false or #i.text == 0 then
      l[#l + 1] = i
      D[#D + 1] = d
    else
      different = 1
    end
  end
  if different then
    vim.fn.setqflist(l, 'r')
    vim.fn.setqflist({}, 'a', { title = title, })
  end
end

function M.quickfix_toggle()
  if B.is_buf_fts 'qf' then
    vim.cmd 'cclose'
    B.set_timeout(10, function()
      vim.fn.win_gotoid(M.quickfix_winid)
    end)
  else
    M.quickfix_winid = vim.fn.win_getid()
    vim.cmd 'copen'
    local height = vim.fn.line '$' + 3
    if height > vim.o.lines / 2 then
      if vim.o.lines % 2 == 1 then
        height = (vim.o.lines - 1) / 2
      else
        height = vim.o.lines / 2
      end
    end
    vim.api.nvim_win_set_height(0, height)
    M.nodupl()
  end
end

M.line = 1
M.col = 1

function M.open_prev_item()
  vim.cmd 'copen'
  M.timer = B.set_interval(50, function()
    if not M.just_entered then
      B.clear_interval(M.timer)
      vim.cmd 'norm k'
      vim.cmd [[call feedkeys("\<cr>")]]
    end
  end)
end

function M.open_next_item()
  vim.cmd 'copen'
  M.timer = B.set_interval(50, function()
    if not M.just_entered then
      B.clear_interval(M.timer)
      vim.cmd 'norm j'
      vim.cmd [[call feedkeys("\<cr>")]]
    end
  end)
end

-- B.aucmd({ 'TextChanged', }, 'test.nvimtree.TextChanged', {
--   callback = function()
--     vim.fn['fugitive#ReloadStatus']()
--   end,
-- })

B.aucmd({ 'BufEnter', }, 'test.nvimtree.BufEnter', {
  callback = function()
    if vim.bo.ft == 'qf' then
      M.just_entered = 1
      B.set_timeout(50, function()
        B.cmd('norm %dgg%d|', M.line, M.col)
        M.just_entered = nil
      end)
    end
  end,
})

B.aucmd({ 'BufLeave', }, 'test.nvimtree.BufLeave', {
  callback = function()
    if vim.bo.ft == 'qf' then
      M.line = vim.fn.line '.'
      M.col = vim.fn.col '.'
    end
  end,
})

vim.cmd [[
  anoremenu PopUp.-3-              <Nop>
  nnoremenu PopUp.QuickFix\ Open   :copen<cr>
  vnoremenu PopUp.QuickFix\ Open   :<C-U>copen<cr>
  inoremenu PopUp.QuickFix\ Open   <C-O>:<C-u>copen<cr>
  nnoremenu PopUp.QuickFix\ Close  :cclose<cr>
  vnoremenu PopUp.QuickFix\ Close  :<C-U>cclose<cr>
  inoremenu PopUp.QuickFix\ Close  <C-O>:<C-u>cclose<cr>
  anoremenu PopUp.-4-              <Nop>
  nnoremenu PopUp.Fugitive\ Toggle :lua require 'config.my.git'.fugitive_toggle()<cr>
  vnoremenu PopUp.Fugitive\ Toggle :<C-U>lua require 'config.my.git'.fugitive_toggle()<cr>
  inoremenu PopUp.Fugitive\ Toggle <C-O>:<C-u>lua require 'config.my.git'.fugitive_toggle()<cr>
]]

return M
