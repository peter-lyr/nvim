local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

vim.g.mkdp_highlight_css = B.get_filepath(B.getcreate_dir(M.source .. '.css'), 'mkdp_highlight.css').filename

return M
