return {

  -- startuptime
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    event = { 'FocusLost', 'BufReadPre', 'BufNewFile', },
    -- lazy = false,
    -- priority = 1000,
    config = function()
      vim.fn.timer_start(50, function()
        vim.cmd.colorscheme 'catppuccin'
        vim.cmd [[call feedkeys("\<c-l>")]]
        vim.fn.timer_start(50, function()
          vim.cmd [[call feedkeys("\<c-l>")]]
        end)
      end)
    end,
  },

  -- whichkey
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    keys = { { '<a-w>', '<cmd>WhichKey<cr>', mode = { 'n', 'v', }, desc = 'WhichKey', }, },
    config = function()
      require 'which-key'.setup {
        window = {
          border = 'single',
          winblend = 12,
        },
        layout = {
          height = { min = 4, max = 80, },
          width = { min = 20, max = 200, },
        },
      }
    end,
  },

  -- statuscol
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPost', 'BufNewFile', },
    config = function()
      local builtin = require 'statuscol.builtin'
      require 'statuscol'.setup {
        bt_ignore = { 'terminal', 'nofile', },
        relculright = true,
        segments = {
          { text = { builtin.foldfunc, }, click = 'v:lua.ScFa', },
          {
            sign = { name = { 'Diagnostic', }, maxwidth = 2, colwidth = 1, auto = true, },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.lnumfunc, }, click = 'v:lua.ScLa', },
          {
            sign = { name = { '.*', }, namespace = { '.*', }, maxwidth = 2, colwidth = 1, wrap = true, auto = true, },
            click = 'v:lua.ScSa',
          },
          { text = { '│', }, condition = { builtin.not_empty, }, },
        },
      }
    end,
  },

  -- indentblank
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'CursorMoved', 'CursorMovedI', },
    dependencies = {
      'echasnovski/mini.indentscope',
    },
    config = function()
      -- indentscope
      require 'mini.indentscope'.setup {
        symbol = '│',
        options = { try_as_border = true, },
      }
      -- indentblank
      require 'ibl'.setup {
        indent = {
          char = '│',
        },
        exclude = {
          filetypes = {
            --- my
            'qf',
            'mason',
            'notify',
            'startuptime',
            'NvimTree',
            'fugitive',
            'lazy',
            ---
            'lspinfo',
            'packer',
            'checkhealth',
            'help',
            'man',
            'gitcommit',
            'TelescopePrompt',
            'TelescopeResults',
            '',
          },
        },
      }
    end,
  },

  -- comment
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile', },
    dependencies = {
      'preservim/nerdcommenter',
    },
    keys = {
      { '<leader>c',  function() end,                                        mode = { 'n', 'v', }, desc = '---test.commenter---', },
      { '<leader>co', "}kvip:call nerdcommenter#Comment('x', 'invert')<CR>", mode = { 'n', },      desc = 'Nerdcommenter invert a paragraph', },
      { '<leader>cp', "}kvip:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', },      desc = 'Nerdcommenter toggle a paragraph', },
    },
    config = function()
      require 'base'.del_map({ 'n', 'v', }, '<leader>c')
      require 'which-key'.register { ['<leader>c'] = { name = 'test.commenter', }, }
      -- nerdcommenter
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = 'left'
      vim.g.NERDCommentEmptyLines = 1
      vim.g.NERDTrimTrailingWhitespace = 1
      vim.g.NERDToggleCheckAllLines = 1
      vim.g.NERDCustomDelimiters = {
        markdown = {
          left = '<!--',
          right = '-->',
          leftAlt = '[',
          rightAlt = ']: #',
        },
        c = {
          left = '//',
          right = '',
          leftAlt = '/*',
          rightAlt = '*/',
        },
      }
      require 'base'.aucmd({ 'BufEnter', }, 'test.commemt.BufEnter', {
        callback = function()
          if vim.bo.ft == 'python' then
            vim.g.NERDSpaceDelims = 0
          else
            vim.g.NERDSpaceDelims = 1
          end
        end,
      })
      -- Comment.nvim
      require 'Comment'.setup {}
    end,
  },

  -- autosave
  {
    'Pocco81/auto-save.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile', },
    config = function()
      require 'auto-save'.setup {
        execution_message = { message = function() return '' end, },
      }
    end,
  },

  -- sessions
  {
    'natecraddock/sessions.nvim',
    lazy = false,
    config = function()
      require 'sessions'.setup {
        events = { 'VimLeavePre', },
        session_filepath = vim.fn.stdpath 'data' .. '\\sessions',
        absolute = true,
      }
    end,
  },

  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter', 'CursorMoved', },
    opts = {},
    dependencies = {
      'tpope/vim-surround',
    },
  },

  -- hop
  {
    'phaazon/hop.nvim',
    keys = {
      { 's', ':HopChar1<cr>', mode = { 'n', }, silent = true, desc = 'HopChar1', },
    },
    config = function()
      require 'hop'.setup {
        keys = 'asdghklqwertyuiopzxcvbnmfj',
      }
    end,
  },

  -- todo
  {
    -- 'folke/todo-comments.nvim',
    'peter-lyr/todo-comments.nvim',
    cmd = { 'TodoLocList', 'TodoTelescope', 'TodoQuickFix', },
    config = function()
      require 'todo-comments'.setup {
        keywords = {
          FIX = { icon = ' ', color = 'error', alt = { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', }, },
          TODO = { icon = ' ', color = 'info', alt = { 'TODO', }, },
          HACK = { icon = ' ', color = 'warning', alt = { 'HACK', }, },
          WARN = { icon = ' ', color = 'warning', alt = { 'WARN', 'WARNING', 'XXX', }, },
          PERF = { icon = ' ', alt = { 'PERF', 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', }, },
          NOTE = { icon = ' ', color = 'hint', alt = { 'NOTE', 'INFO', }, },
          TEST = { icon = '⏲ ', color = 'test', alt = { 'TEST', 'TESTING', 'PASSED', 'FAILED', }, },
        },
      }
    end,
  },

  -- notify
  {
    'rcarriga/nvim-notify',
    keys = {
      { '<esc>', function() require 'notify'.dismiss() end, mode = { 'n', }, silent = true, desc = 'notify dismiss notification', },
    },
    config = function()
      require 'notify'.setup {
        top_down = false,
        timeout = 3000,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
      }
      vim.notify = require 'notify'
    end,
  },

  -- spectre
  {
    'nvim-pack/nvim-spectre',
    keys = {
      { '<leader>r',      function() end,                                                            mode = { 'n', 'v', }, silent = true, desc = '---test.spectre---', },
      { '<leader>rf',     function() require 'spectre'.open_file_search { select_word = true, } end, mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cur cword', },
      { '<leader>r<c-f>', function() require 'spectre'.open_file_search() end,                       mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cur', },
      { '<leader>rw',     function() require 'spectre'.open_visual { select_word = true, } end,      mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cwd cword', },
      { '<leader>r<c-w>', function() require 'spectre'.open() end,                                   mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cwd', },
    },
    config = function()
      require 'base'.del_map({ 'n', 'v', }, '<leader>r')
      require 'which-key'.register { ['<leader>r'] = { name = 'test.spectre', }, }
      require 'spectre'.setup()
    end,
  },

  -- oil
  {
    'stevearc/oil.nvim',
    event = { 'BufReadPre', 'BufNewFile', 'FocusLost', },
    keys = {
      { '<c-q>', '<cmd>Oil<cr>',                                              mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_cur', },
      { '<c-3>', '<cmd>exe "Oil " . getcwd()<cr>',                            mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_cwd', },
      { '<c-`>', function() require 'base'.cmd_sel_dirvers 'Oil' end,         mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_cwd_dirs', },
      { '<c-1>', function() require 'base'.cmd_sel_cwd_dirs 'Oil' end,        mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_cwd_dirs', },
      { '<c-2>', function() require 'base'.cmd_sel_parent_dirs 'Oil' end,     mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_parent_dirs', },
      { '<c-4>', function() require 'base'.cmd_sel_all_git_repos 'Oil' end,   mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_all_git_repos', },
      { '<c-5>', function() require 'config.my.git'.get_all_git_repos(1) end, mode = { 'n', 'v', }, silent = true, desc = 'test.oil: cmd_sel_all_git_repos', },
    },
    opts = {
      keymaps = {
        ['<c-;>'] = 'actions.select',
        ['<c-2>'] = 'actions.select',
        ['<c-1>'] = 'actions.parent',
        ['<c-q>'] = 'actions.close',
        ['<c-3>'] = 'actions.close',
        ['gx'] = {
          callback = function()
            local entry = require 'oil'.get_cursor_entry()
            local dir = require 'oil'.get_current_dir()
            if not entry or not dir then return end
            require 'base'.system_run('start silent', 'start %s', dir .. entry.name)
          end,
          desc = 'test.oil: start',
          mode = { 'n', 'v', },
        },
      },
      columns = {
        'icon',
        'permissions',
        'size',
        'mtime',
      },
    },
  },

  -- bqf
  {
    'kevinhwang91/nvim-bqf',
    event = { 'LspAttach', 'CmdlineEnter', },
    config = function()
      require 'bqf'.setup {
        auto_resize_height = true,
        preview = {
          win_height = vim.fn.float2nr(vim.o.lines * 50 / 100 - 3),
          win_vheight = vim.fn.float2nr(vim.o.lines * 50 / 100 - 3),
          wrap = true,
        },
      }
    end,
  },

  -- minimap
  {
    'echasnovski/mini.map',
    version = '*',
    event = { 'BufReadPost', 'BufNewFile', },
    keys = {
      { '<c-\\>', function() require 'mini.map'.toggle() end,       mode = { 'n', 'v', }, silent = true, desc = 'test.minimap: toggle', },
      { '<a-\\>', function() require 'mini.map'.toggle_focus() end, mode = { 'n', 'v', }, silent = true, desc = 'test.minimap: toggle_focus', },
    },
    config = function()
      local minimap = require 'mini.map'
      local symbols = minimap.gen_encode_symbols.dot '4x2'
      symbols[1] = ' '
      minimap.setup {
        integrations = {
          minimap.gen_integration.builtin_search(),
          minimap.gen_integration.gitsigns(),
          minimap.gen_integration.diagnostic(),
        },
        symbols = {
          encode = symbols,
        },
        window = {
          focusable = true,
          -- side = 'right',
          -- show_integration_count = true,
          -- width = 10,
          -- winblend = 25,
          -- zindex = 10,
        },
      }
    end,
  },

}
