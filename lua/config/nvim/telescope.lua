local M = {}

local B = require 'base'

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
B.lazy_map {
  { '<esc>', function() require 'notify'.dismiss() end, mode = { 'n', }, silent = true, desc = 'notify dismiss notification', },
}

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

        ['<C-m>'] = actions.select_default,
        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['<C-/>'] = actions.which_key,
        ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>

        ['<C-w>'] = { '<c-s-w>', type = 'command', },

        ['<F5>'] = actions_layout.toggle_preview,

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
        ['<esc>'] = actions.close,

        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
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

        ['<leader>'] = actions.select_default,

        ['<F5>'] = actions_layout.toggle_preview,

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
    file_ignore_patterns = {}, -- { '%.svn', 'obj', },
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
  vim.cmd 'Telescope buffers'
end

function M.buffers_cur()
  M.setreg()
  vim.cmd 'Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true'
end

function M.find_files()
  M.setreg()
  vim.cmd 'Telescope find_files'
end

function M.live_grep()
  M.setreg()
  vim.cmd 'Telescope live_grep'
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
  vim.cmd 'Telescope lsp_document_symbols'
end

function M.lsp_references()
  M.setreg()
  vim.cmd 'Telescope lsp_references'
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
  vim.cmd 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true'
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
  { '<leader>sd',     function() M.diagnostics() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: diagnostics', },
  { '<leader>s<c-f>', function() M.filetypes() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: filetypes', },
  { '<leader>sh',     function() M.search_history() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: search_history', },
  { '<leader>sj',     function() M.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: jumplist', },
  { '<leader>sm',     function() M.keymaps() end,              mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: keymaps', },
  { '<leader>sq',     function() M.quickfix() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: quickfix', },
  { '<leader>svq',    function() M.quickfixhistory() end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: quickfixhistory', },
  { '<leader>ss',     function() M.grep_string() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string', },
  { '<leader>svvc',   function() M.colorscheme() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: colorscheme', },
  { '<leader>svh',    function() M.help_tags() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: help_tags', },
  { '<leader>sva',    function() M.autocommands() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: autocommands', },
  { '<leader>svva',   function() M.builtin() end,              mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: builtin', },
  { '<leader>svo',    function() M.vim_options() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: vim_options', },
  -- mouse
  { '<c-s-f12><f1>',  function() M.git_status() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: git_status', },
  { '<c-s-f12><f2>',  function() M.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers_cur', },
  { '<c-s-f12><f3>',  function() M.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
  { '<c-s-f12><f4>',  function() M.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: jumplist', },
  { '<c-s-f12><f6>',  function() M.command_history() end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: command_history', },
  { '<c-s-f12><f7>',  function() M.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: document_symbols', },
  { '<c-s-f12><f8>',  function() M.buffers() end,              mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers', },
  { '<c-s-f12><f1>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f2>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f3>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f4>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f6>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f7>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  { '<c-s-f12><f8>',  function() M.nop() end,                  mode = { 'i', },      silent = true, desc = 'nvim.telescope: nop', },
  -- git
  { '<leader>gtb',    function() M.git_bcommits() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: bcommits', },
  { '<leader>gtc',    function() M.git_commits() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: commits', },
}

return M
