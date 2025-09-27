-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Configuration examples for lualine-max statusline
-- Choose the configuration that matches your plugin manager

local M = {}

-- Example 1: For lazy.nvim (Recommended)
M.lazy_nvim_config = {
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- CRITICAL: Clear any existing statusline settings
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'auto', -- Automatically adapts to your colorscheme
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
        },
        always_divide_middle = true,
        globalstatus = false, -- Use per-window statusline
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    })
  end
}

-- Example 2: For packer.nvim
M.packer_config = [[
use {
  'sergiogallegos/lualine-max',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
  end
}
]]

-- Example 3: For vim-plug
M.vim_plug_config = [[
Plug 'sergiogallegos/lualine-max'
Plug 'nvim-tree/nvim-web-devicons'

lua << EOF
-- Clear any existing statusline
vim.o.statusline = ""
vim.o.laststatus = 2

require('lualine').setup({
  options = {
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})
EOF
]]

-- Example 4: Direct configuration (for init.lua)
M.direct_config = function()
  -- Clear any existing statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  require('lualine').setup({
    options = {
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
      },
      always_divide_middle = true,
      globalstatus = false,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
  })
end

-- Example 5: Minimal configuration for troubleshooting
M.minimal_config = function()
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  require('lualine').setup({
    options = {
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_c = { 'filename' },
      lualine_z = { 'location' }
    },
  })
end

-- Example 6: AI-powered configuration (advanced)
M.ai_config = function()
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  require('lualine').setup({
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
      },
      always_divide_middle = false,
      globalstatus = false,
    },
    sections = {
      lualine_a = { 'modern_mode' },      -- AI-powered mode
      lualine_b = { 'minimal_git' },      -- Smart git status
      lualine_c = { 'smart_filename' },   -- Intelligent filename
      lualine_x = { 'smart_diagnostics', 'filetype' }, -- Smart diagnostics
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'smart_filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    ai_features = {
      context_awareness = { enabled = true },
      predictive_loading = { enabled = true },
    },
  })
end

-- Example 7: Performance-optimized configuration
M.performance_config = function()
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  require('lualine').setup({
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      refresh = {
        statusline = 200,
        refresh_time = 4, -- 240fps
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    performance = {
      smart_caching = { enabled = true },
      lazy_loading = { enabled = true },
    },
  })
end

return M
