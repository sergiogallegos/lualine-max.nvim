-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local utils = require('lualine.utils.utils')

---@class ModernLualineConfig
---@field options table
---@field sections table
---@field inactive_sections table
---@field tabline table
---@field winbar table
---@field inactive_winbar table
---@field extensions table

---@return ModernLualineConfig
local function create_modern_config()
  return {
    options = {
      icons_enabled = true,
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'alpha', 'dashboard', 'lazy', 'mason' },
        winbar = {},
      },
      ignore_focus = { 'qf', 'help', 'man' },
      always_divide_middle = false,
      always_show_tabline = false,
      globalstatus = vim.go.laststatus == 3,
      refresh = {
        statusline = 500, -- Reduced frequency for better performance
        tabline = 1000,
        winbar = 1000,
        refresh_time = 8, -- ~120fps for smoother updates
        events = {
          'WinEnter',
          'BufEnter',
          'BufWritePost',
          'FileChangedShellPost',
          'VimResized',
          'Filetype',
          'ModeChanged',
        },
      },
    },
    sections = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'smart_filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  }
end

---@param user_config table|nil
---@return ModernLualineConfig
local function apply_modern_configuration(user_config)
  local config = create_modern_config()
  
  if not user_config then
    return config
  end
  
  -- Deep merge user config with modern defaults
  config = vim.tbl_deep_extend('force', config, user_config)
  
  -- Validate and fix configuration
  if config.options.refresh.refresh_time <= 0 then
    config.options.refresh.refresh_time = 8
  end
  
  -- Ensure separators are properly formatted
  if type(config.options.component_separators) == 'string' then
    config.options.component_separators = {
      left = config.options.component_separators,
      right = config.options.component_separators,
    }
  end
  
  if type(config.options.section_separators) == 'string' then
    config.options.section_separators = {
      left = config.options.section_separators,
      right = config.options.section_separators,
    }
  end
  
  return config
end

return {
  create_modern_config = create_modern_config,
  apply_modern_configuration = apply_modern_configuration,
}
