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
      { '<leader><c-b>',    function() require 'config.nvim.telescope'.buffers_all() end,        desc = 'telescope: buffers all',        mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-e>',    function() require 'config.nvim.telescope'.everything_regex() end,   desc = 'telescope: everything',         mode = { 'n', 'v', }, silent = true, },
      { '<leader><c-f>',    function() require 'config.nvim.telescope'.git_status() end,         desc = 'git.telescope: status',         mode = { 'n', 'v', }, silent = true, },
      { '<leader><leader>', function() require 'config.nvim.telescope'.find_files() end,         desc = 'telescope: find_files',         mode = { 'n', 'v', }, silent = true, },
      { '<leader>b',        function() require 'config.nvim.telescope'.buffers_cur() end,        desc = 'telescope: buffers cur',        mode = { 'n', 'v', }, silent = true, },
      { '<leader>e',        function() require 'config.nvim.telescope'.everything() end,         desc = 'telescope: everything',         mode = { 'n', 'v', }, silent = true, },
      { '<leader>h',        function() require 'config.nvim.telescope'.command_history() end,    desc = 'telescope: command_history',    mode = { 'n', 'v', }, silent = true, },
      { '<leader>l',        function() require 'config.nvim.telescope'.live_grep() end,          desc = 'telescope: live_grep',          mode = { 'n', 'v', }, silent = true, },
      { '<leader>m',        function() require 'config.nvim.telescope'.find_files_curdir() end,  desc = 'telescope: find_files_curdir',  mode = { 'n', 'v', }, silent = true, },
      { '<leader>n',        function() require 'config.nvim.telescope'.commands() end,           desc = 'telescope: commands',           mode = { 'n', 'v', }, silent = true, },
      { '<leader>p',        function() require 'config.nvim.telescope'.pure_curdir() end,        desc = 'telescope: pure_curdir',        mode = { 'n', 'v', }, silent = true, },
      { '<leader>s<c-r>',   function() require 'config.nvim.telescope'.root_sel_switch() end,    desc = 'telescope: root_sel_switch',    mode = { 'n', 'v', }, silent = true, },
      { '<leader>sO',       function() require 'config.nvim.telescope'.open_telescope_lua() end, desc = 'telescope: open telescope.lua', mode = { 'n', 'v', }, silent = true, },
      { '<leader>sh',       function() require 'config.nvim.telescope'.search_history() end,     desc = 'telescope: search_history',     mode = { 'n', 'v', }, silent = true, },
      { '<leader>sj',       function() require 'config.nvim.telescope'.jumplist() end,           desc = 'telescope: jumplist',           mode = { 'n', 'v', }, silent = true, },
      { '<leader>sk',       function() require 'config.nvim.telescope'.projects() end,           desc = 'telescope: projects',           mode = { 'n', 'v', }, silent = true, },
      { '<leader>sm',       function() require 'config.nvim.telescope'.keymaps() end,            desc = 'telescope: keymaps',            mode = { 'n', 'v', }, silent = true, },
      { '<leader>so',       function() require 'config.nvim.telescope'.oldfiles() end,           desc = 'telescope: oldfiles',           mode = { 'n', 'v', }, silent = true, },
      { '<leader>sr',       function() require 'config.nvim.telescope'.root_sel_till_git() end,  desc = 'telescope: root_sel_till_git',  mode = { 'n', 'v', }, silent = true, },
      { '<leader>ss',       function() require 'config.nvim.telescope'.grep_string() end,        desc = 'telescope: grep_string',        mode = { 'n', 'v', }, silent = true, },
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
      { '<leader>ff', function() require 'config.nvim.lsp'.format() end,                     desc = 'lsp: format',                     mode = { 'n', 'v', }, silent = true, },
      { '<leader>fl', function() require 'config.nvim.telescope'.lsp_document_symbols() end, desc = 'telescope.lsp: document_symbols', mode = { 'n', 'v', }, silent = true, },
      { '<leader>fr', function() require 'config.nvim.telescope'.lsp_references() end,       desc = 'telescope.lsp: references',       mode = { 'n', 'v', }, silent = true, },
    },
    config = function() require 'config.nvim.lsp' end,
  },

}
