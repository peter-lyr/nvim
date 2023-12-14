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
    event = { 'BufReadPre', 'BufNewFile', },
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
      { '<leader>co', "}kvip:call nerdcommenter#Comment('x', 'invert')<CR>", mode = { 'n', }, desc = 'Nerdcommenter invert a paragraph', },
      { '<leader>cp', "}kvip:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'Nerdcommenter toggle a paragraph', },
    },
    config = function()
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
      { '<leader>rf',     function() require 'spectre'.open_file_search { select_word = true, } end, mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cur cword', },
      { '<leader>r<c-f>', function() require 'spectre'.open_file_search() end,                       mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cur', },
      { '<leader>rw',     function() require 'spectre'.open_visual { select_word = true, } end,      mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cwd cword', },
      { '<leader>r<c-w>', function() require 'spectre'.open() end,                                   mode = { 'n', 'v', }, silent = true, desc = 'test.spectre: cwd', },
    },
    config = function()
      require 'spectre'.setup()
    end,
  },

  -- oil
  {
    'stevearc/oil.nvim',
    cmd = { 'Oil', },
    opts = {
      keymaps = {
        ['?'] = 'actions.show_help',
        ['a'] = 'actions.select',
        ['<Tab>'] = 'actions.preview',
      },
    },
  },

}
