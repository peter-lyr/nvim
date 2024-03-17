return {

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    version = '*', -- last release
    build = ':TSUpdate',
    ft = {
      'c', 'cpp',
      'python',
      'lua',
      'markdown',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'andymass/vim-matchup',
        init = function()
          vim.g.matchup_matchparen_offscreen = {}
        end,
      },
      'nvim-treesitter/nvim-treesitter-context',
      'p00f/nvim-ts-rainbow',
    },
    config = function()
      require 'config.nvim.treesitter'
    end,
  },

  -- telescope
  {
    'peter-lyr/telescope.nvim',
    branch = '0.1.x',
    cmd = {
      'Telescope',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'paopaol/telescope-git-diffs.nvim',
      -- 'nvim-telescope/telescope-ui-select.nvim',
      -- 'peter-lyr/telescope-ui-select.nvim',
      'ahmedkhalf/project.nvim',
      'nvim-tree/nvim-web-devicons',
      'dbakker/vim-projectroot',
    },
    keys = {
      -- builtins
      { '<leader>s',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope---', },

      { '<leader><leader>', function() require 'config.nvim.telescope'.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
      { '<leader>m',        function() require 'config.nvim.telescope'.find_files_curdir() end,    mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_curdir', },
      { '<leader><c-m>',    function() require 'config.nvim.telescope'.find_files_pardir() end,    mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_pardir', },
      { '<leader>M',        function() require 'config.nvim.telescope'.find_files_pardir_2() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_pardir_2', },
      { '<leader><c-s-m>',  function() require 'config.nvim.telescope'.find_files_pardir_3() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_pardir_3', },
      { '<leader><a-m>',    function() require 'config.nvim.telescope'.find_files_pardir_4() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_pardir_4', },
      { '<leader><a-s-m>',  function() require 'config.nvim.telescope'.find_files_pardir_5() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_pardir_5', },
      { '<leader>e',        function() require 'config.nvim.telescope'.everything() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: everything', },
      { '<leader><c-e>',    function() require 'config.nvim.telescope'.everything_regex() end,     mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: everything', },

      { '<leader>p',        function() require 'config.nvim.telescope'.pure_curdir() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: pure_curdir', },
      { '<leader><c-p>',    function() require 'config.nvim.telescope'.pure_pardir() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: pure_pardir', },
      { '<leader>P',        function() require 'config.nvim.telescope'.pure_pardir_2() end,        mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: pure_pardir_2', },
      { '<leader><c-s-p>',  function() require 'config.nvim.telescope'.pure_pardir_3() end,        mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: pure_pardir_3', },
      { '<leader><a-p>',    function() require 'config.nvim.telescope'.pure_pardir_4() end,        mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: pure_pardir_4', },
      { '<leader><a-s-p>',  function() require 'config.nvim.telescope'.pure_pardir_5() end,        mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: pure_pardir_5', },

      { '<leader>l',        function() require 'config.nvim.telescope'.live_grep() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep', },
      { '<leader><c-l>',    function() require 'config.nvim.telescope'.live_grep_curdir() end,     mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_curdir', },
      { '<leader>L',        function() require 'config.nvim.telescope'.live_grep_pardir() end,     mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_pardir', },
      { '<leader><c-s-l>',  function() require 'config.nvim.telescope'.live_grep_pardir_2() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_pardir2', },
      { '<leader><a-l>',    function() require 'config.nvim.telescope'.live_grep_pardir_3() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_pardir3', },
      { '<leader><a-s-l>',  function() require 'config.nvim.telescope'.live_grep_pardir_4() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_pardir4', },

      { '<leader>ss',       function() require 'config.nvim.telescope'.grep_string() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string', },
      { '<leader>s<c-s>',   function() require 'config.nvim.telescope'.grep_string_curdir() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string_curdir', },
      { '<leader>sS',       function() require 'config.nvim.telescope'.grep_string_pardir() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string_pardir', },
      { '<leader>s<c-s-s>', function() require 'config.nvim.telescope'.grep_string_pardir_2() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string_pardir_2', },
      { '<leader>s<a-s>',   function() require 'config.nvim.telescope'.grep_string_pardir_3() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string_pardir_3', },
      { '<leader>s<a-s-s>', function() require 'config.nvim.telescope'.grep_string_pardir_4() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: grep_string_pardir_4', },

      { '<leader>h',        function() require 'config.nvim.telescope'.command_history() end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: command_history', },
      { '<leader>n',        function() require 'config.nvim.telescope'.commands() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: commands', },

      { '<leader>b',        function() require 'config.nvim.telescope'.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers cur', },
      { '<leader><c-b>',    function() require 'config.nvim.telescope'.buffers_all() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers all', },

      { '<leader>so',       function() require 'config.nvim.telescope'.oldfiles() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: oldfiles', },
      -- git
      { '<leader>g',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.git---', },
      { '<leader>gt',       function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.git.more---', },
      { '<leader><c-f>',    function() require 'config.nvim.telescope'.git_status() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: status', },
      { '<leader>gh',       function() require 'config.nvim.telescope'.git_branches() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: branches', },
      --
      { '<leader>sv',       function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.more---', },
      { '<leader>svv',      function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.more---', },
      -- { '<leader>s<leader>',   function() require 'config.nvim.telescope'.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
      -- { '<leader>sv<leader>',  function() require 'config.nvim.telescope'.find_files_all() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_all', },
      -- { '<leader>sf<leader>',  function() require 'config.nvim.telescope'.find_files(1) end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files root', },
      -- { '<leader>sfv<leader>', function() require 'config.nvim.telescope'.find_files_all(1) end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files_all root', },
      -- { '<leader>sl',          function() require 'config.nvim.telescope'.live_grep() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep', },
      -- { '<leader>sL',          function() require 'config.nvim.telescope'.live_grep_all() end,        mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_all', },
      -- { '<leader>s<c-l>',      function() require 'config.nvim.telescope'.live_grep_rg() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_rg', },
      -- { '<leader>s<a-l>',      function() require 'config.nvim.telescope'.live_grep_rg_all() end,     mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep_rg_all', },
      -- { '<leader>sO',          function() require 'config.nvim.telescope'.open() end,                 mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: open', },

      -- mouse
      { '<c-s-f12>',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope---', },

      -- projects
      { '<leader>sk',       function() require 'config.nvim.telescope'.projects() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: projects', },
    },
    config = function()
      require 'config.nvim.telescope'
    end,
  },

  -- cmp
  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = { 'InsertEnter', 'CmdlineEnter', },
    ft = {
      'c', 'cpp',
      'lua',
      'markdown',
      'python',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
      'LazyVim/LazyVim',
    },
    config = function()
      require 'config.nvim.cmp'
    end,
  },

  -- lsp
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    ft = {
      'c', 'cpp',
      'lua',
      'python',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'jay-babu/mason-null-ls.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {}, },
      'folke/neodev.nvim',
      'smjonas/inc-rename.nvim',
      'LazyVim/LazyVim',
    },
    config = function()
      require 'config.nvim.lsp'
    end,
  },

}
