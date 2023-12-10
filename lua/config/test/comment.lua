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
  ---Add a space b/w comment and the line
  padding = true,
  ---Whether the cursor should stay at its position
  sticky = true,
  ---Lines to be ignored while (un)comment
  ignore = nil,
  ---LHS of toggle mappings in NORMAL mode
  toggler = {
    ---Line-comment toggle keymap
    line = 'gc<leader>',  -- 'gcc',
    ---Block-comment toggle keymap
    block = 'gb<leader>', -- 'gbc',
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = 'gc',
    ---Block-comment keymap
    block = 'gb',
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = 'gcO',
    ---Add comment on the line below
    below = 'gco',
    ---Add comment at the end of line
    eol = 'gcA',
  },
  ---Enable keybindings
  mappings = {
    ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
    basic = true,
    ---Extra mapping; `gco`, `gcO`, `gcA`
    extra = true,
  },
  ---Function to call before (un)comment
  pre_hook = nil,
  ---Function to call after (un)comment
  post_hook = nil,
}
