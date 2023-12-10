return {

  -- my.window
  {
    name = 'my.window',
    dir = '',
    keys = {
      { '<a-h>',   function() require 'config.my.window'.width_less_1() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less_1', },
      { '<a-l>',   function() require 'config.my.window'.width_more_1() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more_1', },
      { '<a-k>',   function() require 'config.my.window'.height_less_1() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less_1', },
      { '<a-j>',   function() require 'config.my.window'.height_more_1() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more_1', },
      { '<a-s-h>', function() require 'config.my.window'.width_less_10() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less_10', },
      { '<a-s-l>', function() require 'config.my.window'.width_more_10() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more_10', },
      { '<a-s-k>', function() require 'config.my.window'.height_less_10() end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less_10', },
      { '<a-s-j>', function() require 'config.my.window'.height_more_10() end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more_10', },
    },
  },

  -- my.options
  {
    name = 'my.options',
    dir = '',
    event = 'VeryLazy',
    config = function()
      require 'config.my.options'
    end,
  },

  -- my.maps
  {
    name = 'my.maps',
    dir = '',
    event = 'VeryLazy',
    config = function()
      require 'config.my.maps'
    end,
  },

  -- my.bufreadpost
  {
    name = 'my.bufreadpost',
    dir = '',
    event = 'BufReadPost',
    config = function()
      require 'config.my.bufreadpost'
    end,
  },

  -- my.textyankpost
  {
    name = 'my.textyankpost',
    dir = '',
    event = 'TextYankPost',
    config = function()
      require 'config.my.textyankpost'
    end,
  },

  -- my.git
  {
    name = 'my.git',
    dir = '',
    event = { 'BufReadPre', 'BufNewFile', },
    cmd = {
      'Git',
      'Gitsings',
      'DiffviewOpen', 'DiffviewFileHistory',
    },
    keys = {
      { '<leader>g',   function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git---', },
      { '<leader>gg',  function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git.push---', },
      { '<leader>ga',  function() require 'config.my.git'.addcommitpush() end,   mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: addcommitpush', },
      { '<leader>gp',  function() require 'config.my.git'.pull() end,            mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: pull', },
      { '<leader>gc',  function() require 'config.my.git'.commit_push() end,     mode = { 'n', 'v', }, silent = true, desc = 'my.git.push: commit_push', },

      --
      { '<leader>gm',  function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git.signs---', },
      { '<leader>gmt', function() require 'config.my.git' end,                   mode = { 'n', 'v', }, silent = true, desc = '---my.git.signs.toggle---', },
      { 'ig',          ':<C-U>Gitsigns select_hunk<CR>',                         mode = { 'o', 'x', }, silent = true, desc = 'my.git.signs select_hunk', },
      { 'ag',          ':<C-U>Gitsigns select_hunk<CR>',                         mode = { 'o', 'x', }, silent = true, desc = 'my.git.signs select_hunk', },
      { '<leader>j',   desc = 'my.git.signs next_hunk', },
      { '<leader>k',   desc = 'my.git.signs prev_hunk', },
      { '<leader>gd',  function() require 'config.my.git'.diffthis() end,        mode = { 'n', },      silent = true, desc = 'diffthis', },
      { '<leader>gr',  function() require 'config.my.git'.reset_hunk() end,      mode = { 'n', },      silent = true, desc = 'reset_hunk', },
      { '<leader>gr',  function() require 'config.my.git'.reset_hunk_v() end,    mode = { 'v', },      silent = true, desc = 'reset_hunk_v', },
      { '<leader>gs',  function() require 'config.my.git'.stage_hunk() end,      mode = { 'n', },      silent = true, desc = 'stage_hunk', },
      { '<leader>gs',  function() require 'config.my.git'.stage_hunk_v() end,    mode = { 'v', },      silent = true, desc = 'stage_hunk_v', },
      { '<leader>gu',  function() require 'config.my.git'.undo_stage_hunk() end, mode = { 'n', },      silent = true, desc = 'undo_stage_hunk', },

    },
    dependencies = {
      'rcarriga/nvim-notify',
      'skywind3000/asyncrun.vim',
      'tpope/vim-fugitive',
      -- 'lewis6991/gitsigns.nvim',
      'peter-lyr/gitsigns.nvim',
      -- 'sindrets/diffview.nvim',
      'peter-lyr/diffview.nvim',
    },
    config = function()
      require 'config.my.git'
    end,
  },

}
