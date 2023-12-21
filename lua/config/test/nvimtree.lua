local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

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

function M._c_tab()
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

function M.ausize_toggle()
  M.ausize_en = 1 - M.ausize_en
  print('ausize_en:', M.ausize_en)
end

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

M.init_root = vim.fn.getcwd()

M._change_root = function(path, bufnr)
  -- skip if current file is in ignore_list
  if type(bufnr) == 'number' then
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype') or ''
    for _, value in pairs(_config.update_focused_file.ignore_list) do
      if utils.str_find(path, value) or utils.str_find(ft, value) then
        return
      end
    end
  end
  -- don't find inexistent
  if vim.fn.filereadable(path) == 0 then
    return
  end
  local cwd = core.get_cwd()
  local vim_cwd = vim.fn.getcwd()
  -- test if in vim_cwd
  if utils.path_relative(path, vim_cwd) ~= path then
    if vim_cwd ~= cwd then
      change_dir.fn(vim_cwd)
    end
    return
  end
  -- test if in cwd
  if utils.path_relative(path, cwd) ~= path then
    return
  end
  -- otherwise test M.init_root
  if _config.prefer_startup_root and utils.path_relative(path, M.init_root) ~= path then
    change_dir.fn(M.init_root)
    return
  end
  -- otherwise root_dirs
  for _, dir in pairs(_config.root_dirs) do
    dir = vim.fn.fnamemodify(dir, ':p')
    if utils.path_relative(path, dir) ~= path then
      change_dir.fn(dir)
      return
    end
  end
  -- finally fall back to the folder containing the file
  -- change_dir.fn(vim.fn.fnamemodify(path, ":p:h"))
  change_dir.fn(vim.fn['ProjectRootGet'](path))
end

require 'nvim-tree'.change_root = M._change_root

function M._wrap_node(fn)
  return function(node, ...)
    node = node or require 'nvim-tree.lib'.get_node_at_cursor()
    fn(node, ...)
  end
end

-----------------------------------------------------
-- setup
-----------------------------------------------------

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
    { '<C-Tab>',       M._c_tab,                           mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Open Preview', },

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
    { '<MiddleMouse>', api.node.run.system,                mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run System', },
    { '<c-x>',         M._system_run_and_close,            mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run System', },
    { 'gx',            api.node.run.cmd,                   mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Run Command', },

    { 'f',             api.live_filter.start,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Filter', },
    { 'gf',            api.live_filter.clear,              mode = { 'n', }, buffer = bufnr, noremap = true, silent = true, nowait = true, desc = 'test.nvim: Clean Filter', },
  }
end

require 'nvim-tree'.setup {
  on_attach = M._on_attach,
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

B.create_user_command_with_M(M, 'NvimTree')

return M
