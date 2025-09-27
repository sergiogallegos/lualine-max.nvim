-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Fix script for lualine-max statusline visibility issues
print("🔧 Fixing lualine-max statusline visibility...")
print("=" .. string.rep("=", 50))

-- Clear any existing statusline
vim.o.statusline = ""

-- Ensure statusline is enabled
vim.o.laststatus = 2

-- Load and setup lualine with proper configuration
local ok, lualine = pcall(require, 'lualine')
if not ok then
  print("❌ Failed to load lualine module")
  return
end

print("✅ lualine module loaded")

-- Setup lualine with minimal, visible configuration
local config = {
  options = {
    theme = 'auto', -- Use auto theme for better visibility
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
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
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Setup lualine
local setup_ok, setup_error = pcall(function()
  lualine.setup(config)
end)

if setup_ok then
  print("✅ lualine setup successful")
  
  -- Force refresh
  lualine.refresh()
  print("✅ lualine refreshed")
  
  -- Check statusline
  print("📊 Statusline after setup:")
  print("  laststatus:", vim.o.laststatus)
  print("  statusline:", vim.o.statusline)
  
else
  print("❌ lualine setup failed:", setup_error)
end

print("\n🎉 Statusline fix complete!")
print("If statusline is still not visible, try:")
print("1. :set laststatus=2")
print("2. :lua require('lualine').refresh()")
print("3. Restart Neovim")
