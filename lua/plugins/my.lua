return {

  -- my.window
  {
    name = 'my.window',
    dir = '',
    keys = {
      { '<a-h>', function() require 'config.my.window'.width_less() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less', },
      { '<a-l>', function() require 'config.my.window'.width_more() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more', },
      { '<a-k>', function() require 'config.my.window'.height_less() end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less', },
      { '<a-j>', function() require 'config.my.window'.height_more() end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more', },
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

}
