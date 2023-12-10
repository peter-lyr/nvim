local B = require 'base'

B.aucmd('TextYankPost', 'my.textyankpost.TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})
