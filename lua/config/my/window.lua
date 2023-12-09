local M = {}

function M.width_less_1() vim.cmd 'wincmd <' end

function M.width_more_1() vim.cmd 'wincmd >' end

function M.height_less_1() vim.cmd 'wincmd -' end

function M.height_more_1() vim.cmd 'wincmd +' end

function M.width_less_10() vim.cmd '10wincmd <' end

function M.width_more_10() vim.cmd '10wincmd >' end

function M.height_less_10() vim.cmd '10wincmd -' end

function M.height_more_10() vim.cmd '10wincmd +' end

return M
