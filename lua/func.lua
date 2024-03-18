-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/03/18 22:35:00 星期一

function Require(lua)
  local temp = package.loaded[lua]
  if temp then
    return temp
  end
  return require(lua)
end
