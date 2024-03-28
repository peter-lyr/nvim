return {

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
      vim.opt.winminheight   = 0
      vim.opt.winminwidth    = 0
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
      vim.opt.titlestring    = 'Neovim-095'
      vim.opt.fileencodings  = 'utf-8,gbk,default,ucs-bom,latin'
      vim.opt.shortmess:append { W = true, I = true, c = true, }
      vim.opt.showmode       = true -- Dont show mode since we have a statusline
      vim.opt.undofile       = true
      vim.opt.undolevels     = 10000
      vim.opt.sidescrolloff  = 0      -- Columns of context
      vim.opt.scrolloff      = 0      -- Lines of context
      vim.opt.scrollback     = 100000 -- Lines of context
      vim.opt.completeopt    = 'menu,menuone,noselect'
      vim.opt.conceallevel   = 0      -- Hide * markup for bold and italic
      vim.opt.list           = true
      vim.opt.updatetime     = 500
      -- vim.opt.shada          = [[!,'10,<50,s10,h]]
      vim.opt.laststatus     = 3
      vim.opt.statusline     = [[%f %h%m%r%=%{getcwd()}   [%{mode()}]  %<%-14.(%l,%c%V%) %P]]
      vim.opt.equalalways    = false
      -- vim.opt.spell         = true
      -- vim.opt.spelllang     = 'en_us,cjk'
      vim.opt.linebreak      = true
      vim.opt.sessionoptions = 'buffers,sesdir,folds,help,tabpages,winsize,terminal'
      require 'config.my.options'
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
      vim.g.end_time = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
      if vim.fn.isdirectory(vim.fn.expand [[$HOME]] .. '\\DEPEI') ~= 1 then
        vim.fn.mkdir(vim.fn.expand [[$HOME]] .. '\\DEPEI')
      end
      local nvim_qt_start_flag_socket_txt = vim.fn.expand [[$HOME]] .. '\\DEPEI\\nvim_qt_start_flag_socket.txt'
      local function print_startup_time()
        vim.fn.timer_start(1080, function()
          vim.g.startup_time = string.format('Startup: %.3f ms', vim.g.end_time * 1000)
          vim.cmd('echo "' .. vim.g.startup_time .. '"')
          if vim.g.end_time * 1000 <= 28 then
            vim.fn.writefile({ vim.g.startup_time .. '\r', }, vim.fn.expand [[$HOME]] .. '\\DEPEI\\nvim_startup_time.txt', 'a')
          end
        end)
      end
      if vim.fn.filereadable(nvim_qt_start_flag_socket_txt) == 1 then
        local res = vim.fn.trim(vim.fn.join(vim.fn.readfile(nvim_qt_start_flag_socket_txt), ''))
        local temp = nil
        local call = function() end
        if '2' == res then
          temp = 1
          call = function()
            vim.cmd 'SessionsLoad'
          end
        elseif vim.fn.filereadable(res) == 1 then
          temp = 1
          call = function()
            vim.cmd('e ' .. res)
          end
        end
        if temp then
          vim.fn.timer_start(10, function()
            call()
            vim.fn['GuiWindowFullScreen'](1)
            vim.fn['GuiWindowFullScreen'](0)
            vim.fn.timer_start(10, function()
              require 'config.nvim.nvimtree'.reset_nvimtree()
              print_startup_time()
            end)
          end)
        else
          print_startup_time()
        end
      else
        print_startup_time()
      end
      vim.fn.writefile({ '0', }, nvim_qt_start_flag_socket_txt)
      vim.fn.timer_start(78, function()
        vim.cmd 'rshada'
        vim.g.temp_au = vim.api.nvim_create_autocmd('FocusLost', {
          callback = function()
            vim.api.nvim_del_autocmd(vim.g.temp_au)
            require 'config.my.maps'.all()
          end,
        })
      end)
    end,
  },

  -- my.recordingleave
  {
    name = 'my.recordingleave',
    dir = '',
    event = { 'RecordingLeave', },
    config = function()
      local function recordingleave()
        vim.fn.timer_start(10, function()
          local record = vim.fn.reg_recorded()
          require 'base'.notify_info(record .. ' ' .. vim.fn.getreg(record))
        end)
      end
      vim.api.nvim_create_autocmd('RecordingLeave', {
        callback = recordingleave,
      })
      recordingleave()
    end,
  },

  -- my.recordingenter
  {
    name = 'my.recordingenter',
    dir = '',
    event = { 'RecordingEnter', },
    config = function()
      local function recordingenter()
        vim.fn.timer_start(10, function()
          local record = vim.fn.reg_recording()
          require 'base'.notify_info('recording: ' .. record)
        end)
      end
      vim.api.nvim_create_autocmd('RecordingEnter', {
        callback = recordingenter,
      })
      recordingenter()
    end,
  },

  -- my.vimleavepre
  {
    name = 'my.vimleavepre',
    dir = '',
    event = 'VimLeavePre',
    config = function()
      vim.cmd 'SessionsSave'
      require 'config.my.box'.prepare_sessions()
      -- if vim.g.GuiWindowFullScreen == 1 then
      vim.fn['GuiWindowFullScreen'](0)
      -- end
      -- if vim.g.GuiWindowMaximized == 1 then
      vim.fn['GuiWindowMaximized'](0)
      -- end
      -- if vim.g.GuiWindowFrameless == 1 then
      vim.fn['GuiWindowFrameless'](0)
      -- end
    end,
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
    config = function() Require 'config.my.imaps' end,
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
      { '<RightMouse>', desc = '', },
      { '<c-\\>',       desc = 'fugitive: toggle', },
      { '<c-cr>',       desc = 'quickfix: toggle', },
      { '<leader>g',    desc = 'git', },
    },
    dependencies = {
      { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun', }, },
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
    config = function() Require 'config.my.c' end,
  },

  -- my.args
  {
    name = 'my.args',
    dir = '',
    cmd = { 'Args', },
    event = { 'BufReadPre', 'BufNewFile', },
    config = function() Require 'config.my.args' end,
  },

  -- my.drag
  {
    name = 'my.drag',
    dir = '',
    ft = { 'markdown', },
    dependencies = { 'peter-lyr/vim-bbye', },
  },

  -- my.copy
  {
    name = 'my.copy',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', },
    keys = {
      { '<leader>y', desc = 'copy cwd to clipboard', },
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
      { '<c-0>',               desc = 'gui', },
      { '<c-->',               desc = 'gui: font size down', },
      { '<c-=>',               desc = 'gui: font size up', },
      { '<c-ScrollWheelDown>', desc = 'gui: font size down', },
      { '<c-ScrollWheelUp>',   desc = 'gui: font size up', },
      { '<c-RightMouse>',      desc = 'gui: font size min', },
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
    event = { 'BufReadPost', 'BufNewFile', },
    dependencies = { 'peter-lyr/sha2', },
    keys = {
      { '*',       desc = 'hili: multiline search', },
      { '<a-7>',   desc = 'hili: cursor word', },
      { '<a-8>',   desc = 'hili: windo cursor word', },
      { '<c-8>',   desc = 'hili: cword', },
      { '<c-s-8>', desc = 'hili: rm v', },
      { '<c-7>',   desc = 'hili: sel next', },
      { '<c-s-7>', desc = 'hili: sel prev', },
      { '<c-n>',   desc = 'hili: go prev', },
      { '<c-m>',   desc = 'hili: go next', },
      { '<c-s-n>', desc = 'hili: go cur prev', },
      { '<c-s-m>', desc = 'hili: go cur next', },
      { '<c-s-9>', desc = 'hili: rehili', },
      { "<c-s-'>", desc = 'hili: prevlastcword', },
      { '<c-s-/>', desc = 'hili: nextlastcword', },
      { '<c-,>',   desc = 'hili: prevcword', },
      { '<c-.>',   desc = 'hili: nextcword', },
      { "<c-'>",   desc = 'hili: prevcWORD', },
      { '<c-/>',   desc = 'hili: nextcWORD', },
    },
    config = function() require 'config.my.hili' end,
  },

  -- my.toggle
  {
    name = 'my.toggle',
    dir = '',
    keys = {
      { '<leader>t', desc = 'toggle', },
    },
    config = function() require 'config.my.toggle' end,
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
      { '<c-s-l>', desc = 'tabline: bd next buf', },
      { '<c-s-h>', desc = 'tabline: bd prev buf', },
      { '<c-s-.>', desc = 'tabline: bd all next buf', },
      { '<c-s-,>', desc = 'tabline: bd all prev buf', },
      { '<a-,>',   desc = 'tabline: simple statusline toggle', },
      { '<a-.>',   desc = 'tabline: toggle tabs way', },
    },
    init = function()
      vim.opt.tabline = vim.loop.cwd()
      vim.opt.showtabline = 2
      local function lazy_map(tbls)
        for _, tbl in ipairs(tbls) do
          local opt = {}
          for k, v in pairs(tbl) do
            if type(k) == 'string' and k ~= 'mode' then
              opt[k] = v
            end
          end
          vim.keymap.set(tbl['mode'], tbl[1], tbl[2], opt)
        end
      end
      vim.fn.timer_start(1000, function()
        lazy_map {
          { '<c-l>', function() require 'config.my.tabline'.b_next_buf() end, desc = 'tabline: b_next_buf', mode = { 'n', 'v', }, silent = true, },
          { '<c-h>', function() require 'config.my.tabline'.b_prev_buf() end, desc = 'tabline: b_prev_buf', mode = { 'n', 'v', }, silent = true, },
        }
      end)
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
      { '<a-o>',   function() require 'config.my.markdown'.system_open_cfile() end,       desc = 'my.markdown: system open <cfile>',                            mode = { 'n', 'v', }, silent = true, },
      { '<a-i>',   function() require 'config.my.markdown'.buffer_open_cfile() end,       desc = 'my.markdown: open <cfile> and stack',                         mode = { 'n', 'v', }, silent = true, },
      { '<a-s-i>', function() require 'config.my.markdown'.pop_file_stack() end,          desc = 'my.markdown: pop from stack and go back last buffer',         mode = { 'n', 'v', }, silent = true, },
      { '<a-u>',   function() require 'config.my.markdown'.make_url() end,                desc = 'my.markdown: make relative url from clipboard',               mode = { 'n', 'v', }, silent = true, },
      { '<c-s-u>', function() require 'config.my.markdown'.make_url_sel() end,            desc = 'my.markdown: make relative url from sel markdown file',       mode = { 'n', 'v', }, silent = true, },
      { '<a-s-u>', function() require 'config.my.markdown'.create_file_from_target() end, desc = 'my.markdown: create file from target: 1. zoom,inner,problem', mode = { 'n', 'v', }, silent = true, },
      { '<a-r>',   function() require 'config.my.markdown'.run_in_cmd() end,              desc = 'my.markdown: run current line as cmd command',                mode = { 'n', 'v', }, silent = true, },
      { '<a-e>',   function() require 'config.my.markdown'.run_in_cmd 'silent' end,       desc = 'my.markdown: run current line as cmd command silent',         mode = { 'n', 'v', }, silent = true, },
      { '<a-s-y>', function() require 'config.my.markdown'.copy_cfile_path_clip() end,    desc = 'my.markdown: copy <cfile> url   text  to clip',               mode = { 'n', 'v', }, silent = true, },
      { '<c-s-y>', function() require 'config.my.markdown'.copy_cfile_clip() end,         desc = 'my.markdown: copy <cfile> file itself to clip',               mode = { 'n', 'v', }, silent = true, },
    },
    init = function()
      vim.g.mkdp_theme              = 'light'
      vim.g.mkdp_auto_close         = 0
      vim.g.mkdp_auto_start         = 0
      vim.g.mkdp_combine_preview    = 1
      vim.g.mkdp_command_for_global = 1
    end,
    config = function() Require 'config.my.markdown' end,
  },

  -- my.box
  {
    name = 'my.box',
    dir = '',
    dependencies = { 'itchyny/vim-gitbranch', },
    keys = {
      { '<F1>',      desc = 'show info', },
      { '<F2>',      desc = 'switch two words prepare', },
      { '<F3>',      desc = 'switch two words do', },
      { '<leader>a', desc = 'sel open programs file force', },
    },
    config = function() require 'config.my.box' end,
  },

  -- my.yank
  {
    name = 'my.yank',
    dir = '',
    event = { 'BufReadPost', 'TextChanged', 'TextChangedI', },
    config = function() require 'config.my.yank' end,
  },

  -- my.base
  {
    name = 'my.base',
    dir = '',
    keys = {
      { '<c-;>', desc = 'base commands', },
    },
    config = function() require 'base' end,
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
    keys = {
      { '<leader>w', desc = 'window: jump/split/new', },
      { '<leader>x', desc = 'window: bdelete/bwipeout', },
      { '<a-h>',     desc = 'window: width less 1', },
      { '<a-l>',     desc = 'window: width more 1', },
      { '<a-j>',     desc = 'window: height less 1', },
      { '<a-k>',     desc = 'window: height more 1', },
      { '<a-s-h>',   desc = 'window: width less 10', },
      { '<a-s-l>',   desc = 'window: width more 10', },
      { '<a-s-j>',   desc = 'window: height less 10', },
      { '<a-s-k>',   desc = 'window: height more 10', },
    },
    config = function() require 'config.my.window' end,
  },

  -- my.cal
  {
    name = 'my.cal',
    dir = '',
    keys = {
      { 'c/', desc = 'cal', },
    },
    config = function() require 'config.my.cal' end,
  },

  -- my.svn
  {
    name = 'my.svn',
    dir = '',
    keys = {
      { '<leader>v', desc = 'svn', },
    },
    config = function() require 'config.my.svn' end,
  },

  -- my.neuims
  {
    name = 'my.neuims',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', 'InsertEnter', 'CmdlineEnter', 'TermEnter', },
    keys = {
      { '<c-;>',  desc = 'Enter new empty line', },
      { '<c-F1>', desc = 'toggle: EN/ZH', },
    },
    config = function() require 'config.my.neuims' end,
  },

  -- my.leader_r
  {
    name = 'my.leader_r',
    dir = '',
    ft = { 'python', },
    dependencies = {
      'nvim-pack/nvim-spectre',
    },
    keys = {
      { '<leader>r', desc = 'Run Py/Find & Replace', },
    },
    config = function()
      require 'config.my.leader_r'
    end,
  },

  -- my.leader_d
  {
    name = 'my.leader_d',
    dir = '',
    keys = {
      { '<leader>d', desc = 'nvim/qf', },
    },
    config = function()
      require 'config.my.leader_d'
    end,
  },

  -- my.command
  {
    name = 'my.command',
    dir = '',
    cmd = {
      'MapFromLazyToWhichkey', 'MapFromWhichkeyToLazy',
    },
    config = function() require 'config.my.command' end,
  },

  -- my.crypt
  {
    name = 'my.crypt',
    dir = '',
    cmd = {
      'EncryptMd', 'DecryptBin',
    },
    config = function() require 'config.my.crypt' end,
  },

}
