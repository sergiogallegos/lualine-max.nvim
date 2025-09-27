-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

---@class PerformanceOptimizer
---@field cache table<string, any>
---@field last_refresh number
---@field refresh_throttle number
local PerformanceOptimizer = {}
PerformanceOptimizer.__index = PerformanceOptimizer

---@param throttle_ms number
---@return PerformanceOptimizer
function PerformanceOptimizer.new(throttle_ms)
  local self = setmetatable({}, PerformanceOptimizer)
  self.cache = {}
  self.last_refresh = 0
  self.refresh_throttle = throttle_ms or 16
  return self
end

---@param key string
---@param fn function
---@param ttl_ms number|nil
---@return any
function PerformanceOptimizer:memoize(key, fn, ttl_ms)
  local now = vim.loop.now()
  local cached = self.cache[key]
  
  if cached and (not ttl_ms or (now - cached.timestamp) < ttl_ms) then
    return cached.value
  end
  
  local value = fn()
  self.cache[key] = {
    value = value,
    timestamp = now
  }
  return value
end

---@param key string
function PerformanceOptimizer:invalidate(key)
  self.cache[key] = nil
end

function PerformanceOptimizer:clear()
  self.cache = {}
end

---@param fn function
---@return function
function PerformanceOptimizer:throttle(fn)
  return function(...)
    local now = vim.loop.now()
    if now - self.last_refresh >= self.refresh_throttle then
      self.last_refresh = now
      return fn(...)
    end
  end
end

---@param str string
---@param max_len number
---@return string
local function smart_truncate(str, max_len)
  if #str <= max_len then
    return str
  end
  
  -- Try to truncate at word boundaries
  local truncated = str:sub(1, max_len - 3)
  local last_space = truncated:match(".*%s")
  
  if last_space and #last_space > max_len * 0.7 then
    return last_space .. "..."
  end
  
  return truncated .. "..."
end

---@param path string
---@param max_len number
---@return string
local function smart_path_truncate(path, max_len)
  if #path <= max_len then
    return path
  end
  
  local parts = vim.split(path, "/")
  if #parts <= 2 then
    return smart_truncate(path, max_len)
  end
  
  -- Keep first and last parts, truncate middle
  local result = parts[1]
  local remaining = max_len - #result - #parts[#parts] - 3 -- 3 for "..."
  
  if remaining > 0 then
    result = result .. "/..."
    local last_part = parts[#parts]
    if #last_part > remaining then
      last_part = smart_truncate(last_part, remaining)
    end
    result = result .. "/" .. last_part
  else
    result = result .. "/" .. parts[#parts]
  end
  
  return result
end

return {
  PerformanceOptimizer = PerformanceOptimizer,
  smart_truncate = smart_truncate,
  smart_path_truncate = smart_path_truncate,
}
