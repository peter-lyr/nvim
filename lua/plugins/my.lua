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
    config = function() Require 'config.my.nmaps' end,
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
        vim.fn.timer_start(380, function()
          vim.g.startup_time = string.format('Startup: %.3f ms', vim.g.end_time * 1000)
          vim.cmd('echo "' .. vim.g.startup_time .. '"')
          vim.fn.writefile({ vim.g.startup_time .. '\r', }, vim.fn.expand [[$HOME]] .. '\\DEPEI\\nvim_startup_time.txt', 'a')
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
              require 'config.test.nvimtree'.reset_nvimtree()
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
      'MyGit',
      'Git',
      'Gitsings',
      'DiffviewOpen', 'DiffviewFileHistory',
    },
    keys = {
      { '<RightMouse>', function() end,                                           desc = 'my.git',                        mode = { 'n', 'v', }, silent = true, },

      { '<leader>ga',   function() require 'config.my.git'.addcommitpush() end,   desc = 'git.push: addcommitpush',       mode = { 'n', 'v', }, silent = true, },

      -- git.signs
      { '<leader>gm',   function() require 'config.my.git' end,                   desc = '---my.git.signs---',            mode = { 'n', 'v', }, silent = true, },
      { '<leader>gmt',  function() require 'config.my.git' end,                   desc = '---my.git.signs.toggle---',     mode = { 'n', 'v', }, silent = true, },
      { '<leader>ge',   function() require 'config.my.git'.toggle_deleted() end,  desc = 'my.git.signs: toggle_deleted',  mode = { 'n', 'v', }, silent = true, },
      { 'ig',           ':<C-U>Gitsigns select_hunk<CR>',                         desc = 'my.git.signs: select_hunk',     mode = { 'o', 'x', }, silent = true, },
      { 'ag',           ':<C-U>Gitsigns select_hunk<CR>',                         desc = 'my.git.signs: select_hunk',     mode = { 'o', 'x', }, silent = true, },
      { '<leader>j',    desc = 'my.git.signs next_hunk', },
      { '<leader>k',    desc = 'my.git.signs prev_hunk', },
      { '<leader>gd',   function() require 'config.my.git'.diffthis() end,        desc = 'my.git.signs: diffthis',        mode = { 'n', },     silent = true, },
      { '<leader>gr',   function() require 'config.my.git'.reset_hunk() end,      desc = 'my.git.signs: reset_hunk',      mode = { 'n', },     silent = true, },
      { '<leader>gr',   function() require 'config.my.git'.reset_hunk_v() end,    desc = 'my.git.signs: reset_hunk_v',    mode = { 'v', },     silent = true, },
      { '<leader>gs',   function() require 'config.my.git'.stage_hunk() end,      desc = 'my.git.signs: stage_hunk',      mode = { 'n', },     silent = true, },
      { '<leader>gs',   function() require 'config.my.git'.stage_hunk_v() end,    desc = 'my.git.signs: stage_hunk_v',    mode = { 'v', },     silent = true, },
      { '<leader>gu',   function() require 'config.my.git'.undo_stage_hunk() end, desc = 'my.git.signs: undo_stage_hunk', mode = { 'n', },     silent = true, },

      -- fugitive_toggle
      { '<c-\\>',       function() require 'config.my.git'.fugitive_toggle() end, desc = 'my.git.fugitive: toggle',       mode = { 'n', 'v', }, silent = true, },

      -- git.lazy
      { '<leader>gl',   function() require 'config.my.git'.lazygit() end,         desc = 'my.git.lazy: lazygit',          mode = { 'n', 'v', }, silent = true, },

      { '<c-cr>',       function() require 'config.my.git'.quickfix_toggle() end, desc = 'my.git.signs: quickfix_toggle', mode = { 'n', 'v', }, silent = true, },

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
    config = function() Require 'config.my.git' end,
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
      { '<leader>yw', function() require 'config.my.copy'.copy_cwd() end, desc = 'copy cwd to clipboard', mode = { 'n', 'v', }, silent = true, },
    },
    config = function() Require 'config.my.copy' end,
  },

  -- my.gui
  {
    name = 'my.gui',
    dir = '',
    cmd = { 'Gui', },
    event = { 'TabEnter', },
    keys = {
      { '<c-0>',               function() require 'config.my.gui' end,                   desc = '---my.gui---',           mode = { 'n', 'v', }, silent = true, },
      { '<c-0><c-0>',          function() require 'config.my.gui'.fontsize_normal() end, desc = 'my.gui: font size min',  mode = { 'n', 'v', }, silent = true, },
      { '<c-->',               function() require 'config.my.gui'.fontsize_down() end,   desc = 'my.gui: font size down', mode = { 'n', 'v', }, silent = true, },
      { '<c-=>',               function() require 'config.my.gui'.fontsize_up() end,     desc = 'my.gui: font size up',   mode = { 'n', 'v', }, silent = true, },
      { '<c-ScrollWheelDown>', function() require 'config.my.gui'.fontsize_down() end,   desc = 'my.gui: font size down', mode = { 'n', 'v', }, silent = true, },
      { '<c-ScrollWheelUp>',   function() require 'config.my.gui'.fontsize_up() end,     desc = 'my.gui: font size up',   mode = { 'n', 'v', }, silent = true, },
      { '<c-RightMouse>',      function() require 'config.my.gui'.fontsize_normal() end, desc = 'my.gui: font size min',  mode = { 'n', 'v', }, silent = true, },
    },
    init = function()
      vim.api.nvim_create_autocmd('VimLeave', {
        callback = function()
          vim.cmd 'Lazy load my.gui'
          require 'config.my.gui'.save_last_fontsize()
        end,
      })
    end,
    config = function() Require 'config.my.gui' end,
  },

  -- my.hili
  {
    name = 'my_hili',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', },
    dependencies = { 'peter-lyr/sha2', },
    config = function() Require 'config.my.hili' end,
  },

  -- my.toggle
  {
    name = 'my.toggle',
    dir = '',
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
      { '<c-h>',           function() require 'config.my.tabline'.b_prev_buf() end,                      desc = 'my.tabline: b_prev_buf',                      mode = { 'n', 'v', }, silent = true, },
      { '<c-s-l>',         function() require 'config.my.tabline'.bd_next_buf() end,                     desc = 'my.tabline: bd_next_buf',                     mode = { 'n', 'v', }, silent = true, },
      { '<c-s-h>',         function() require 'config.my.tabline'.bd_prev_buf() end,                     desc = 'my.tabline: bd_prev_buf',                     mode = { 'n', 'v', }, silent = true, },
      { '<c-s-.>',         function() require 'config.my.tabline'.bd_all_next_buf() end,                 desc = 'my.tabline: bd_all_next_buf',                 mode = { 'n', 'v', }, silent = true, },
      { '<c-s-,>',         function() require 'config.my.tabline'.bd_all_prev_buf() end,                 desc = 'my.tabline: bd_all_prev_buf',                 mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-s-l>', function() require 'config.my.tabline'.bd_next_buf(1) end,                    desc = 'my.tabline: bwipeout_next_buf ',              mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-s-h>', function() require 'config.my.tabline'.bd_prev_buf(1) end,                    desc = 'my.tabline: bwipeout_prev_buf',               mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-s-.>', function() require 'config.my.tabline'.bd_all_next_buf(1) end,                desc = 'my.tabline: bwipeout_all_next_buf',           mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-s-,>', function() require 'config.my.tabline'.bd_all_prev_buf(1) end,                desc = 'my.tabline: bwipeout_all_prev_buf',           mode = { 'n', 'v', }, silent = true, },
      { '<a-,>',           function() require 'config.my.tabline'.simple_statusline_toggle() end,        desc = 'my.tabline: simple_statusline_toggle',        mode = { 'n', 'v', }, silent = true, },
      { '<a-.>',           function() require 'config.my.tabline'.toggle_tabs_way() end,                 desc = 'my.tabline: toggle_tabs_way',                 mode = { 'n', 'v', }, silent = true, },
      { 'ql',              function() require 'config.my.tabline'.only_cur_buffer() end,                 desc = 'my.tabline: only_cur_buffer',                 mode = { 'n', 'v', }, silent = true, },
      { 'qh',              function() require 'config.my.tabline'.restore_hidden_tabs() end,             desc = 'my.tabline: restore_hidden_tabs',             mode = { 'n', 'v', }, silent = true, },
      { 'qj',              function() require 'config.my.tabline'.append_one_proj_right_down() end,      desc = 'my.tabline: append_one_proj_right_down',      mode = { 'n', 'v', }, silent = true, },
      { 'q<c-j>',          function() require 'config.my.tabline'.append_one_proj_right_down_more() end, desc = 'my.tabline: append_one_proj_right_down_more', mode = { 'n', 'v', }, silent = true, },
      { 'qk',              function() require 'config.my.tabline'.append_one_proj_new_tab_no_dupl() end, desc = 'my.tabline: append_one_proj_new_tab_no_dupl', mode = { 'n', 'v', }, silent = true, },
      { 'qp',              function() require 'config.my.tabline'.restore_hidden_stack() end,            desc = 'my.tabline: restore_hidden_tabs',             mode = { 'n', 'v', }, silent = true, },
      { 'qm',              function() require 'config.my.tabline'.restore_hidden_stack_main() end,       desc = 'my.tabline: restore_hidden_tabs',             mode = { 'n', 'v', }, silent = true, },
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
          { '<c-l>', function() require 'config.my.tabline'.b_next_buf() end, desc = 'my.tabline: b_next_buf', mode = { 'n', 'v', }, silent = true, },
        }
      end)
    end,
    config = function() Require 'config.my.tabline' end,
  },

  -- markdown
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    build = ':call mkdp#util#install()',
    ft = { 'markdown', },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle', 'MarkdownExportCreate', 'MarkdownExportDelete', },
    keys = {
      { '<a-o>',   function() require 'config.my.markdown'.system_open_cfile() end,       desc = 'my.markdown: start cfile',          mode = { 'n', 'v', }, silent = true, },
      { '<a-i>',   function() require 'config.my.markdown'.buffer_open_cfile() end,       desc = 'my.markdown: buffer_open_cfile',    mode = { 'n', 'v', }, silent = true, },
      { '<a-s-i>', function() require 'config.my.markdown'.pop_file_stack() end,          desc = 'my.markdown: pop_file_stack',       mode = { 'n', 'v', }, silent = true, },
      { '<a-u>',   function() require 'config.my.markdown'.make_url() end,                desc = 'my.markdown: make_url',             mode = { 'n', 'v', }, silent = true, },
      { '<c-s-u>', function() require 'config.my.markdown'.make_url_sel() end,            desc = 'my.markdown: make_url_sel',         mode = { 'n', 'v', }, silent = true, },
      { '<a-s-u>', function() require 'config.my.markdown'.create_file_from_target() end, desc = 'my.markdown: create_file',          mode = { 'n', 'v', }, silent = true, },
      { '<a-r>',   function() require 'config.my.markdown'.run_in_cmd() end,              desc = 'my.markdown: run_in_cmd',           mode = { 'n', 'v', }, silent = true, },
      { '<a-e>',   function() require 'config.my.markdown'.run_in_cmd 'silent' end,       desc = 'my.markdown: run_in_cmd silent',    mode = { 'n', 'v', }, silent = true, },
      { '<a-s-y>', function() require 'config.my.markdown'.copy_cfile_path_clip() end,    desc = 'my.markdown: copy_cfile_path_clip', mode = { 'n', 'v', }, silent = true, },
      { '<c-s-y>', function() require 'config.my.markdown'.copy_cfile_clip() end,         desc = 'my.markdown: copy_cfile_clip',      mode = { 'n', 'v', }, silent = true, },
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
      { '<F1>',               function() require 'config.my.box'.show_info() end,              desc = 'show info',              mode = { 'n', 'v', }, silent = true, },
      { '<leader>asr',        function() require 'config.my.box'.restart_nvim_qt() end,        desc = 'restart nvim-qt',        mode = { 'n', 'v', }, silent = true, },
      { '<leader>as<leader>', function() require 'config.my.box'.start_new_nvim_qt() end,      desc = 'start new nvim-qt',      mode = { 'n', 'v', }, silent = true, },
      { '<leader>asq',        function() require 'config.my.box'.quit_nvim_qt() end,           desc = 'quit nvim-qt',           mode = { 'n', 'v', }, silent = true, },
      { '<leader>asp',        function() require 'config.my.box'.sel_open_programs_file() end, desc = 'sel open programs file', mode = { 'n', 'v', }, silent = true, },
      { '<leader>ask',        function() require 'config.my.box'.sel_kill_programs_file() end, desc = 'sel kill programs file', mode = { 'n', 'v', }, silent = true, },
      { '<leader>ae',         function() require 'config.my.box'.sel_open_temp() end,          desc = 'sel open temp file',     mode = { 'n', 'v', }, silent = true, },
      { '<leader>aw',         function() require 'config.my.box'.sel_write_to_temp() end,      desc = 'sel write to temp file', mode = { 'n', 'v', }, silent = true, },
    },
  },

  -- my.yank
  {
    name = 'my.yank',
    dir = '',
    config = function() require 'config.my.yank' end,
  },

  -- my.maps
  {
    name = 'my.maps',
    dir = '',
    event = { 'CursorHold', 'CursorHoldI', },
    cmd = { 'MapFromLazyToWhichkey', 'MapFromWhichkeyToLazy', },
    keys = {
      { '<s-esc>', function() Require 'config.my.maps'.all() end, desc = 'maps', mode = { 'n', 'v', }, silent = true, },
    },
    config = function() Require 'config.my.maps'.all() end,
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
      { '<leader>we', '<c-w>=',                                                desc = 'wincmd =',                        mode = { 'n', 'v', }, },
      { '<leader>wm', function() require 'base'.win_max_height() end,          desc = 'wincmd _ (winfixheight version)', mode = { 'n', 'v', }, },
      { '<leader>wh', function() require 'config.my.window'.go_window 'h' end, desc = 'go window up',                    mode = { 'n', 'v', }, },
      { '<leader>wj', function() require 'config.my.window'.go_window 'j' end, desc = 'go window down',                  mode = { 'n', 'v', }, },
      { '<leader>wk', function() require 'config.my.window'.go_window 'k' end, desc = 'go window left',                  mode = { 'n', 'v', }, },
      { '<leader>wl', function() require 'config.my.window'.go_window 'l' end, desc = 'go window right',                 mode = { 'n', 'v', }, },
    },
  },

  -- my.cal
  {
    name = 'my.cal',
    dir = '',
    keys = {
      { 'c/', function() require 'config.my.cal' end, desc = '---my.cal---', mode = { 'n', 'v', }, silent = true, },
    },
  },

  -- my.svn
  {
    name = 'my.svn',
    dir = '',
  },

  -- my.neuims
  {
    name = 'my.neuims',
    dir = '',
    event = { 'BufReadPost', 'BufNewFile', 'InsertEnter', 'CmdlineEnter', 'TermEnter', },
    keys = {
      { '<c-;>',  function() require 'config.my.neuims'.i_enter() end,                desc = 'my.insertenter: cr',                mode = { 'i', },                         silent = true, },
      { '<c-F1>', function() require 'config.my.neuims'.toggle_lang_in_cmdline() end, desc = 'my.neuims: toggle_lang_in_cmdline', mode = { 'n', 's', 'v', 'c', 'i', 't', }, silent = true, },
    },
    config = function()
      require 'config.my.neuims'
    end,
  },

  -- my.py
  {
    name = 'my.py',
    dir = '',
    ft = { 'python', },
    keys = {
      { '<leader>r',  function() end,                                     desc = '---my.py/test.spectre---', mode = { 'n', 'v', }, silent = true, },
      { '<leader>rp', function() require 'config.my.py'.sel_run_py() end, desc = 'my.py: sel_run',           mode = { 'n', 'v', }, silent = true, },
    },
    config = function() Require 'config.my.py' end,
  },

}

