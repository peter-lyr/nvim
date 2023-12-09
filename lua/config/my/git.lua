local M = {}

local B = require 'base'
M.lua = B.getlua(debug.getinfo(1)['source'])

-- notify
require 'notify'.setup {
  top_down = false,
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
}
vim.notify = require 'notify'

-- gitpush
function M.addcommitpush(info)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'status', '-s', }
  if #result > 0 then
    B.notify_info { 'git status -s', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      info = vim.fn.input 'commit info (Add all and push): '
    end
    if #info > 0 then
      B.set_timeout(10, function()
        info = string.gsub(info, '"', '\\"')
        B.system_run('asyncrun', 'git add -A && git status && git commit -m "%s" && git push', info)
      end)
    end
  else
    vim.notify 'no changes'
  end
end

function M.commit_push(info)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'diff', '--staged', '--stat', }
  if #result > 0 then
    B.notify_info { 'git diff --staged --stat', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      info = vim.fn.input 'commit info (commit and push): '
    end
    if #info > 0 then
      B.set_timeout(10, function()
        info = string.gsub(info, '"', '\\"')
        B.system_run('asyncrun', 'git commit -m "%s" && git push', info)
      end)
    end
  else
    vim.notify 'no staged'
  end
end

function M.commit(info)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'diff', '--staged', '--stat', }
  if #result > 0 then
    B.notify_info { 'git diff --staged --stat', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      info = vim.fn.input 'commit info (just commit): '
    end
    if #info > 0 then
      B.set_timeout(10, function()
        info = string.gsub(info, '"', '\\"')
        B.system_run('asyncrun', 'git commit -m "%s"', info)
      end)
    end
  else
    vim.notify 'no staged'
  end
end

function M.graph(runway)
  if not runway then
    B.system_run('asyncrun', 'git log --all --graph --decorate --oneline')
  else
    B.system_run(runway, 'git log --all --graph --decorate --oneline && pause')
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
  local remote_dir_path = B.get_dir_path { git_root_dir, remote_name, }
  if remote_dir_path:exists() then
    B.notify_info('remote path already existed: ' .. remote_dir_path.filename)
    return
  end
  local file_path = B.get_filepath(git_root_dir, '.gitignore')
  if file_path:exists() then
    local lines = file_path:readlines()
    if vim.tbl_contains(lines, remote_name) == false then
      file_path:write(remote_name, 'a')
      file_path:write('.clang-format', 'a')
    end
  else
    file_path:write(remote_name, 'w')
    file_path:write('.clang-format', 'w')
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
  B.ui_sel(B.get_file_dirs(vim.api.nvim_buf_get_name(0)), 'git init', function(choice)
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
  B.system_run('asyncrun', 'git pull')
end

function M.reset_hard()
  local res = vim.fn.input('git reset --hard [N/y]: ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    B.system_run('asyncrun', 'git reset --hard')
  end
end

function M.reset_hard_clean()
  local res = vim.fn.input('git reset --hard && git clean -fd [N/y]: ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    B.system_run('asyncrun', 'git reset --hard && git clean -fd')
  end
end

function M.clean_ignored_files_and_folders()
  local result = vim.fn.systemlist { 'git', 'clean', '-xdn', }
  if #result > 0 then
    B.notify_info { 'git clean -xdn', vim.loop.cwd(), table.concat(result, '\n'), }
    local res = vim.fn.input('Sure to del all of them? [Y/n]: ', 'y')
    if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == false then
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

M.depei = vim.fn.expand [[$HOME]] .. '\\DEPEI'

if vim.fn.isdirectory(M.depei) == 0 then
  vim.fn.mkdir(M.depei)
end

M.my_dirs = {
  B.rep_backslash_lower(M.depei),
  B.rep_backslash_lower(vim.fn.expand [[$HOME]]),
  B.rep_backslash_lower(vim.fn.expand [[$TEMP]]),
  B.rep_backslash_lower(vim.fn.expand [[$LOCALAPPDATA]]),
  B.rep_backslash_lower(vim.fn.stdpath 'config'),
  B.rep_backslash_lower(vim.fn.stdpath 'data'),
  B.rep_backslash_lower(vim.fn.expand [[$VIMRUNTIME]]),
}

function M.clone()
  local dirs = B.merge_tables(
    M.my_dirs,
    B.get_file_dirs(B.rep_backslash_lower(vim.api.nvim_buf_get_name(0)))
  )
  B.ui_sel(dirs, 'git clone sel a dir', function(proj)
    local author, repo = string.match(vim.fn.input('author/repo to clone: ', 'peter-lyr/2023'), '(.+)/(.+)')
    if B.is(author) and B.is(repo) then
      B.system_run('start', [[cd %s & git clone git@github.com:%s/%s.git]], proj, author, repo)
    end
  end)
end

-- mapping
function M.gitpush_opt(desc)
  return { silent = true, desc = M.lua .. '.push: ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<leader>ga', M.addcommitpush, M.gitpush_opt 'addcommitpush')
vim.keymap.set({ 'n', 'v', }, '<leader>gc', M.commit_push, M.gitpush_opt 'commit_push')
vim.keymap.set({ 'n', 'v', }, '<leader>ggc', M.commit, M.gitpush_opt 'commit')
vim.keymap.set({ 'n', 'v', }, '<leader>ggs', M.push, M.gitpush_opt 'push')
vim.keymap.set({ 'n', 'v', }, '<leader>ggg', M.graph, M.gitpush_opt 'graph')
vim.keymap.set({ 'n', 'v', }, '<leader>gg<c-g>', function() M.graph 'start' end, M.gitpush_opt 'graph')
vim.keymap.set({ 'n', 'v', }, '<leader>ggv', M.init, M.gitpush_opt 'init')
vim.keymap.set({ 'n', 'v', }, '<leader>ggf', M.pull, M.gitpush_opt 'pull')
vim.keymap.set({ 'n', 'v', }, '<leader>gga', M.addall, M.gitpush_opt 'addall')
vim.keymap.set({ 'n', 'v', }, '<leader>ggr', M.reset_hard, M.gitpush_opt 'reset_hard')
vim.keymap.set({ 'n', 'v', }, '<leader>ggd', M.reset_hard_clean, M.gitpush_opt 'reset_hard_clean')
vim.keymap.set({ 'n', 'v', }, '<leader>ggD', M.clean_ignored_files_and_folders, M.gitpush_opt 'clean_ignored_files_and_folders')
vim.keymap.set({ 'n', 'v', }, '<leader>ggC', M.clone, M.gitpush_opt 'clone')

-- gitsigns
vim.keymap.set('n', '<leader>j', function()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require 'gitsigns'.next_hunk()
  end)
  return '<Ignore>'
end, { expr = true, desc = 'Gitsigns next_hunk', })

vim.keymap.set('n', '<leader>k', function()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require 'gitsigns'.prev_hunk()
  end)
  return '<Ignore>'
end, { expr = true, desc = 'Gitsigns prev_hunk', })

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

local word_diff_en = 1
local word_diff = 1
local moving = nil

B.aucmd({ 'InsertEnter', 'CursorMoved', }, M.lua .. '_InsertEnter', {
  callback = function()
    moving = 1
    if word_diff then
      word_diff = require 'gitsigns'.toggle_word_diff(nil)
    end
  end,
})

B.aucmd('CursorHold', M.lua .. '_CursorHold', {
  callback = function()
    moving = nil
    vim.fn.timer_start(500, function()
      vim.schedule(function()
        if not moving then
          if word_diff_en == 1 then
            word_diff = require 'gitsigns'.toggle_word_diff(1)
          end
        end
      end)
    end)
  end,
})

function M.next_hunk()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    require 'gitsigns'.next_hunk()
  end)
  return '<Ignore>'
end

function M.prev_hunk()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    require 'gitsigns'.prev_hunk()
  end)
  return '<Ignore>'
end

function M.stage_hunk()
  require 'gitsigns'.stage_hunk()
end

function M.stage_hunk_v()
  require 'gitsigns'.stage_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

function M.stage_buffer()
  require 'gitsigns'.stage_buffer()
end

function M.undo_stage_hunk()
  require 'gitsigns'.undo_stage_hunk()
end

function M.reset_hunk()
  require 'gitsigns'.reset_hunk()
end

function M.reset_hunk_v()
  require 'gitsigns'.reset_hunk { vim.fn.line '.', vim.fn.line 'v', }
end

function M.reset_buffer()
  require 'gitsigns'.reset_buffer()
end

function M.preview_hunk()
  require 'gitsigns'.preview_hunk()
end

function M.blame_line()
  require 'gitsigns'.blame_line { full = true, }
end

function M.diffthis()
  require 'gitsigns'.diffthis()
end

function M.diffthis_l()
  require 'gitsigns'.diffthis '~'
end

function M.toggle_current_line_blame()
  require 'gitsigns'.toggle_current_line_blame()
end

function M.toggle_deleted()
  require 'gitsigns'.toggle_deleted()
end

function M.toggle_numhl()
  require 'gitsigns'.toggle_numhl()
end

function M.toggle_linehl()
  require 'gitsigns'.toggle_linehl()
end

function M.toggle_signs()
  require 'gitsigns'.toggle_signs()
end

function M.toggle_word_diff()
  local temp = require 'gitsigns'.toggle_word_diff()
  if temp == false then
    word_diff_en = 0
  else
    word_diff_en = 1
  end
end

------

function M.lazygit()
  B.system_run('start', 'lazygit')
end

-- mapping
function M.gitsigns_opt(desc)
  return { silent = true, desc = M.lua .. '.signs: ' .. desc, }
end

vim.keymap.set({ 'n', }, '<leader>gd', M.diffthis, M.gitsigns_opt 'diffthis')

vim.keymap.set({ 'n', }, '<leader>gmd', M.diffthis_l, M.gitsigns_opt 'diffthis_l')

vim.keymap.set({ 'n', }, '<leader>gr', M.reset_hunk, M.gitsigns_opt 'reset_hunk')
vim.keymap.set({ 'v', }, '<leader>gr', M.reset_hunk_v, M.gitsigns_opt 'reset_hunk_v')
vim.keymap.set({ 'n', }, '<leader>gmr', M.reset_buffer, M.gitsigns_opt 'reset_buffer')

vim.keymap.set({ 'n', }, '<leader>gs', M.stage_hunk, M.gitsigns_opt 'stage_hunk')
vim.keymap.set({ 'v', }, '<leader>gs', M.stage_hunk_v, M.gitsigns_opt 'stage_hunk_v')

vim.keymap.set({ 'n', }, '<leader>gms', M.stage_buffer, M.gitsigns_opt 'stage_buffer')
vim.keymap.set({ 'n', }, '<leader>gu', M.undo_stage_hunk, M.gitsigns_opt 'undo_stage_hunk')
vim.keymap.set({ 'n', }, '<leader>gmb', M.blame_line, M.gitsigns_opt 'blame_line')
vim.keymap.set({ 'n', }, '<leader>gmp', M.preview_hunk, M.gitsigns_opt 'preview_hunk')

vim.keymap.set({ 'n', }, '<leader>gmtb', M.toggle_current_line_blame, M.gitsigns_opt 'toggle_current_line_blame')
vim.keymap.set({ 'n', }, '<leader>gmtd', M.toggle_deleted, M.gitsigns_opt 'toggle_deleted')
vim.keymap.set({ 'n', }, '<leader>gmtl', M.toggle_linehl, M.gitsigns_opt 'toggle_linehl')
vim.keymap.set({ 'n', }, '<leader>gmtn', M.toggle_numhl, M.gitsigns_opt 'toggle_numhl')
vim.keymap.set({ 'n', }, '<leader>gmts', M.toggle_signs, M.gitsigns_opt 'toggle_signs')
vim.keymap.set({ 'n', }, '<leader>gmtw', M.toggle_word_diff, M.gitsigns_opt 'toggle_word_diff')

vim.keymap.set({ 'n', }, '<leader>gl', M.lazygit, M.gitsigns_opt 'lazygit')


return M
