return {

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
      { '<c-f>',    desc = 'nvimtree: toggle', },
      { '<c-s-cr>', desc = 'nvimtree: open tree in last dir', },
      { '<c-`>',    desc = 'nvimtree: open tree in dirvers(sel)', },
      { '<c-1>',    desc = 'nvimtree: open tree in parent dirs(sel)', },
      { '<c-2>',    desc = 'nvimtree: open tree in my dirs(sel)', },
      { '<c-3>',    desc = 'nvimtree: open tree in SHGetFolderPath(sel)', },
      { '<c-4>',    desc = 'nvimtree: open tree in all git repos(sel)', },
      { '<c-s-4>',  desc = 'nvimtree: open tree in all git repos(sel)(force)', },
      { '<c-5>',    desc = 'nvimtree: open tree in dirs(sel)', },
    },
    config = function() Require 'config.test.nvimtree' end,
  },

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
      { '<leader>s',        desc = 'telescope', },
      { '<c-s-f12>',        desc = 'telescope', },
      { '<leader><c-f>',    desc = 'telescope: find files in current project git modified', },
      { '<leader><leader>', desc = 'telescope: find files in current project', },
      { '<leader>m',        desc = 'telescope: find files curdir', },
      { '<leader><c-m>',    desc = 'telescope: find files pardir', },
      { '<leader>M',        desc = 'telescope: find files pardir 2', },
      { '<leader><c-s-m>',  desc = 'telescope: find files pardir 3', },
      { '<leader><a-m>',    desc = 'telescope: find files pardir 4', },
      { '<leader><a-s-m>',  desc = 'telescope: find files pardir 5', },
      { '<leader><c-b>',    desc = 'telescope: buffers in all', },
      { '<leader>b',        desc = 'telescope: buffers in current project', },
      { '<leader>e',        desc = 'telescope: everything.exe -noregex', },
      { '<leader><c-e>',    desc = 'telescope: everything.exe -regex', },
      { '<leader>h',        desc = 'telescope: command history', },
      { '<leader>n',        desc = 'telescope: command all', },
      { '<leader>p',        desc = 'telescope: pure curdir', },
      { '<leader><c-p>',    desc = 'telescope: pure pardir', },
      { '<leader>P',        desc = 'telescope: pure pardir 2', },
      { '<leader><c-s-p>',  desc = 'telescope: pure pardir 3', },
      { '<leader><a-p>',    desc = 'telescope: pure pardir 4', },
      { '<leader><a-s-p>',  desc = 'telescope: pure pardir 5', },
      { '<leader>l',        desc = 'telescope: live grep in current project', },
      { '<leader><c-l>',    desc = 'telescope: live grep curdir', },
      { '<leader>L',        desc = 'telescope: live grep pardir', },
      { '<leader><c-s-l>',  desc = 'telescope: live grep pardir2', },
      { '<leader><a-l>',    desc = 'telescope: live grep pardir3', },
      { '<leader><a-s-l>',  desc = 'telescope: live grep pardir4', },
    },
    config = function() require 'config.nvim.telescope' end,
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
      { '<leader>f', desc = 'lsp', },
      { '<C-F12>',   desc = 'lsp: declaration', },
      { '<F11>',     desc = 'lsp: ClangdSwitchSourceHeader', },
      { '<F12>',     desc = 'lsp: definition', },
      { '<S-F12>',   desc = 'lsp: references', },
      { '<A-F12>',   desc = 'lsp: hover', },
    },
    config = function() require 'config.nvim.lsp' end,
  },

}
