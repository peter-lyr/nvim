-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/18 22:35:00 星期一

function Require(lua)
  local temp = package.loaded[lua]
  if temp then
    return temp
  end
  local ok, res = pcall(require, lua)
  if ok then
    return res
  end
  return nil
end

function R(lua)
  local temp = Require('config.my.' .. lua)
  if temp then return temp end
  temp = Require('config.test.' .. lua)
  if temp then return temp end
  temp = Require('config.nvim.' .. lua)
  if temp then return temp end
  return Require(lua)
end

function L(m, func)
  if m.loaded then
    return
  end
  m.loaded = 1
  func()
end
