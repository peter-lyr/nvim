local B = require 'base'
local lua = B.getlua(debug.getinfo(1)['source'])

B.aucmd('TextYankPost', lua .. 'TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})
