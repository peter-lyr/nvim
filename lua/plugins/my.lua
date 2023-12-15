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
      vim.opt.wrap           = false
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
    end,
  },

  -- my.nmaps
  {
    name = 'my.nmaps',
    dir = '',
    event = 'VeryLazy',
    config = function()
      require 'config.my.nmaps'
    end,
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
    config = function()
      vim.fn['GuiWindowFrameless'](0)
    end,
  },

  -- my.bufreadpost
  {
    name = 'my.bufreadpost',
    dir = '',
    event = 'BufReadPost',
    config = function()
      require 'base'.aucmd('BufReadPost', 'my.bufreadpost.BufReadPost', {
        callback = function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          local lcount = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end,
      })
      local tab_4_fts = {
        'c', 'cpp',
        -- 'python',
        'ld',
      }
      require 'base'.aucmd('BufEnter', 'my.bufreadpost.BufEnter', {
        callback = function(ev)
          if vim.fn.filereadable(ev.file) == 1 and vim.o.modifiable == true then
            vim.opt.cursorcolumn = true
          end
          if vim.tbl_contains(tab_4_fts, vim.opt.filetype:get()) == true then
            vim.opt.tabstop = 4
            vim.opt.softtabstop = 4
            vim.opt.shiftwidth = 4
          else
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2
          end
        end,
      })
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
    config = function()
      require 'config.my.imaps'
    end,
  },

  -- my.git
  {
    name = 'my.git',
    dir = '',
    event = { 'BufReadPre', 'BufNewFile', },
    cmd = {
      'Git',
      'Gitsings',
      'DiffviewOpen', 'DiffviewFileHistory',
    },
    keys = {
      -- git.push
      { '<leader>g',   function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git---', },
      { '<leader>gg',  function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git.push---', },
      { '<leader>ga',  function() require 'config.my.git'.addcommitpush() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: addcommitpush', },
      { '<leader>gp',  function() require 'config.my.git'.pull() end,            mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: pull', },
      { '<leader>gc',  function() require 'config.my.git'.commit_push() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: commit_push', },

      -- git.signs
      { '<leader>gm',  function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git.signs---', },
      { '<leader>gmt', function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git.signs.toggle---', },
      { 'ig',          ':<C-U>Gitsigns select_hunk<CR>',                         mode = { 'o', 'x', }, silent = true, desc = 'my.git.signs: select_hunk', },
      { 'ag',          ':<C-U>Gitsigns select_hunk<CR>',                         mode = { 'o', 'x', }, silent = true, desc = 'my.git.signs: select_hunk', },
      { '<leader>j',   desc = 'my.git.signs next_hunk', },
      { '<leader>k',   desc = 'my.git.signs prev_hunk', },
      { '<leader>gd',  function() require 'config.my.git'.diffthis() end,        mode = { 'n', },      silent = true, desc = 'my.git.signs: diffthis', },
      { '<leader>gr',  function() require 'config.my.git'.reset_hunk() end,      mode = { 'n', },      silent = true, desc = 'my.git.signs: reset_hunk', },
      { '<leader>gr',  function() require 'config.my.git'.reset_hunk_v() end,    mode = { 'v', },      silent = true, desc = 'my.git.signs: reset_hunk_v', },
      { '<leader>gs',  function() require 'config.my.git'.stage_hunk() end,      mode = { 'n', },      silent = true, desc = 'my.git.signs: stage_hunk', },
      { '<leader>gs',  function() require 'config.my.git'.stage_hunk_v() end,    mode = { 'v', },      silent = true, desc = 'my.git.signs: stage_hunk_v', },
      { '<leader>gu',  function() require 'config.my.git'.undo_stage_hunk() end, mode = { 'n', },      silent = true, desc = 'my.git.signs: undo_stage_hunk', },

      -- git.lazy
      { '<leader>gl',  function() require 'config.my.git'.lazygit() end,         mode = { 'n', 'v', }, silent = true, desc = 'my.git.lazy: lazygit', },

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
    config = function()
      require 'config.my.git'
    end,
  },

  -- my.c
  {
    name = 'my.c',
    dir = '',
    cmd = { 'Make', 'CMake', },
    ft = { 'c', 'cpp', },
    config = function()
      require 'config.my.c'
    end,
  },

  -- my.args
  {
    name = 'my.args',
    dir = '',
    cmd = { 'Args', },
    event = { 'BufReadPre', 'BufNewFile', },
    config = function()
      require 'config.my.args'
    end,
  },

  -- my.drag
  {
    name = 'my.drag',
    dir = '',
    ft = { 'markdown', },
    cmd = { 'Drag', },
    event = { 'FocusLost', },
    dependencies = { 'peter-lyr/vim-bbye', },
    config = function()
      require 'config.my.drag'
    end,
  },

}
