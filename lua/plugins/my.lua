return {

  -- my.window
  {
    name = 'my.window',
    dir = '',
    keys = {
      { '<a-h>',   function() vim.cmd 'wincmd <' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less_1', },
      { '<a-l>',   function() vim.cmd 'wincmd >' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more_1', },
      { '<a-j>',   function() vim.cmd 'wincmd -' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less_1', },
      { '<a-k>',   function() vim.cmd 'wincmd +' end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more_1', },
      { '<a-s-h>', function() vim.cmd '10wincmd <' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less_10', },
      { '<a-s-l>', function() vim.cmd '10wincmd >' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more_10', },
      { '<a-s-j>', function() vim.cmd '10wincmd -' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less_10', },
      { '<a-s-k>', function() vim.cmd '10wincmd +' end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more_10', },
    },
  },

  -- my.options
  {
    name = 'my.options',
    dir = '',
    event = 'VeryLazy',
    config = function()
      vim.opt.number         = true
      vim.opt.numberwidth    = 1
      vim.opt.relativenumber = true
      vim.opt.title          = true
      vim.opt.winminheight   = 1
      vim.opt.winminwidth    = 1
      vim.opt.expandtab      = true
      vim.opt.cindent        = true
      vim.opt.smartindent    = true
      vim.opt.wrap           = true
      vim.opt.smartcase      = true
      vim.opt.smartindent    = true -- Insert indents automatically
      vim.opt.cursorline     = true
      vim.opt.cursorcolumn   = true
      vim.opt.termguicolors  = true
      vim.opt.splitright     = true
      vim.opt.splitbelow     = true
      vim.opt.mousemodel     = 'popup'
      vim.opt.mousescroll    = 'ver:5,hor:0'
      vim.opt.swapfile       = false
      vim.opt.fileformats    = 'dos'
      vim.opt.foldmethod     = 'indent'
      vim.opt.foldlevel      = 99
      vim.opt.titlestring    = 'Neovim-094'
      vim.opt.fileencodings  = 'utf-8,gbk,default,ucs-bom,latin'
      vim.opt.shortmess:append { W = true, I = true, c = true, }
      vim.opt.showmode      = true -- Dont show mode since we have a statusline
      vim.opt.undofile      = true
      vim.opt.undolevels    = 10000
      vim.opt.sidescrolloff = 0      -- Columns of context
      vim.opt.scrolloff     = 0      -- Lines of context
      vim.opt.scrollback    = 100000 -- Lines of context
      vim.opt.completeopt   = 'menu,menuone,noselect'
      vim.opt.conceallevel  = 0      -- Hide * markup for bold and italic
      vim.opt.list          = true
      vim.opt.shada         = [[!,'1000,<500,s10000,h]]
      vim.opt.laststatus    = 3
      vim.opt.statusline    = [[%f %h%m%r%=%<%-14.(%l,%c%V%) %P]]
      vim.opt.equalalways   = false
      -- vim.opt.spell         = true
      -- vim.opt.spelllang     = 'en_us,cjk'
      vim.opt.linebreak     = true
    end,
  },

  -- my.nmaps
  {
    name = 'my.nmaps',
    dir = '',
    event = 'VeryLazy',
    config = function() require 'config.my.nmaps' end,
  },

  -- my.uienter
  {
    name = 'my.uienter',
    dir = '',
    event = 'UIEnter',
    config = function()
      vim.fn['GuiWindowFrameless'](1)
      vim.cmd 'GuiAdaptiveFont 1'
      vim.cmd 'GuiAdaptiveStyle Fusion'
    end,
  },

  -- my.vimleavepre
  {
    name = 'my.vimleavepre',
    dir = '',
    event = 'VimLeavePre',
    config = function() vim.fn['GuiWindowFrameless'](0) end,
  },

  -- my.bufreadpost
  {
    name = 'my.bufreadpost',
    dir = '',
    event = { 'BufReadPre', 'BufReadPost', },
    config = function()
      require 'config.my.bufreadpost'
    end,
  },

  -- my.textyankpost
  {
    name = 'my.textyankpost',
    dir = '',
    event = 'TextYankPost',
    config = function()
      require 'base'.aucmd('TextYankPost', 'my.textyankpost.TextYankPost', {
        callback = function()
          vim.highlight.on_yank()
        end,
      })
    end,
  },

  -- my.imaps
  {
    name = 'my.imaps',
    dir = '',
    event = { 'InsertEnter', 'CmdlineEnter', 'TermEnter', },
    config = function() require 'config.my.imaps' end,
  },

  -- my.git
  {
    name = 'my.git',
    dir = '',
    event = { 'BufReadPre', 'BufNewFile', },
    cmd = {
      'MyGit',
      'Git',
      'Gitsings',
      'DiffviewOpen', 'DiffviewFileHistory',
    },
    keys = {
      { '<RightMouse>', function() end,                                               mode = { 'n', 'v', }, silent = true, desc = 'my.git', },

      -- git.push
      { '<leader>g',    function() require 'config.my.git' end,                       mode = { 'n', 'v', }, silent = true, desc = '---my.git---', },
      { '<leader>gg',   function() require 'config.my.git' end,                       mode = { 'n', 'v', }, silent = true, desc = '---my.git.push---', },
      { '<leader>ga',   function() require 'config.my.git'.addcommitpush() end,       mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: addcommitpush', },
      { '<leader>gga',  function() require 'config.my.git'.addcommitpush(nil, 1) end, mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: addcommitpush commit_history_en', },
      { '<leader>gb',   function() require 'config.my.git'.commit_push() end,         mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: commit_push', },
      { '<leader>ggb',  function() require 'config.my.git'.commit_push(nil, 1) end,   mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: commit_push commit_history_en', },
      { '<leader>gp',   function() require 'config.my.git'.pull() end,                mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: pull', },
      { '<leader>ggp',  function() require 'config.my.git'.pull_all() end,            mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: pull_all', },

      -- git.signs
      { '<leader>gm',   function() require 'config.my.git' end,                       mode = { 'n', 'v', }, silent = true, desc = '---my.git.signs---', },
      { '<leader>gmt',  function() require 'config.my.git' end,                       mode = { 'n', 'v', }, silent = true, desc = '---my.git.signs.toggle---', },
      { 'ig',           ':<C-U>Gitsigns select_hunk<CR>',                             mode = { 'o', 'x', }, silent = true, desc = 'my.git.signs: select_hunk', },
      { 'ag',           ':<C-U>Gitsigns select_hunk<CR>',                             mode = { 'o', 'x', }, silent = true, desc = 'my.git.signs: select_hunk', },
      { '<leader>j',    desc = 'my.git.signs next_hunk', },
      { '<leader>k',    desc = 'my.git.signs prev_hunk', },
      { '<leader>gd',   function() require 'config.my.git'.diffthis() end,            mode = { 'n', },      silent = true, desc = 'my.git.signs: diffthis', },
      { '<leader>gr',   function() require 'config.my.git'.reset_hunk() end,          mode = { 'n', },      silent = true, desc = 'my.git.signs: reset_hunk', },
      { '<leader>gr',   function() require 'config.my.git'.reset_hunk_v() end,        mode = { 'v', },      silent = true, desc = 'my.git.signs: reset_hunk_v', },
      { '<leader>gs',   function() require 'config.my.git'.stage_hunk() end,          mode = { 'n', },      silent = true, desc = 'my.git.signs: stage_hunk', },
      { '<leader>gs',   function() require 'config.my.git'.stage_hunk_v() end,        mode = { 'v', },      silent = true, desc = 'my.git.signs: stage_hunk_v', },
      { '<leader>gu',   function() require 'config.my.git'.undo_stage_hunk() end,     mode = { 'n', },      silent = true, desc = 'my.git.signs: undo_stage_hunk', },

      -- git.diffview
      { '<leader>gv',   function() require 'config.my.git' end,                       mode = { 'n', 'v', }, silent = true, desc = '---my.git.diffview---', },

      -- git.lazy
      { '<leader>gl',   function() require 'config.my.git'.lazygit() end,             mode = { 'n', 'v', }, silent = true, desc = 'my.git.lazy: lazygit', },

      { '<a-cr>',       function() require 'config.my.git'.quickfix_toggle() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.git.signs: quickfix_toggle', },

      --
      { '<c-;>',        require 'base'.all_commands,                                  mode = { 'n', 'v', }, silent = true, desc = 'base: all commands', },

    },
    dependencies = {
      'skywind3000/asyncrun.vim',
      'tpope/vim-fugitive',
      -- 'lewis6991/gitsigns.nvim',
      'peter-lyr/gitsigns.nvim',
      -- 'sindrets/diffview.nvim',
      'peter-lyr/diffview.nvim',
      'dbakker/vim-projectroot',
    },
    config = function() require 'config.my.git' end,
  },

  -- my.c
  {
    name = 'my.c',
    dir = '',
    cmd = { 'C', },
    ft = { 'c', 'cpp', },
    keys = {
      { '<c-;>', require 'base'.all_commands, mode = { 'n', 'v', }, silent = true, desc = 'base: all commands', },
    },
    config = function() require 'config.my.c' end,
  },

  -- my.args
  {
    name = 'my.args',
    dir = '',
    cmd = { 'Args', },
    event = { 'BufReadPre', 'BufNewFile', },
    keys = {
      { '<c-;>', require 'base'.all_commands, mode = { 'n', 'v', }, silent = true, desc = 'base: all commands', },
    },
    config = function() require 'config.my.args' end,
  },

  -- my.drag
  {
    name = 'my.drag',
    dir = '',
    ft = { 'markdown', },
    cmd = { 'Drag', },
    event = { 'FocusLost', },
    dependencies = { 'peter-lyr/vim-bbye', },
    keys = {
      { '<c-;>', require 'base'.all_commands, mode = { 'n', 'v', }, silent = true, desc = 'base: all commands', },
    },
    config = function()
      vim.o.updatetime = 100
      require 'config.my.drag'
    end,
  },

  -- my.copy
  {
    name = 'my.copy',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', },
    keys = {
      { '<leader>y',  function() require 'config.my.copy' end,            mode = { 'n', 'v', }, silent = true, desc = '---my.copy---', },
      { '<leader>yw', function() require 'config.my.copy'.copy_cwd() end, mode = { 'n', 'v', }, silent = true, desc = 'my.copy: copy_cwd', },
    },
    config = function() require 'config.my.copy' end,
  },

  -- my.gui
  {
    name = 'my.gui',
    dir = '',
    cmd = { 'Gui', },
    event = { 'TabEnter', },
    keys = {
      { '<c-0>',               function() require 'config.my.gui' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.gui---', },
      { '<c-0><c-0>',          function() require 'config.my.gui'.fontsize_normal() end, mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size min', },
      { '<c-->',               function() require 'config.my.gui'.fontsize_down() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size down', },
      { '<c-=>',               function() require 'config.my.gui'.fontsize_up() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size up', },
      { '<c-ScrollWheelDown>', function() require 'config.my.gui'.fontsize_down() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size down', },
      { '<c-ScrollWheelUp>',   function() require 'config.my.gui'.fontsize_up() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size up', },
      { '<c-MiddleMouse>',     function() require 'config.my.gui'.fontsize_normal() end, mode = { 'n', 'v', }, silent = true, desc = 'my.gui: font size min', },
    },
    init = function()
      vim.api.nvim_create_autocmd('VimLeave', {
        callback = function()
          vim.cmd 'Lazy load my.gui'
          require 'config.my.gui'.save_last_fontsize()
        end,
      })
    end,
    config = function() require 'config.my.gui' end,
  },

  -- my.hili
  {
    name = 'my_hili',
    dir = '',
    dependencies = { 'peter-lyr/sha2', },
    event = { 'BufReadPost', 'BufNewFile', },
    keys = {
      { '*',       function() require 'config.my.hili'.search() end,          mode = { 'v', },      silent = true, desc = 'my.hili: multiline search', },
      -- windo cursorword
      { '<a-7>',   function() require 'config.my.hili'.cursorword() end,      mode = { 'n', },      silent = true, desc = 'my.hili: cursor word', },
      { '<a-8>',   function() require 'config.my.hili'.windocursorword() end, mode = { 'n', },      silent = true, desc = 'my.hili: windo cursor word', },
      -- cword hili
      { '<c-8>',   function() require 'config.my.hili'.hili_n() end,          mode = { 'n', },      silent = true, desc = 'my.hili: cword', },
      { '<c-8>',   function() require 'config.my.hili'.hili_v() end,          mode = { 'v', },      silent = true, desc = 'my.hili: cword', },
      -- cword hili rm
      { '<c-s-8>', function() require 'config.my.hili'.rmhili_v() end,        mode = { 'v', },      silent = true, desc = 'my.hili: rm v', },
      { '<c-s-8>', function() require 'config.my.hili'.rmhili_n() end,        mode = { 'n', },      silent = true, desc = 'my.hili: rm n', },
      -- select hili
      { '<c-7>',   function() require 'config.my.hili'.selnexthili() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.hili: sel next', },
      { '<c-s-7>', function() require 'config.my.hili'.selprevhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.hili: sel prev', },
      -- go hili
      { '<c-n>',   function() require 'config.my.hili'.prevhili() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.hili: go prev', },
      { '<c-m>',   function() require 'config.my.hili'.nexthili() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.hili: go next', },
      -- go cur hili
      { '<c-s-n>', function() require 'config.my.hili'.prevcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.hili: go cur prev', },
      { '<c-s-m>', function() require 'config.my.hili'.nextcurhili() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.hili: go cur next', },
      -- rehili
      { '<c-s-9>', function() require 'config.my.hili'.rehili() end,          mode = { 'n', 'v', }, silent = true, desc = 'my.hili: rehili', },
    },
    config = function()
      vim.o.updatetime = 100
      require 'config.my.hili'
    end,
  },

  -- my.toggle
  {
    name = 'my.toggle',
    dir = '',
    keys = {
      { '<leader>t', function() end, mode = { 'n', 'v', }, silent = true, desc = '---my.toggle---', },
    },
    config = function()
      require 'base'.del_map({ 'n', 'v', }, '<leader>t')
      require 'which-key'.register { ['<leader>t'] = { name = 'my.toggle', }, }
      require 'config.my.toggle'
    end,
  },

  -- my.tabline
  {
    name = 'my.tabline',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'dbakker/vim-projectroot',
      'peter-lyr/vim-bbye',
    },
    keys = {
      { '<c-l>',   function() require 'config.my.tabline'.b_next_buf() end,                      mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: b_next_buf', },
      { '<c-h>',   function() require 'config.my.tabline'.b_prev_buf() end,                      mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: b_prev_buf', },
      { '<c-s-l>', function() require 'config.my.tabline'.bd_next_buf() end,                     mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: bd_next_buf', },
      { '<c-s-h>', function() require 'config.my.tabline'.bd_prev_buf() end,                     mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: bd_prev_buf', },
      { '<c-s-.>', function() require 'config.my.tabline'.bd_all_next_buf() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: bd_all_next_buf', },
      { '<c-s-,>', function() require 'config.my.tabline'.bd_all_prev_buf() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: bd_all_prev_buf', },
      { '<a-,>',   function() require 'config.my.tabline'.simple_statusline_toggle() end,        mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: simple_statusline_toggle', },
      { '<a-.>',   function() require 'config.my.tabline'.toggle_tabs_way() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: toggle_tabs_way', },
      { 'ql',      function() require 'config.my.tabline'.only_cur_buffer() end,                 mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: only_cur_buffer', },
      { 'qh',      function() require 'config.my.tabline'.restore_hidden_tabs() end,             mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: restore_hidden_tabs', },
      { 'qj',      function() require 'config.my.tabline'.append_one_proj_right_down() end,      mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: append_one_proj_right_down', },
      { 'qk',      function() require 'config.my.tabline'.append_one_proj_new_tab_no_dupl() end, mode = { 'n', 'v', }, silent = true, desc = 'my.tabline: append_one_proj_new_tab_no_dupl', },
    },
    init = function()
      vim.opt.tabline = vim.loop.cwd()
      vim.opt.showtabline = 2
    end,
    config = function() require 'config.my.tabline' end,
  },

  -- markdown
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    build = ':call mkdp#util#install()',
    ft = { 'markdown', },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle', 'MarkdownExportCreate', 'MarkdownExportDelete', },
    keys = {
      { '<a-o>',   function() require 'config.my.markdown'.system_open_cfile() end,    mode = { 'n', 'v', }, silent = true, desc = 'my.markdown: start cfile', },
      { '<a-i>',   function() require 'config.my.markdown'.buffer_open_cfile() end,    mode = { 'n', 'v', }, silent = true, desc = 'my.markdown: start cfile', },
      { '<a-u>',   function() require 'config.my.markdown'.make_url() end,             mode = { 'n', 'v', }, silent = true, desc = 'my.markdown: make_url', },
      { '<a-s-y>', function() require 'config.my.markdown'.copy_cfile_path_clip() end, mode = { 'n', 'v', }, silent = true, desc = 'my.markdown: copy_cfile_path_clip', },
      { '<c-s-y>', function() require 'config.my.markdown'.copy_cfile_clip() end,      mode = { 'n', 'v', }, silent = true, desc = 'my.markdown: copy_cfile_clip', },
    },
    init = function()
      vim.g.mkdp_theme              = 'light'
      vim.g.mkdp_auto_close         = 0
      vim.g.mkdp_auto_start         = 0
      vim.g.mkdp_combine_preview    = 1
      vim.g.mkdp_command_for_global = 1
    end,
    config = function() require 'config.my.markdown' end,
  },

  -- my.box
  {
    name = 'my.box',
    dir = '',
    cmd = 'ExecuteOutput',
    dependencies = { 'itchyny/vim-gitbranch', },
    keys = {
      { '<leader><c-3>', function() require 'config.my.box' end,             mode = { 'n', 'v', }, silent = true, desc = '---my.box---', },
      { '<f1>',          function() require 'config.my.box'.show_info() end, mode = { 'n', 'v', }, silent = true, desc = 'my.box: show info', },
    },
    config = function() require 'config.my.box' end,
  },

  -- my.scroll
  {
    name = 'my.scroll',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', },
    config = function() require 'config.my.scroll' end,
  },

  -- my.window
  {
    name = 'my.window',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', },
    config = function() require 'config.my.window' end,
  },

  -- my.cal
  {
    name = 'my.cal',
    dir = '',
    keys = {
      { 'c/', function() require 'config.my.cal' end, mode = { 'n', 'v', }, silent = true, desc = '---my.cal---', },
    },
  },

  -- my.svn
  {
    name = 'my.svn',
    dir = '',
    keys = {
      { '<leader>v', function() require 'config.my.svn' end, mode = { 'n', 'v', }, silent = true, desc = '---my.svn---', },
    },
  },

}
