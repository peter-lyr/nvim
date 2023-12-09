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
      -- <leader>s
      { '<leader>s',         desc = ' + nvim.telescope', },

      -- <leader>sb
      { '<leader>sb',        desc = ' + nvim.telescope.buffers', },
      { '<leader>sbb',       function() require 'config.nvim.telescope'.buffers_all() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers all', },
      { '<leader>sbc',       function() require 'config.nvim.telescope'.buffers_cur() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers cur', },

      --
      { '<leader>s<leader>', function() require 'config.nvim.telescope'.find_files() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
      { '<leader>sl',        function() require 'config.nvim.telescope'.live_grep() end,   mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep', },

      -- projects
      { '<leader>sk',        function() require 'config.nvim.telescope'.projects() end,    mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: projects', },
    },
    config = function()
      require 'config.nvim.telescope'
    end,
  },

}
