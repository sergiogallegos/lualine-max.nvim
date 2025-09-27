-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Quick fix for lualine-max statusline visibility
-- Run this in Neovim: :lua dofile('quick_fix.lua')

print("🔧 Quick fix for lualine-max statusline...")

-- Clear any problematic statusline
vim.o.statusline = ""

-- Ensure statusline is enabled
vim.o.laststatus = 2

-- Load lualine
local ok, lualine = pcall(require, 'lualine')
if not ok then
  print("❌ Failed to load lualine")
  return
end

-- Setup with basic, visible configuration
local config = {
  options = {
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'filetype' },
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
}

-- Setup lualine
local setup_ok = pcall(function()
  lualine.setup(config)
end)

if setup_ok then
  print("✅ lualine setup successful")
  
  -- Force refresh
  lualine.refresh()
  print("✅ lualine refreshed")
  
  -- Check statusline
  print("📊 Statusline status:")
  print("  laststatus:", vim.o.laststatus)
  print("  statusline:", vim.o.statusline)
  
  if vim.o.statusline:find("transparent") then
    print("⚠️  Statusline is still transparent, trying alternative...")
    
    -- Try alternative setup
    vim.o.statusline = ""
    vim.cmd("redraw!")
    
    -- Setup again with different theme
    config.options.theme = 'minimal'
    lualine.setup(config)
    lualine.refresh()
    
    print("🔄 Alternative setup applied")
  end
  
else
  print("❌ lualine setup failed")
end

print("🎉 Quick fix complete!")
print("If statusline is still not visible:")
print("1. Restart Neovim")
print("2. Check your colorscheme")
print("3. Try :set laststatus=2")
