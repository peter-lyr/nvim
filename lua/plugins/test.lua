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
      vim.fn.timer_start(1000, function()
        vim.cmd.colorscheme 'catppuccin'
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
      require 'config.test.whichkey'.setup()
    end,
  },

  -- statuscol
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPost', 'BufNewFile', },
    config = function()
      require 'config.test.statuscol'.setup()
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
      require 'config.test.indentblank'
    end,
  },

  -- comment
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile', },
    dependencies = {
      'preservim/nerdcommenter',
    },
    config = function()
      require 'config.test.comment'
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
    keys = {
      { '<leader>t',  function() require 'config.test.todo' end, mode = { 'n', 'v', }, silent = true, desc = 'test.todo', },
      { '<leader>tl', function() require 'config.test.todo' end, mode = { 'n', 'v', }, silent = true, desc = 'test.todo.locallist', },
      { '<leader>tt', function() require 'config.test.todo' end, mode = { 'n', 'v', }, silent = true, desc = 'test.todo.telescope', },
      { '<leader>tq', function() require 'config.test.todo' end, mode = { 'n', 'v', }, silent = true, desc = 'test.todo.quickfix', },
    },
    config = function()
      require 'config.test.todo'
    end,
  },

}
