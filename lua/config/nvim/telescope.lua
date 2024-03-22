local M = {}

local B = require 'base'

if not B.commands then
  B.create_user_command_with_M(BaseCommand())
end

M.source = B.getsource(debug.getinfo(1)['source'])

vim.cmd 'Lazy load nvim-notify'

-- telescope
local telescope = require 'telescope'
local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

function M.toggle_result_wrap()
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    local wrap = B.toggle_value(vim.api.nvim_win_get_option(vim.fn.win_getid(winnr), 'wrap'))
    if vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'TelescopeResults' then
      vim.api.nvim_win_set_option(vim.fn.win_getid(winnr), 'wrap', wrap)
    end
  end
end

vim.api.nvim_create_autocmd({ 'User', }, {
  pattern = 'TelescopePreviewerLoaded',
  callback = function()
    vim.opt.number         = true
    vim.opt.relativenumber = true
    vim.opt.wrap           = true
    B.lazy_map {
      { '<bs>',   M.toggle_result_wrap, mode = { 'n', }, silent = true, desc = 'telescope: toggle result wrap', },
      { '<c-bs>', M.toggle_result_wrap, mode = { 'i', }, silent = true, desc = 'telescope: toggle result wrap', },
    }
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
        ['<C-1>'] = actions.select_default,
        ['<C-2>'] = actions.select_default,
        ['<C-;>'] = actions.select_default,
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
        ['<C-h>'] = M.paste('<c-r>=fnamemodify(bufname(g:last_buf), ":h")<cr>', 'nvim.telescope.paste: bufname head'),
        ['<C-n>'] = M.paste('<c-r>=fnamemodify(bufname(g:last_buf), ":t")<cr>', 'nvim.telescope.paste: bufname tail'),

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
        ['dj'] = actions.select_horizontal,
        ['dl'] = actions.select_vertical,
        ['dk'] = actions.select_tab,

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
telescope.load_extension 'my_projects'

require 'project_nvim'.setup {
  manual_mode = false,
  detection_methods = { 'pattern', 'lsp', },
  patterns = { '.git', },
}

-- sel root
M.telescope_cur_root_dir_path = B.getcreate_stddata_dirpath 'telescope-cur-root'
M.telescope_cur_root_txt_path = M.telescope_cur_root_dir_path:joinpath 'telescope-cur-root.txt'
M.telescope_cur_roots_txt_path = M.telescope_cur_root_dir_path:joinpath 'telescope-cur-roots.txt'

if not M.telescope_cur_root_txt_path:exists() then
  M.telescope_cur_root_txt_path:write(vim.inspect {}, 'w')
end

if not M.telescope_cur_roots_txt_path:exists() then
  M.telescope_cur_roots_txt_path:write(vim.inspect {}, 'w')
end

M.cur_root = B.read_table_from_file(M.telescope_cur_root_txt_path.filename)

M.cur_roots = B.read_table_from_file(M.telescope_cur_roots_txt_path.filename)

B.aucmd({ 'VimLeave', }, 'nvim.telescope.VimLeave', {
  callback = function()
    M.telescope_cur_root_txt_path:write(vim.inspect(M.cur_root), 'w')
    M.telescope_cur_roots_txt_path:write(vim.inspect(M.cur_roots), 'w')
  end,
})

function M.cur_root_sel_do(dir)
  local cwd = B.rep_backslash_lower(vim.fn['ProjectRootGet'](dir))
  dir = B.rep_backslash_lower(dir)
  require 'config.test.nvimtree'.dirs_append(dir)
  M.cur_root[B.rep_backslash_lower(cwd)] = dir
  if not M.cur_roots[B.rep_backslash_lower(cwd)] then
    M.cur_roots[B.rep_backslash_lower(cwd)] = {}
  end
  B.stack_item_uniq(M.cur_roots[B.rep_backslash_lower(cwd)], cwd)
  B.stack_item_uniq(M.cur_roots[B.rep_backslash_lower(cwd)], dir)
  B.notify_info_append(dir)
end

function M.root_sel_switch()
  local cwd = B.rep_backslash_lower(vim.fn['ProjectRootGet'](B.buf_get_name_0()))
  local dirs = M.cur_roots[cwd]
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

function M.root_sel_parennt_dirs()
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
  vim.cmd 'Telescope my_projects'
end

function M.projects()
  M.projects_do()
  vim.cmd [[call feedkeys("\<esc>\<esc>")]]
  B.lazy_map {
    { '<leader>sk', M.projects_do, mode = { 'n', 'v', }, silent = true, desc = 'telescope: all projects opened', },
  }
  vim.fn.timer_start(20, function()
    vim.cmd [[call feedkeys(":Telescope my_projects\<cr>")]]
  end)
end

-- builtins
function M.buffers_all()
  M.setreg()
  local root_dir = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    local cmd = B.format('Telescope buffers cwd=%s', M.cur_root[root_dir])
    B.cmd(cmd)
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
    B.cmd(cmd)
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope find_files'
  end
end

function M.find_files_curdir()
  M.setreg()
  local cmd = B.format('Telescope find_files cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.find_files_pardir()
  M.setreg()
  local cmd = B.format('Telescope find_files cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.find_files_pardir_2()
  M.setreg()
  local cmd = B.format('Telescope find_files cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.find_files_pardir_3()
  M.setreg()
  local cmd = B.format('Telescope find_files cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.find_files_pardir_4()
  M.setreg()
  local cmd = B.format('Telescope find_files cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.find_files_pardir_5()
  M.setreg()
  local cmd = B.format('Telescope find_files cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
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
    B.cmd(cmd)
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope live_grep'
  end
end

function M.live_grep_curdir()
  M.setreg()
  local cmd = B.format('Telescope live_grep cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.live_grep_pardir()
  M.setreg()
  local cmd = B.format('Telescope live_grep cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.live_grep_pardir_2()
  M.setreg()
  local cmd = B.format('Telescope live_grep cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.live_grep_pardir_3()
  M.setreg()
  local cmd = B.format('Telescope live_grep cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.live_grep_pardir_4()
  M.setreg()
  local cmd = B.format('Telescope live_grep cwd=%s', vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h:h'))
  B.cmd(cmd)
  B.notify_info(cmd)
end

function M.pure_curdir_do(dir)
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = true, depth = 1, add_dirs = true, only_dirs = true, })
  if #entries > 0 then
    B.ui_sel(entries, 'sel one to find_files', function(d)
      if not d or not B.file_exists(d) then
        return
      end
      local cmd = B.format('Telescope find_files cwd=%s', d)
      B.cmd(cmd)
      B.notify_info(cmd)
    end)
  else
    local cmd = B.format('Telescope find_files cwd=%s', dir)
    B.cmd(cmd)
    B.notify_info(cmd)
  end
end

function M.pure_curdir()
  M.setreg()
  M.pure_curdir_do(vim.fn.fnamemodify(B.buf_get_name_0(), ':h'))
end

function M.pure_pardir()
  M.setreg()
  M.pure_curdir_do(vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h'))
end

function M.pure_pardir_2()
  M.setreg()
  M.pure_curdir_do(vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h'))
end

function M.pure_pardir_3()
  M.setreg()
  M.pure_curdir_do(vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h'))
end

function M.pure_pardir_4()
  M.setreg()
  M.pure_curdir_do(vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h:h'))
end

function M.pure_pardir_5()
  M.setreg()
  M.pure_curdir_do(vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h:h:h'))
end

function M.everything()
  M.setreg()
  local search = vim.fn.input 'Everything -noregex: '
  if B.is(search) then
    B.system_run('start silent', 'Everything.exe -noregex -search %s', search)
  end
end

function M.everything_regex()
  M.setreg()
  local search = vim.fn.input 'Everything -regex: '
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
    local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= cwd=%s', M.cur_root[root_dir])
    B.cmd(cmd)
    B.notify_info(cmd)
  else
    vim.cmd 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search='
  end
end

function M.grep_string_curdir()
  M.setreg()
  local dir = vim.fn.fnamemodify(B.buf_get_name_0(), ':h')
  local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= cwd=%s',
    dir)
  B.cmd(cmd)
  B.notify_info('Telescope grep_string cwd=' .. dir)
end

function M.grep_string_pardir()
  M.setreg()
  local dir = vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h')
  local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= cwd=%s',
    dir)
  B.cmd(cmd)
  B.notify_info('Telescope grep_string cwd=' .. dir)
end

function M.grep_string_pardir_2()
  M.setreg()
  local dir = vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h')
  local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= cwd=%s',
    dir)
  B.cmd(cmd)
  B.notify_info('Telescope grep_string cwd=' .. dir)
end

function M.grep_string_pardir_3()
  M.setreg()
  local dir = vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h')
  local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= cwd=%s',
    dir)
  B.cmd(cmd)
  B.notify_info('Telescope grep_string cwd=' .. dir)
end

function M.grep_string_pardir_4()
  M.setreg()
  local dir = vim.fn.fnamemodify(B.buf_get_name_0(), ':h:h:h:h:h')
  local cmd = B.format('Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= cwd=%s',
    dir)
  B.cmd(cmd)
  B.notify_info('Telescope grep_string cwd=' .. dir)
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
  B.jump_or_edit(M.source)
  vim.cmd 'norm gg'
  vim.fn.search 'file_ignore_patterns'
end

function M.nop() end

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

function M.map()
  require 'which-key'.register {
    ['<leader>s'] = { name = 'telescope', },
    ['<leader>sv'] = { name = 'telescope.more', },
    ['<leader>svv'] = { name = 'telescope.more', },
    ['<leader>st'] = { name = 'telescope.terminal', },
    ['<c-s-f12>'] = { name = 'telescope', },
    ['<leader>s<leader>'] = { function() require 'config.nvim.telescope'.find_files_all() end, 'telescope: find_files_all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sd'] = { function() require 'config.nvim.telescope'.diagnostics() end, 'telescope: diagnostics', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-f>'] = { function() require 'config.nvim.telescope'.filetypes() end, 'telescope: filetypes', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sR'] = { function() require 'config.nvim.telescope'.root_sel_scan_dirs() end, 'telescope: root_sel_scan_dirs', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<a-r>'] = { function() require 'config.nvim.telescope'.root_sel_parennt_dirs() end, 'telescope: root_sel_parennt_dirs', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sq'] = { function() require 'config.nvim.telescope'.quickfix() end, 'telescope: quickfix', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svq'] = { function() require 'config.nvim.telescope'.quickfixhistory() end, 'telescope: quickfixhistory', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svvc'] = { function() require 'config.nvim.telescope'.colorscheme() end, 'telescope: colorscheme', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svh'] = { function() require 'config.nvim.telescope'.help_tags() end, 'telescope: help_tags', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sva'] = { function() require 'config.nvim.telescope'.autocommands() end, 'telescope: autocommands', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svva'] = { function() require 'config.nvim.telescope'.builtin() end, 'telescope: builtin', mode = { 'n', 'v', }, silent = true, },
    ['<leader>svo'] = { function() require 'config.nvim.telescope'.vim_options() end, 'telescope: vim_options', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-r>'] = { function() require 'config.nvim.telescope'.root_sel_switch() end, 'telescope: root sel_switch', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sO'] = { function() require 'config.nvim.telescope'.open_telescope_lua() end, 'telescope: open telescope.lua', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sh'] = { function() require 'config.nvim.telescope'.search_history() end, 'telescope: search_history', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sj'] = { function() require 'config.nvim.telescope'.jumplist() end, 'telescope: jumplist', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sk'] = { function() require 'config.nvim.telescope'.projects() end, 'telescope: projects', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sm'] = { function() require 'config.nvim.telescope'.keymaps() end, 'telescope: keymaps', mode = { 'n', 'v', }, silent = true, },
    ['<leader>so'] = { function() require 'config.nvim.telescope'.oldfiles() end, 'telescope: oldfiles', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sr'] = { function() require 'config.nvim.telescope'.root_sel_till_git() end, 'telescope: root sel till git', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>stc'] = { function() require 'config.nvim.telescope'.terminal_cmd() end, 'create terminal: cmd', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sti'] = { function() require 'config.nvim.telescope'.terminal_ipython() end, 'create terminal: ipython', mode = { 'n', 'v', }, silent = true, },
    ['<leader>stb'] = { function() require 'config.nvim.telescope'.terminal_bash() end, 'create terminal: bash', mode = { 'n', 'v', }, silent = true, },
    ['<leader>stp'] = { function() require 'config.nvim.telescope'.terminal_powershell() end, 'create terminal: powershell', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader>ss'] = { function() require 'config.nvim.telescope'.grep_string() end, 'telescope: grep string in current project', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-s>'] = { function() require 'config.nvim.telescope'.grep_string_curdir() end, 'telescope: grep string curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>sS'] = { function() require 'config.nvim.telescope'.grep_string_pardir() end, 'telescope: grep string pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<c-s-s>'] = { function() require 'config.nvim.telescope'.grep_string_pardir_2() end, 'telescope: grep string pardir 2', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<a-s>'] = { function() require 'config.nvim.telescope'.grep_string_pardir_3() end, 'telescope: grep string pardir 3', mode = { 'n', 'v', }, silent = true, },
    ['<leader>s<a-s-s>'] = { function() require 'config.nvim.telescope'.grep_string_pardir_4() end, 'telescope: grep string pardir 4', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<c-s-f12><f1>'] = { function() require 'config.nvim.telescope'.git_status() end, 'telescope: find files in current project git modified', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f2>'] = { function() require 'config.nvim.telescope'.buffers_cur() end, 'telescope: buffers_cur', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f3>'] = { function() require 'config.nvim.telescope'.find_files() end, 'telescope: find_files', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f4>'] = { function() require 'config.nvim.telescope'.jumplist() end, 'telescope: jumplist', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f6>'] = { function() require 'config.nvim.telescope'.command_history() end, 'telescope: command_history', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f7>'] = { function() require 'config.nvim.telescope'.lsp_document_symbols() end, 'telescope.lsp: document_symbols', mode = { 'n', 'v', }, silent = true, },
    ['<c-s-f12><f8>'] = { function() require 'config.nvim.telescope'.buffers() end, 'telescope: buffers', mode = { 'n', 'v', }, silent = true, },
  }
  require 'which-key'.register {
    ['<c-s-f12><f1>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f2>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f3>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f4>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f6>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f7>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
    ['<c-s-f12><f8>'] = { function() require 'config.nvim.telescope'.nop() end, 'telescope: nop', mode = { 'i', }, silent = true, },
  }
  require 'which-key'.register {
    ['<leader><c-f>'] = { function() require 'config.nvim.telescope'.git_status() end, 'telescope: find files in current project git modified', mode = { 'n', 'v', }, silent = true, },
    ['<leader><leader>'] = { function() require 'config.nvim.telescope'.find_files() end, 'telescope: find files in current project', mode = { 'n', 'v', }, silent = true, },
    ['<leader>m'] = { function() require 'config.nvim.telescope'.find_files_curdir() end, 'telescope: find files curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir() end, 'telescope: find files pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>M'] = { function() require 'config.nvim.telescope'.find_files_pardir_2() end, 'telescope: find files pardir_2', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir_3() end, 'telescope: find files pardir_3', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir_4() end, 'telescope: find files pardir_4', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-s-m>'] = { function() require 'config.nvim.telescope'.find_files_pardir_5() end, 'telescope: find files pardir_5', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-b>'] = { function() require 'config.nvim.telescope'.buffers_all() end, 'telescope: buffers in all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>b'] = { function() require 'config.nvim.telescope'.buffers_cur() end, 'telescope: buffers in current project', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-e>'] = { function() require 'config.nvim.telescope'.everything_regex() end, 'telescope: everything.exe -regex', mode = { 'n', 'v', }, silent = true, },
    ['<leader>e'] = { function() require 'config.nvim.telescope'.everything() end, 'telescope: everything.exe -noregex', mode = { 'n', 'v', }, silent = true, },
    ['<leader>h'] = { function() require 'config.nvim.telescope'.command_history() end, 'telescope: command history', mode = { 'n', 'v', }, silent = true, },
    ['<leader>n'] = { function() require 'config.nvim.telescope'.commands() end, 'telescope: command all', mode = { 'n', 'v', }, silent = true, },
    ['<leader>l'] = { function() require 'config.nvim.telescope'.live_grep() end, 'telescope: live grep', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-l>'] = { function() require 'config.nvim.telescope'.live_grep_curdir() end, 'telescope: live grep curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>L'] = { function() require 'config.nvim.telescope'.live_grep_pardir() end, 'telescope: live grep pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-l>'] = { function() require 'config.nvim.telescope'.live_grep_pardir_2() end, 'telescope: live grep pardir2', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-l>'] = { function() require 'config.nvim.telescope'.live_grep_pardir_3() end, 'telescope: live grep pardir3', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-s-l>'] = { function() require 'config.nvim.telescope'.live_grep_pardir_4() end, 'telescope: live grep pardir4', mode = { 'n', 'v', }, silent = true, },
    ['<leader>p'] = { function() require 'config.nvim.telescope'.pure_curdir() end, 'telescope: pure curdir', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-p>'] = { function() require 'config.nvim.telescope'.pure_pardir() end, 'telescope: pure pardir', mode = { 'n', 'v', }, silent = true, },
    ['<leader>P'] = { function() require 'config.nvim.telescope'.pure_pardir_2() end, 'telescope: pure pardir 2', mode = { 'n', 'v', }, silent = true, },
    ['<leader><c-s-p>'] = { function() require 'config.nvim.telescope'.pure_pardir_3() end, 'telescope: pure pardir 3', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-p>'] = { function() require 'config.nvim.telescope'.pure_pardir_4() end, 'telescope: pure pardir 4', mode = { 'n', 'v', }, silent = true, },
    ['<leader><a-s-p>'] = { function() require 'config.nvim.telescope'.pure_pardir_5() end, 'telescope: pure pardir 5', mode = { 'n', 'v', }, silent = true, },
  }
end

L(M, M.map)

return M
