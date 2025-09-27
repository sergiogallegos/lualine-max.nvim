-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local M = require('lualine.component'):extend()

local performance = require('lualine.utils.performance')

---@class SmartFilenameOptions
---@field symbols table<string, string>
---@field path number
---@field max_length number
---@field smart_truncate boolean
---@field show_modified boolean
---@field show_readonly boolean

local default_options = {
  symbols = {
    modified = '+',
    readonly = '!',
    unnamed = '[No Name]',
    newfile = '[New]',
  },
  path = 0, -- 0: filename, 1: relative, 2: absolute, 3: absolute with ~, 4: parent/filename
  max_length = 0, -- 0: no limit
  smart_truncate = true,
  show_modified = true,
  show_readonly = true,
}

---@param self SmartFilenameComponent
---@param options SmartFilenameOptions
function M.init(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  
  -- Initialize performance optimizer
  self.perf = performance.PerformanceOptimizer.new(100) -- 100ms cache
end

---@param self SmartFilenameComponent
---@return string
function M.update_status(self)
  return self.perf:memoize('filename', function()
    local path_separator = package.config:sub(1, 1)
    local data
    
    if self.options.path == 1 then
      data = vim.fn.expand('%:~:.')
    elseif self.options.path == 2 then
      data = vim.fn.expand('%:p')
    elseif self.options.path == 3 then
      data = vim.fn.expand('%:p:~')
    elseif self.options.path == 4 then
      local full_path = vim.fn.expand('%:p:~')
      local parts = vim.split(full_path, path_separator)
      if #parts >= 2 then
        data = parts[#parts - 1] .. path_separator .. parts[#parts]
      else
        data = parts[#parts] or ''
      end
    else
      data = vim.fn.expand('%:t')
    end
    
    if data == '' then
      data = self.options.symbols.unnamed
    end
    
    -- Smart truncation
    if self.options.max_length > 0 and #data > self.options.max_length then
      if self.options.smart_truncate then
        data = performance.smart_path_truncate(data, self.options.max_length)
      else
        data = data:sub(1, self.options.max_length - 3) .. '...'
      end
    end
    
    -- Escape for statusline
    data = data:gsub('%%', '%%%%')
    
    -- Add status symbols
    local symbols = {}
    if self.options.show_modified and vim.bo.modified then
      table.insert(symbols, self.options.symbols.modified)
    end
    if self.options.show_readonly and (not vim.bo.modifiable or vim.bo.readonly) then
      table.insert(symbols, self.options.symbols.readonly)
    end
    
    if #symbols > 0 then
      data = data .. ' ' .. table.concat(symbols, '')
    end
    
    return data
  end)
end

return M
