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
      { '<leader>s',         function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope---', },
      { '<leader>sb',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.buffers---', },
      { '<leader>sbb',       function() require 'config.nvim.telescope'.buffers_all() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers all', },
      { '<leader>sbc',       function() require 'config.nvim.telescope'.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: buffers cur', },
      { '<leader>s<leader>', function() require 'config.nvim.telescope'.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: find_files', },
      { '<leader>sl',        function() require 'config.nvim.telescope'.live_grep() end,            mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: live_grep', },
      -- lsp
      { '<leader>f',         function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.lsp---', },
      { '<leader>fl',        function() require 'config.nvim.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: document_symbols', },
      { '<leader>fr',        function() require 'config.nvim.telescope'.lsp_references() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.lsp: references', },
      -- git
      { '<leader>g',         function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.git---', },
      { '<leader>gt',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.git.more---', },
      { '<leader>gf',        function() require 'config.nvim.telescope'.git_status() end,           mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: status', },
      { '<leader>gh',        function() require 'config.nvim.telescope'.git_branches() end,         mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope.git: branches', },
      --
      { '<leader>sv',        function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.more---', },
      { '<leader>svv',       function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope.more---', },
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
      { '<c-s-f12>',         function() require 'config.nvim.telescope' end,                        mode = { 'n', 'v', }, silent = true, desc = '---nvim.telescope---', },

      -- projects
      { '<leader>sk',        function() require 'config.nvim.telescope'.projects() end,             mode = { 'n', 'v', }, silent = true, desc = 'nvim.telescope: projects', },
    },
    config = function()
      require 'config.nvim.telescope'
    end,
  },

}
