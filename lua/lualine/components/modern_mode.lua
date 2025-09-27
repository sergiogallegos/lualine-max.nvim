-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local M = require('lualine.component'):extend()

---@class ModernModeOptions
---@field symbols table<string, string>
---@field icons_enabled boolean
---@field padding number|table

local default_options = {
  symbols = {
    normal = 'N',
    insert = 'I',
    visual = 'V',
    replace = 'R',
    command = 'C',
    terminal = 'T',
  },
  icons_enabled = true,
  padding = 0,
}

---@param self ModernModeComponent
---@param options ModernModeOptions
function M.init(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
end

---@param self ModernModeComponent
---@return string
function M.update_status(self)
  local mode = vim.api.nvim_get_mode().mode
  local mode_map = {
    ['n'] = 'normal',
    ['no'] = 'normal',
    ['nov'] = 'normal',
    ['noV'] = 'normal',
    ['no\22'] = 'normal',
    ['niI'] = 'normal',
    ['niR'] = 'normal',
    ['niV'] = 'normal',
    ['nt'] = 'normal',
    ['ntT'] = 'normal',
    ['v'] = 'visual',
    ['vs'] = 'visual',
    ['V'] = 'visual',
    ['Vs'] = 'visual',
    ['\22'] = 'visual',
    ['\22s'] = 'visual',
    ['s'] = 'visual',
    ['S'] = 'visual',
    ['\19'] = 'visual',
    ['i'] = 'insert',
    ['ic'] = 'insert',
    ['ix'] = 'insert',
    ['R'] = 'replace',
    ['Rc'] = 'replace',
    ['Rx'] = 'replace',
    ['Rv'] = 'replace',
    ['Rvc'] = 'replace',
    ['Rvx'] = 'replace',
    ['c'] = 'command',
    ['cv'] = 'command',
    ['ce'] = 'command',
    ['r'] = 'replace',
    ['rm'] = 'command',
    ['r?'] = 'command',
    ['!'] = 'command',
    ['t'] = 'terminal',
  }
  
  local mode_name = mode_map[mode] or 'normal'
  local symbol = self.options.symbols[mode_name] or mode_name:upper():sub(1, 1)
  
  return symbol
end

return M
