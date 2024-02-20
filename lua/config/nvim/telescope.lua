local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])

-- telescope
local telescope = require 'telescope'
local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

vim.api.nvim_create_autocmd({ 'User', }, {
  pattern = 'TelescopePreviewerLoaded',
  callback = function()
    vim.opt.number         = true
    vim.opt.relativenumber = true
    vim.opt.wrap           = true
  end,
})

function M.five_down()
  return {
    function(prompt_bufnr)
      for _ = 1, 5 do
        actions.move_selection_next(prompt_bufnr)
      end
    end,
    type = 'action',
    opts = { nowait = true, silent = true, desc = 'nvim.telescope: 5j', },
  }
end

function M.five_up()
  return {
    function(prompt_bufnr)
      for _ = 1, 5 do
        actions.move_selection_previous(prompt_bufnr)
      end
    end,
    type = 'action',
    opts = { nowait = true, silent = true, desc = 'nvim.telescope: 5k', },
  }
end

function M.setreg()
  vim.g.telescope_entered = true
  local bak = vim.fn.getreg '"'
  local save_cursor = vim.fn.getpos '.'
  local line = vim.fn.trim(vim.fn.getline '.')
  vim.g.curline = line
  if string.match(line, [[%']]) then
    vim.cmd "silent norm yi'"
    vim.g.single_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%"]]) then
    vim.cmd 'silent norm yi"'
    vim.g.double_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%`]]) then
    vim.cmd 'silent norm yi`'
    vim.g.back_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%)]]) then
    vim.cmd 'silent norm yi)'
    vim.g.parentheses = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, '%]') then
    vim.cmd 'silent norm yi]'
    vim.g.bracket = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%}]]) then
    vim.cmd 'silent norm yi}'
    vim.g.brace = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%>]]) then
    vim.cmd 'silent norm yi>'
    vim.g.angle_bracket = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  vim.fn.setreg('"', bak)
  B.set_timeout(4000, function()
    vim.g.telescope_entered = nil
  end)
end

function M.paste(command, desc)
  return { command, type = 'command', opts = { nowait = true, silent = true, desc = desc, }, }
end

B.aucmd({ 'BufLeave', }, 'nvim.telescope.BufLeave', {
  callback = function(ev)
    vim.g.last_buf = ev.buf
  end,
})

telescope.setup {
  defaults = {
    winblend = 10,
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_cutoff = 0,
        width = 0.92,
        height = 0.92,
      },
    },
    preview = {
      hide_on_startup = false,
      check_mime_type = true,
    },
    mappings = {
      i = {
        ['<C-c>'] = actions.close,
        ['<C-3>'] = actions.close,
        ['<C-q>'] = actions.close,

        ['<leader><leader>'] = actions.select_default,
        ['<C-a>'] = actions.select_default,
        ['<C-;>'] = actions.select_default,
        ['<C-1>'] = actions.select_default,
        ['<C-2>'] = actions.select_default,
        ['<C-,>'] = actions.select_default,
        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-Tab>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['<C-/>'] = actions.which_key,
        ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>

        ['<C-w>'] = { '<c-s-w>', type = 'command', },

        ['<c-g>'] = { function(prompt_bufnr) actions_layout.toggle_preview(prompt_bufnr) end, type = 'action', opts = { nowait = true, silent = true, desc = 'nvim.telescope: toggle_preview', }, },

        ['<C-s>'] = M.paste('<c-r>"', 'nvim.telescope.paste: "'),
        ['<C-=>'] = M.paste([[<c-r>=trim(getreg("+"))<cr>]], 'nvim.telescope.paste: +'),

        ['<C-b>'] = M.paste('<c-r>=bufname(g:last_buf)<cr>', 'nvim.telescope.paste: bufname'),
        ['<C-n>'] = M.paste('<c-r>=fnamemodify(bufname(g:last_buf), ":h")<cr>', 'nvim.telescope.paste: bufname'),

        ['<C-l>'] = M.paste('<c-r>=g:curline<cr>', 'nvim.telescope.paste: cur line'),

        ['<C-\'>'] = M.paste('<c-r>=g:single_quote<cr>', "nvim.telescope.paste: in ''"),
        ['<C-">'] = M.paste('<c-r>=g:double_quote<cr>', 'nvim.telescope.paste: in ""'),
        ['<C-0>'] = M.paste('<c-r>=g:parentheses<cr>', 'nvim.telescope.paste: in ()'),
        ['<C-]>'] = M.paste('<c-r>=g:bracket<cr>', 'nvim.telescope.paste: in []'),
        ['<C-S-]>'] = M.paste('<c-r>=g:brace<cr>', 'nvim.telescope.paste: in {}'),
        ['<C-`>'] = M.paste('<c-r>=g:back_quote<cr>', 'nvim.telescope.paste: in ``'),
        ['<C-S-.>'] = M.paste('<c-r>=g:angle_bracket<cr>', 'nvim.telescope.paste: in <>'),

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,
        ['<A-j>'] = actions.move_selection_next,
        ['<A-k>'] = actions.move_selection_previous,
        ['<ScrollWheelDown>'] = actions.move_selection_next,
        ['<ScrollWheelUp>'] = actions.move_selection_previous,

        ['<A-s-j>'] = M.five_down(),
        ['<A-s-k>'] = M.five_up(),
        ['<C-j>'] = M.five_down(),
        ['<C-k>'] = M.five_up(),
        ['<PageDown>'] = M.five_down(),
        ['<PageUp>'] = M.five_up(),

        ['<LeftMouse>'] = actions.select_default,
        ['<RightMouse>'] = actions_layout.toggle_preview,
        ['<MiddleMouse>'] = actions.close,
      },
      n = {
        ['q'] = actions.close,
        ['<C-3>'] = actions.close,
        ['<C-q>'] = actions.close,
        ['<esc>'] = actions.close,

        ['<CR>'] = actions.select_default,
        ['<C-;>'] = actions.select_default,
        ['<C-1>'] = actions.select_default,
        ['<C-2>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-Tab>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['j'] = actions.move_selection_next,
        ['k'] = actions.move_selection_previous,
        ['H'] = actions.move_to_top,
        ['M'] = actions.move_to_middle,
        ['L'] = actions.move_to_bottom,

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,
        ['gg'] = actions.move_to_top,
        ['G'] = actions.move_to_bottom,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['?'] = actions.which_key,

        ['<leader>'] = { function(prompt_bufnr) actions.select_default(prompt_bufnr) end, type = 'action', opts = { nowait = true, silent = true, desc = 'nvim.telescope: select_default', }, },

        ['<c-g>'] = { function(prompt_bufnr) actions_layout.toggle_preview(prompt_bufnr) end, type = 'action', opts = { nowait = true, silent = true, desc = 'nvim.telescope: toggle_preview', }, },

        ['<c-j>'] = M.five_down(),
        ['<c-k>'] = M.five_up(),
        ['<PageDown>'] = M.five_down,
        ['<PageUp>'] = M.five_up,

        ['<ScrollWheelDown>'] = actions.move_selection_next,
        ['<ScrollWheelUp>'] = actions.move_selection_previous,
        ['<LeftMouse>'] = actions.select_default,
        ['<RightMouse>'] = actions_layout.toggle_preview,
        ['<MiddleMouse>'] = actions.close,
      },
    },
    file_ignore_patterns = {
      '%.svn',
      '%.bak',
      'obj',
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--no-ignore',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--fixed-strings',
    },
    wrap_results = true,
    -- initial_mode = 'insert',
  },
}

-- git_diffs
telescope.load_extension 'git_diffs'

-- ui-select
telescope.load_extension 'ui-select'

-- projects
telescope.load_extension 'projects'

require 'project_nvim'.setup {
  manual_mode = false,
  detection_methods = { 'pattern', 'lsp', },
  patterns = { '.git', },
}

-- sel root
M.cur_root = {}

function M.cur_root_sel_do(dir)
  M.cur_root[B.rep_backslash_lower(vim.fn['ProjectRootGet'](dir))] = B.rep_backslash_lower(dir)
end

function M.root_sel()
  local dirs = B.get_file_dirs()
  if dirs and #dirs == 1 then
    M.cur_root_sel_do(dirs[1])
  else
    B.ui_sel(dirs, 'sel as telescope root', function(dir)
      if dir then
        M.cur_root_sel_do(dir)
      end
    end)
  end
end

function M.root_sel_till_git()
  local dirs = B.get_file_dirs_till_git()
  if dirs and #dirs == 1 then
    M.cur_root_sel_do(dirs[1])
  else
    B.ui_sel(dirs, 'sel as telescope root', function(dir)
      if dir then
        M.cur_root_sel_do(dir)
      end
    end)
  end
end

function M.root_sel_scan_dirs()
  local dirs = B.scan_dirs()
  if dirs and #dirs == 1 then
    M.cur_root_sel_do(dirs[1])
  else
    B.ui_sel(dirs, 'sel as telescope root', function(dir)
      if dir then
        M.cur_root_sel_do(dir)
      end
    end)
  end
end

function M.projects_do()
  M.setreg()
  vim.cmd 'Telescope projects'
end

function M.projects()
  M.projects_do()
  vim.cmd [[call feedkeys("\<esc>\<esc>")]]
  B.lazy_map {
    { '<leader>sk', M.projects_do, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: projects', },
  }
  vim.fn.timer_start(20, function()
    vim.cmd [[call feedkeys(":Telescope projects\<cr>")]]
  end)
end

-- builtins
function M.buffers_all()
  M.setreg()
  local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    local cmd = B.format('Telescope buffers cwd=%s', M.cur_root[root_dir])
    B.cmd((cmd))
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope buffers'
  end
end

function M.buffers_cur()
  M.setreg()
  vim.cmd 'Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true'
end

function M.find_files_all()
  vim.cmd 'Telescope find_files find_command=fd,--no-ignore,--hidden'
end

function M.find_files()
  M.setreg()
  local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    local cmd = B.format('Telescope find_files cwd=%s', M.cur_root[root_dir])
    B.cmd((cmd))
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope find_files'
  end
end

function M.oldfiles()
  M.setreg()
  vim.cmd 'Telescope oldfiles'
end

function M.live_grep()
  M.setreg()
  local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    local cmd = B.format('Telescope live_grep cwd=%s', M.cur_root[root_dir])
    B.cmd((cmd))
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope live_grep'
  end
end

function M.everything()
  M.setreg()
  local search = vim.fn.input 'Everything: '
  if B.is(search) then
    B.system_run('start silent', 'Everything.exe -noregex -search %s', search)
  end
end

function M.everything_regex()
  M.setreg()
  local search = vim.fn.input 'Everything: '
  if B.is(search) then
    B.system_run('start silent', 'Everything.exe -regex -search %s', search)
  end
end

function M.search_history()
  M.setreg()
  vim.cmd 'Telescope search_history'
end

function M.command_history()
  M.setreg()
  vim.cmd 'Telescope command_history'
end

function M.commands()
  M.setreg()
  vim.cmd 'Telescope commands'
end

function M.jumplist()
  M.setreg()
  vim.cmd 'Telescope jumplist show_line=false'
end

function M.diagnostics()
  M.setreg()
  vim.cmd 'Telescope diagnostics'
end

function M.filetypes()
  M.setreg()
  vim.cmd 'Telescope filetypes'
end

function M.quickfix()
  M.setreg()
  vim.cmd 'Telescope quickfix'
end

function M.quickfixhistory()
  M.setreg()
  vim.cmd 'Telescope quickfixhistory'
end

function M.builtin()
  M.setreg()
  vim.cmd 'Telescope builtin'
end

function M.autocommands()
  M.setreg()
  vim.cmd 'Telescope autocommands'
end

function M.colorscheme()
  M.setreg()
  vim.cmd 'Telescope colorscheme'
end

function M.git_branches()
  M.setreg()
  vim.cmd 'Telescope git_branches'
end

function M.git_commits()
  M.setreg()
  vim.cmd 'Telescope git_commits'
end

function M.git_bcommits()
  M.setreg()
  vim.cmd 'Telescope git_bcommits'
end

function M.lsp_document_symbols()
  M.setreg()
  vim.cmd 'Telescope lsp_document_symbols previewer=true'
end

function M.lsp_references()
  M.setreg()
  vim.cmd 'Telescope lsp_references previewer=true'
end

function M.help_tags()
  M.setreg()
  vim.cmd 'Telescope help_tags'
end

function M.vim_options()
  M.setreg()
  vim.cmd 'Telescope vim_options'
end

function M.grep_string()
  M.setreg()
  local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true cwd=%s', M.cur_root[root_dir])
    B.cmd((cmd))
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true'
  end
end

function M.keymaps()
  M.setreg()
  vim.cmd 'Telescope keymaps'
end

function M.git_status()
  M.setreg()
  vim.cmd 'Telescope git_status'
end

function M.buffers()
  M.setreg()
  vim.cmd 'Telescope buffers'
end

-- terminal

function M.terminal_cmd()
  M.setreg()
  vim.cmd 'Telescope buffers previewer=true'
  B.set_timeout(20, function()
    vim.cmd [[call feedkeys("term:cmd\<esc>")]]
  end)
end

function M.terminal_ipython()
  M.setreg()
  vim.cmd 'Telescope buffers previewer=true'
  B.set_timeout(20, function()
    vim.cmd [[call feedkeys("term:ipython\<esc>")]]
  end)
end

function M.terminal_bash()
  M.setreg()
  vim.cmd 'Telescope buffers previewer=true'
  B.set_timeout(20, function()
    vim.cmd [[call feedkeys("term:bash\<esc>")]]
  end)
end

function M.terminal_powershell()
  M.setreg()
  vim.cmd 'Telescope buffers previewer=true'
  B.set_timeout(20, function()
    vim.cmd [[call feedkeys("term:powershell\<esc>")]]
  end)
end

function M.open_telescope_lua()
  B.cmd('e %s', M.source)
  vim.cmd 'norm gg'
  vim.fn.search 'file_ignore_patterns'
end

function M.nop() end

-- mappings
B.del_map({ 'n', 'v', }, '<leader>s')
B.del_map({ 'n', 'v', }, '<leader>f')
B.del_map({ 'n', 'v', }, '<leader>g')
B.del_map({ 'n', 'v', }, '<leader>gt')
B.del_map({ 'n', 'v', }, '<leader>sv')
B.del_map({ 'n', 'v', }, '<leader>svv')

require 'which-key'.register { ['<leader>s'] = { name = 'nvim.telescope', }, }
require 'which-key'.register { ['<leader>f'] = { name = 'nvim.telescope.lsp', }, }
require 'which-key'.register { ['<leader>g'] = { name = 'nvim.telescope.git', }, }
require 'which-key'.register { ['<leader>gt'] = { name = 'nvim.telescope.git.more', }, }
require 'which-key'.register { ['<leader>sv'] = { name = 'nvim.telescope.more', }, }
require 'which-key'.register { ['<leader>svv'] = { name = 'nvim.telescope.more', }, }

B.lazy_map {
  -- builtins
  { '<leader>s<leader>', function() M.find_files_all() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_all', },
  { '<leader>sd',        function() M.diagnostics() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: diagnostics', },
  { '<leader>s<c-f>',    function() M.filetypes() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: filetypes', },
  { '<leader>sh',        function() M.search_history() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: search_history', },
  { '<leader>sj',        function() M.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: jumplist', },
  { '<leader>sm',        function() M.keymaps() end,              mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: keymaps', },
  { '<leader>sr',        function() M.root_sel_till_git() end,    mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: root_sel_till_git', },
  { '<leader>sR',        function() M.root_sel_scan_dirs() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: root_sel_scan_dirs', },
  { '<leader>s<c-r>',    function() M.root_sel() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: root_sel', },
  { '<leader>sq',        function() M.quickfix() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: quickfix', },
  { '<leader>svq',       function() M.quickfixhistory() end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: quickfixhistory', },
  { '<leader>ss',        function() M.grep_string() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string', },
  { '<leader>svvc',      function() M.colorscheme() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: colorscheme', },
  { '<leader>svh',       function() M.help_tags() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: help_tags', },
  { '<leader>sva',       function() M.autocommands() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: autocommands', },
  { '<leader>svva',      function() M.builtin() end,              mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: builtin', },
  { '<leader>svo',       function() M.vim_options() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: vim_options', },
  -- mouse
  { '<c-s-f12><f1>',     function() M.git_status() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: git_status', },
  { '<c-s-f12><f2>',     function() M.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers_cur', },
  { '<c-s-f12><f3>',     function() M.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
  { '<c-s-f12><f4>',     function() M.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: jumplist', },
  { '<c-s-f12><f6>',     function() M.command_history() end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: command_history', },
  { '<c-s-f12><f7>',     function() M.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: document_symbols', },
  { '<c-s-f12><f8>',     function() M.buffers() end,              mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers', },
  { '<c-s-f12><f1>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f2>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f3>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f4>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f6>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f7>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f8>',     function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  -- git
  { '<leader>gtb',       function() M.git_bcommits() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: bcommits', },
  { '<leader>gtc',       function() M.git_commits() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: commits', },
  -- terminal
  { '<leader>stc',       function() M.terminal_cmd() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.terminal: cmd', },
  { '<leader>sti',       function() M.terminal_ipython() end,     mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.terminal: ipython', },
  { '<leader>stb',       function() M.terminal_bash() end,        mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.terminal: bash', },
  { '<leader>stp',       function() M.terminal_powershell() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.terminal: powershell', },
  -- open telescope.lua
  { '<leader>sO',        function() M.open_telescope_lua() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: open telescope.lua', },
}

B.aucmd({ 'BufEnter', }, 'nvim.telescope.BufEnter', {
  callback = function(ev)
    local filetype = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if filetype == '' and buftype == '' and bufname == '' then
      vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'nofile')
    end
  end,
})

return M
