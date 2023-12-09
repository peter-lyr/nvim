local M = {}

function M.width_less()
  vim.cmd '10wincmd <'
end

function M.width_more()
  vim.cmd '10wincmd >'
end

function M.height_less()
  vim.cmd '5wincmd -'
end

function M.height_more()
  vim.cmd '5wincmd +'
end

return M
