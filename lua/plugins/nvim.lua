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
    config = function() Require 'config.nvim.treesitter' end,
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
      { '<leader>sk',       function() require 'config.nvim.telescope'.projects() end,        desc = 'telescope: projects',        mode = { 'n', 'v', }, silent = true, },
      { '<leader><leader>', function() require 'config.nvim.telescope'.find_files() end,      desc = 'telescope: find_files',      mode = { 'n', 'v', }, silent = true, },
      { '<leader>l',        function() require 'config.nvim.telescope'.live_grep() end,       desc = 'telescope: live_grep',       mode = { 'n', 'v', }, silent = true, },
      { '<leader>h',        function() require 'config.nvim.telescope'.command_history() end, desc = 'telescope: command_history', mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-f>',    function() require 'config.nvim.telescope'.git_status() end,      desc = 'git.telescope: status',      mode = { 'n', 'v', }, silent = true, },
      { '<leader>sj',       function() require 'config.nvim.telescope'.jumplist() end,        desc = 'telescope: jumplist',        mode = { 'n', 'v', }, silent = true, },
    },
    config = function() Require 'config.nvim.telescope' end,
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
    config = function() require 'config.nvim.cmp' end,
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
      { '<leader>ff', function() require 'config.nvim.lsp'.format() end, desc = 'lsp: format', mode = { 'n', 'v', }, silent = true, },
    },
    config = function() require 'config.nvim.lsp' end,
  },

}

