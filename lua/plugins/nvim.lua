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
      'andymass/vim-matchup',
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
      'nvim-telescope/telescope-ui-select.nvim',
      'ahmedkhalf/project.nvim',
      'nvim-tree/nvim-web-devicons',
      'rcarriga/nvim-notify',
    },
    keys = {
      -- builtins
      { '<leader>s',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope---', },
      { '<leader><leader>', function() require 'config.nvim.telescope'.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
      { '<leader>l',        function() require 'config.nvim.telescope'.live_grep() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep', },
      { '<leader>h',        function() require 'config.nvim.telescope'.command_history() end,      mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: command_history', },
      { '<leader><c-h>',    function() require 'config.nvim.telescope'.commands() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: commands', },
      { '<leader>b',        function() require 'config.nvim.telescope'.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers cur', },
      { '<leader><c-b>',    function() require 'config.nvim.telescope'.buffers_all() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers all', },
      -- lsp
      { '<leader>f',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.lsp---', },
      { '<leader>fl',       function() require 'config.nvim.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: document_symbols', },
      { '<leader>fr',       function() require 'config.nvim.telescope'.lsp_references() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: references', },
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
    lazy = true,
    version = false, -- last release is way too old
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
    keys = {
      { '<leader>f',  function() require 'config.nvim.lsp' end,          mode = { 'n', 'v', }, desc = '---nvim.lsp---', },
      { '<leader>fv', function() require 'config.nvim.lsp' end,          mode = { 'n', 'v', }, desc = '---nvim.lsp.more---', },
      { '<leader>ff', function() require 'config.nvim.lsp'.format() end, mode = { 'n', 'v', }, desc = 'config.nvim.lsp: format', },
      { '<leader>fn', function() require 'config.nvim.lsp'.rename() end, mode = { 'n', 'v', }, desc = 'config.nvim.lsp: rename', },
    },
    config = function()
      require 'config.nvim.lsp'
    end,
  },

}
