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

}
