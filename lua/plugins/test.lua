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

  -- dial
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', function() return require 'dial.map'.inc_normal() end, expr = true, desc = 'Increment', },
      { '<C-x>', function() return require 'dial.map'.dec_normal() end, expr = true, desc = 'Decrement', },
    },
    config = function()
      local augend = require 'dial.augend'
      require 'dial.config'.augends:register_group {
        default = {
          augend.constant.alias.de_weekday,
          augend.constant.alias.de_weekday_full,
          -- augend.constant.new { elements = { '&&', '||', }, word = false, },
          -- augend.constant.new { elements = { '<', '>', }, },
          -- augend.constant.new { elements = { '+', '-', }, },
          -- augend.constant.new { elements = { '*', '/', }, },
          -- augend.constant.new { elements = { '<=', '>=', }, },
          -- augend.constant.new { elements = { '==', '!=', }, word = false, },
          -- augend.constant.new { elements = { '++', '--', }, word = false, },
          augend.constant.new { elements = { '[ ]', '[x]', }, word = false, },
          augend.constant.new { elements = { 'TRUE', 'FALSE', }, },
          augend.constant.new { elements = { 'True', 'False', }, },
          augend.constant.new { elements = { 'true', 'false', }, },
          augend.constant.new { elements = { 'YES', 'NO', }, },
          augend.constant.new { elements = { 'Yes', 'No', }, },
          augend.constant.new { elements = { 'and', 'or', }, },
          augend.constant.new { elements = { 'yes', 'no', }, },
          augend.constant.new { elements = { 'on', 'off', }, },
          augend.constant.new { elements = { 'On', 'Off', }, },
          augend.constant.new { elements = { 'ON', 'OFF', }, },
          augend.constant.new { elements = { '_prev', '_next', }, word = false, },
          augend.constant.new { elements = { 'prev_', 'next_', }, word = false, },
          augend.constant.new { elements = { 'Prev', 'Next', }, word = false, },
          -- c
          augend.constant.new { elements = { '%d', '%s', '%x', }, word = false, },
          augend.constant.new { elements = { 'signed', 'unsigned', }, },
          augend.constant.new { elements = { 'u8', 'u16', 'u32', 'u64', }, },
          augend.constant.new { elements = { 's8', 's16', 's32', 's64', }, },
          augend.constant.new { elements = { 'char', 'short', 'int', 'long', }, },
          -- date time
          augend.date.alias['%-d.%-m.'],
          augend.date.alias['%-m/%-d'],
          augend.date.alias['%H:%M'],
          augend.date.alias['%H:%M:%S'],
          augend.date.alias['%Y-%m-%d'],
          augend.date.alias['%Y/%m/%d'],
          augend.date.alias['%Y年%-m月%-d日'],
          augend.date.alias['%d.%m.'],
          augend.date.alias['%d.%m.%Y'],
          augend.date.alias['%d.%m.%y'],
          augend.date.alias['%d/%m/%Y'],
          augend.date.alias['%d/%m/%y'],
          augend.date.alias['%m/%d'],
          augend.date.alias['%m/%d/%Y'],
          augend.date.alias['%m/%d/%y'],
          augend.date.alias['%H:%M'],
          augend.date.alias['%Y-%m-%d'],
          augend.date.alias['%Y/%m/%d'],
          augend.date.alias['%m/%d'],
          augend.integer.alias.binary,
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.semver.alias.semver,
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
      { '<RightMouse>', function() end,                                   mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree', },
      {
        '<c-bs>',
        function()
          require 'mini.map'.toggle()
          vim.cmd 'Lazy load aerial.nvim'
          vim.cmd 'AerialClose'
        end,
        mode = { 'n', 'v', },
        silent = true,
        desc = 'test.minimap: toggle',
      },
      { '<a-\\>',       function() require 'mini.map'.toggle_focus() end, mode = { 'n', 'v', }, silent = true, desc = 'test.minimap: toggle_focus', },
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
      require 'base'.del_map({ 'n', 'v', }, '<RightMouse>')
      vim.cmd [[
        anoremenu PopUp.-5-             <Nop>
        nnoremenu PopUp.Minimap\ Toggle :lua require 'mini.map'.toggle()<cr>
        vnoremenu PopUp.Minimap\ Toggle :<C-U>lua require 'mini.map'.toggle()<cr>
        inoremenu PopUp.Minimap\ Toggle <C-O>:<C-u>lua require 'mini.map'.toggle()<cr>
      ]]
    end,
  },

  -- aerial
  {
    'stevearc/aerial.nvim',
    event = { 'LspAttach', },
    cmd = {
      'AerialToggle',
    },
    keys = {
      { '<RightMouse>', function() end,        mode = { 'n', 'v', }, silent = true, desc = 'test.aerial', },
      {
        '<c-]>',
        function()
          vim.cmd 'AerialToggle'
          require 'mini.map'.close()
        end,
        mode = { 'n', 'v', },
        silent = true,
        desc = 'test.aerial: toggle',
      },
      { ']a',           '<cmd>AerialNext<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialNext', },
      { '[a',           '<cmd>AerialPrev<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialPrev', },
    },
    config = function()
      require 'aerial'.setup {
        layout = {
          max_width = 20,
          min_width = 10,
          preserve_equality = nil,
          default_direction = 'right',
        },
        keymaps = {
          ['<C-s>'] = false,
          ['<C-j>'] = false,
          ['<C-k>'] = false,
          ['a'] = 'actions.jump',
          ['o'] = 'actions.jump',
          ['<2-LeftMouse>'] = 'actions.jump',
        },
        filter_kind = false,
        backends = { 'markdown', 'lsp', 'treesitter', 'man', },
        -- backends = { "lsp", },
        post_jump_cmd = [[norm zz]],
        close_automatic_events = {},
        close_on_select = false,
        float = {
          relative = 'editor',
        },
      }
      require 'base'.del_map({ 'n', 'v', }, '<RightMouse>')
      vim.cmd [[
        anoremenu PopUp.-6-             <Nop>
        nnoremenu PopUp.Aerial\ Toggle :AerialToggle<cr>
        vnoremenu PopUp.Aerial\ Toggle :<C-U>AerialToggle<cr>
        inoremenu PopUp.Aerial\ Toggle <C-O>:<C-u>AerialToggle<cr>
      ]]
    end,
  },

  -- nvim-tree
  {
    'nvim-tree/nvim-tree.lua',
    commit = '00741206',
    event = { 'BufReadPre', 'BufNewFile', },
    cmd = {
      'NvimTree',
      'NvimTreeOpen',
      'NvimTreeFindFile',
      'NvimTreeFindFileToggle',
    },
    keys = {
      { '<RightMouse>', function() end,                                                      mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree', },

      { '<c-;>',        function() require 'base'.all_commands() end,                        mode = { 'n', 'v', }, silent = true, desc = 'base: all commands', },
      { '<c-f>',        '<cmd>NvimTreeFindFileToggle<cr>',                                   mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: NvimTreeFindFileToggle', },

      { '<c-s-cr>',     function() require 'config.test.nvimtree'.last_dir() end,            mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: last_dir', },

      { '<c-`>',        function() require 'config.test.nvimtree'.sel_dirvers() end,         mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: sel_dirvers', },
      { '<c-1>',        function() require 'config.test.nvimtree'.sel_parent_dirs() end,     mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: sel_parent_dirs', },
      { '<c-2>',        function() require 'config.test.nvimtree'.sel_my_dirs() end,         mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: sel_my_dirs', },
      { '<c-3>',        function() require 'config.test.nvimtree'.sel_SHGetFolderPath() end, mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: sel_SHGetFolderPath', },

      { '<c-4>',        function() require 'config.test.nvimtree'.sel_all_git_repos() end,   mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: sel_all_git_repos', },
      { '<c-s-4>',      function() require 'config.my.git'.get_all_git_repos(1) end,         mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: get_all_git_repos', },

      { '<leader>dj',   function() require 'config.test.nvimtree'.open_next_tree_node() end, mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: open_next_tree_node', },
      { '<leader>dk',   function() require 'config.test.nvimtree'.open_prev_tree_node() end, mode = { 'n', 'v', }, silent = true, desc = 'test.nvimtree: open_prev_tree_node', },
    },
    config = function() require 'config.test.nvimtree' end,
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function() require 'colorizer'.setup() end,
  },

  -- searchindex
  {
    'google/vim-searchindex',
    event = { 'BufReadPost', 'BufNewFile', },
    config = function()
      vim.g.searchindex_line_limit = 100 * 10000 * 10000 -- 100亿
    end,
  },

  -- input method switcher
  {
    'Neur1n/neuims',
    lazy = false,
    config = function()
      vim.cmd 'IMSToggle'
    end,
  },

}
