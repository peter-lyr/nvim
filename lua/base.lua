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

--------------------

function M.rep_slash(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function M.rep_slash_lower(content)
  return vim.fn.tolower(M.rep_slash(content))
end

function M.rep_backslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function M.rep_backslash_lower(content)
  return vim.fn.tolower(M.rep_backslash(content))
end

--------------------

function M.totable(var)
  if type(var) ~= 'table' then
    var = { var, }
  end
  return var
end

function M.getcreate_dirpath(dirs)
  dirs = M.totable(dirs)
  local dir1 = table.remove(dirs, 1)
  dir1 = M.rep_slash(dir1)
  local dir_path = require 'plenary.path':new(dir1)
  for _, dir in ipairs(dirs) do
    if not dir_path:exists() then
      vim.fn.mkdir(dir_path.filename)
    end
    dir_path = dir_path:joinpath(dir)
  end
  return dir_path
end

function M.getcreate_stddata_dirpath(dirs)
  dirs = M.totable(dirs)
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return M.getcreate_dirpath(dirs)
end

---------

function M.set_timeout(timeout, callback)
  return vim.fn.timer_start(timeout, function()
    callback()
  end, { ['repeat'] = 1, })
end

function M.set_interval(interval, callback)
  return vim.fn.timer_start(interval, function()
    callback()
  end, { ['repeat'] = -1, })
end

function M.clear_interval(timer)
  pcall(vim.fn.timer_stop, timer)
end

---------

return M
