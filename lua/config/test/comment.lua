local B = require 'base'

-- nerdcommenter
vim.g.NERDSpaceDelims = 1
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines = 1
vim.g.NERDCustomDelimiters = {
  markdown = {
    left = '<!--',
    right = '-->',
    leftAlt = '[',
    rightAlt = ']: #',
  },
  c = {
    left = '//',
    right = '',
    leftAlt = '/*',
    rightAlt = '*/',
  },
}

B.aucmd({ 'BufEnter', }, 'test.commemt.BufEnter', {
  callback = function()
    if vim.bo.ft == 'python' then
      vim.g.NERDSpaceDelims = 0
    else
      vim.g.NERDSpaceDelims = 1
    end
  end,
})

B.lazy_map {
  { '<leader>co', "}kvip:call nerdcommenter#Comment('x', 'invert')<CR>", mode = { 'n', }, desc = 'Nerdcommenter invert a paragraph', },
  { '<leader>cp', "}kvip:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'Nerdcommenter toggle a paragraph', },
}

-- Comment.nvim
require 'Comment'.setup {
  padding = true,
  sticky = true,
  ignore = nil,
  toggler = {
    line = 'gc<leader>',  -- 'gcc',
    block = 'gb<leader>', -- 'gbc',
  },
  opleader = {
    line = 'gc',
    block = 'gb',
  },
  extra = {
    above = 'gcO',
    below = 'gco',
    eol = 'gcA',
  },
  mappings = {
    basic = true,
    extra = true,
  },
  pre_hook = nil,
  post_hook = nil,
}
