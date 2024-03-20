-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/20 23:54:11 星期三

local M = {}

local B = require 'base'

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua = B.getlua(M.source)

vim.api.nvim_create_user_command('MapFromLazyToWhichkey', function(params)
  M.map_from_lazy_to_whichkey(unpack(params['fargs']))
end, { nargs = 0, })

function M.map_from_lazy_to_whichkey(fname)
  if not fname then
    fname = string.gsub(vim.api.nvim_buf_get_name(0), '/', '\\')
  end
  if #fname == 0 then
    return
  end
  local new_lines = {}
  for _, line in ipairs(vim.fn.readfile(fname)) do
    local res = string.match(line, '^ +({.*mode *= *.*}) *,')
    if not res then
      res = string.match(line, '^ +({.*name *= *.*}) *,')
    end
    if res then
      local item = loadstring('return ' .. res)
      if item then
        local val = item()
        if type(val[2]) == 'function' then
          val[2] = string.match(res, '(function().+end),')
        end
        local lhs = table.remove(val, 1)
        if not val['name'] then
          val[#val + 1] = val['desc']
          val['desc'] = nil
        end
        local temp = string.gsub(vim.inspect { [lhs] = val, }, '%s+', ' ')
        temp = string.gsub(temp, '"(function().+end)",', '%1,')
        temp = string.gsub(temp, '\\"', '"')
        temp = string.gsub(temp, '{(.+)}', '%1')
        temp = vim.fn.trim(temp) .. ','
        new_lines[#new_lines + 1] = '  ' .. temp
      else
        new_lines[#new_lines + 1] = line
      end
    else
      new_lines[#new_lines + 1] = line
    end
  end
  vim.cmd 'e!'
  require 'plenary.path':new(fname):write(vim.fn.join(new_lines, '\r\n'), 'w')
end

vim.api.nvim_create_user_command('MapFromWhichkeyToLazy', function(params)
  M.map_from_whichkey_to_lazy(unpack(params['fargs']))
end, { nargs = 0, })

function M.map_from_whichkey_to_lazy(fname)
  if not fname then
    fname = string.gsub(vim.api.nvim_buf_get_name(0), '/', '\\')
  end
  if #fname == 0 then
    return
  end
  local new_lines = {}
  for _, line in ipairs(vim.fn.readfile(fname)) do
    local res = string.match(line, '^.+ *=.*{.*mode *=.+} *,')
    if res then
      local item = loadstring('return {' .. res .. '}')
      if item then
        local val = item()
        for lhs, d in pairs(val) do
          if type(d[1]) == 'function' then
            d[1] = string.match(res, '(function().+end),')
          end
          table.insert(d, 1, lhs)
          d['desc'] = table.remove(d, 3)
          local temp = string.gsub(vim.inspect(d), '%s+', ' ')
          temp = string.gsub(temp, '"(function().+end)",', '%1,')
          temp = string.gsub(temp, '\\"', '"')
          temp = vim.fn.trim(temp) .. ','
          new_lines[#new_lines + 1] = '  ' .. temp
        end
      else
        new_lines[#new_lines + 1] = line
      end
    else
      new_lines[#new_lines + 1] = line
    end
  end
  vim.cmd 'e!'
  require 'plenary.path':new(fname):write(vim.fn.join(new_lines, '\r\n'), 'w')
end

return M
