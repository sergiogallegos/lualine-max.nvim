-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

-- Modern Minimal Configuration
-- This example shows the new minimalist approach with performance optimizations

return {
  options = {
    theme = 'minimal',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
      winbar = {},
    },
    ignore_focus = { 'qf', 'help', 'man', 'lazy' },
    always_divide_middle = false,
    globalstatus = true,
    refresh = {
      statusline = 500,
      refresh_time = 8, -- 120fps
      events = {
        'WinEnter',
        'BufEnter',
        'ModeChanged',
        'Filetype',
      },
    },
  },
  sections = {
    lualine_a = { 'modern_mode' },
    lualine_b = { 'minimal_git' },
    lualine_c = { 
      {
        'filename',
        path = 1, -- relative path
        max_length = 40,
        smart_truncate = true,
      }
    },
    lualine_x = { 
      'filetype',
      {
        'encoding',
        show_bomb = false,
      }
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 
      {
        'filename',
        path = 0, -- just filename for inactive
      }
    },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
