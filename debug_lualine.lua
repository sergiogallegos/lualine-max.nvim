-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Debug script for lualine-max statusline issues
print("🔍 Debugging lualine-max statusline...")
print("=" .. string.rep("=", 50))

-- Check if lualine is available
local ok, lualine = pcall(require, 'lualine')
if not ok then
  print("❌ Failed to load lualine module")
  return
end

print("✅ lualine module loaded successfully")

-- Check Neovim version
print("📋 Neovim version:", vim.version().major, vim.version().minor, vim.version().patch)

-- Check if statusline is enabled
print("📋 statusline option:", vim.o.statusline)
print("📋 laststatus option:", vim.o.laststatus)

-- Test basic lualine setup
print("\n🔧 Testing basic lualine setup...")
local basic_config = {
  options = {
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    lualine_c = { 'filetype' },
    lualine_x = { 'encoding', 'fileformat' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}

local setup_ok, setup_error = pcall(function()
  lualine.setup(basic_config)
end)

if setup_ok then
  print("✅ Basic lualine setup successful")
else
  print("❌ Basic lualine setup failed:", setup_error)
end

-- Test with custom components
print("\n🔧 Testing with custom components...")
local custom_config = {
  options = {
    theme = 'minimal',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'modern_mode' },
    lualine_b = { 'minimal_git' },
    lualine_c = { 'smart_filename' },
    lualine_x = { 'smart_diagnostics', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}

local custom_ok, custom_error = pcall(function()
  lualine.setup(custom_config)
end)

if custom_ok then
  print("✅ Custom lualine setup successful")
else
  print("❌ Custom lualine setup failed:", custom_error)
end

-- Check if statusline is working
print("\n📊 Statusline check:")
print("  laststatus:", vim.o.laststatus)
print("  statusline:", vim.o.statusline)

-- Force statusline to show
vim.o.laststatus = 2
print("  Set laststatus to 2")

-- Test statusline function
local statusline_ok, statusline_result = pcall(function()
  return vim.fn.getwininfo()[1].statusline
end)

if statusline_ok then
  print("✅ Statusline function working")
else
  print("❌ Statusline function error:", statusline_result)
end

print("\n🎉 Debug complete!")
