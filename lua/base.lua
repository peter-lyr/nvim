local M = {}

function M.aucmd(event, desc, opts)
  opts = vim.tbl_deep_extend(
    'force',
    opts,
    {
      group = vim.api.nvim_create_augroup(desc, {}),
      desc = desc,
    })
  return vim.api.nvim_create_autocmd(event, opts)
end

function M.getlua(luafile)
  local lua = string.match(luafile, '.+lua/(.+)%.lua')
  lua = string.gsub(lua, '/', '.')
  return lua
end

return M
