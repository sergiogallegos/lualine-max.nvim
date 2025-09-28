-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- OPTIMIZED CONFIGURATION for lualine-max
-- This configuration fixes the issues in your current setup

return {
  -- lualine-max - Simplified and reliable configuration
  {
    'sergiogallegos/lualine-max',
    dependencies = { 
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false, -- Load immediately
    priority = 1000, -- High priority
    config = function()
      -- Clear any existing statusline settings
      vim.o.statusline = ""
      vim.o.laststatus = 2
      
      -- Load lualine with error handling
      local ok, lualine = pcall(require, "lualine")
      if not ok then
        vim.notify("Failed to load lualine-max", vim.log.levels.ERROR)
        return
      end
      
      -- Simple, reliable configuration
      lualine.setup({
        options = {
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
          },
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000, -- Slower refresh for stability
          },
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
      
      -- Force refresh once
      lualine.refresh()
      vim.cmd("redraw!")
    end,
  },
}
