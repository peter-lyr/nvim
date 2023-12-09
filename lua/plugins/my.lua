return {
  {
    name = 'my.window',
    dir = '',
    lazy = true,
    keys = {
      { '<a-h>', function() require 'config.my.window'.width_less() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_less', },
      { '<a-l>', function() require 'config.my.window'.width_more() end,  mode = { 'n', 'v', }, silent = true, desc = 'my.window: width_more', },
      { '<a-k>', function() require 'config.my.window'.height_less() end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_less', },
      { '<a-j>', function() require 'config.my.window'.height_more() end, mode = { 'n', 'v', }, silent = true, desc = 'my.window: height_more', },
    },
  },
}
