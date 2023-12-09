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

}
