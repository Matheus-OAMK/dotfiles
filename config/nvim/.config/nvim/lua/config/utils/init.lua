---@class MyUtil
local M = {}

setmetatable(M, {
  __index = function(_, key)
    local ok, mod = pcall(require, "config.utils." .. key)
    if ok then
      M[key] = mod
      return mod
    else
      error("No such util: config.utils." .. key)
    end
  end,
})

return M
