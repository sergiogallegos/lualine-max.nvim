-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

-- Ultra Performance Configuration
-- Optimized for maximum speed and minimal resource usage

return {
  options = {
    theme = 'minimal',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt', 'qf', 'help' },
      winbar = {},
    },
    ignore_focus = { 'qf', 'help', 'man', 'lazy', 'mason' },
    always_divide_middle = false,
    globalstatus = true,
    refresh = {
      statusline = 1000, -- Less frequent updates
      refresh_time = 16, -- 60fps for smooth but efficient updates
      events = {
        'WinEnter',
        'BufEnter',
        'ModeChanged',
      },
    },
  },
  sections = {
    lualine_a = { 'modern_mode' },
    lualine_b = { 
      {
        'minimal_git',
        show_branch = true,
        show_status = false, -- Disable git status for performance
        max_length = 15,
      }
    },
    lualine_c = { 
      {
        'filename',
        path = 0, -- Just filename for speed
        max_length = 30,
        smart_truncate = true,
      }
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 
      {
        'filename',
        path = 0,
        max_length = 25,
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
