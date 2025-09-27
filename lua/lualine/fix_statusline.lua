-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Fix for lualine-max statusline visibility issues
local M = {}

-- Force statusline to be visible
function M.force_visible()
  -- Clear any problematic statusline settings
  vim.o.statusline = ""
  
  -- Ensure statusline is enabled
  vim.o.laststatus = 2
  
  -- Force redraw
  vim.cmd("redraw!")
end

-- Setup lualine with guaranteed visibility
function M.setup_visible()
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    vim.notify("Failed to load lualine", vim.log.levels.ERROR)
    return false
  end
  
  -- Clear statusline first
  M.force_visible()
  
  -- Setup with minimal, visible configuration
  local config = {
    options = {
      theme = 'auto', -- Use auto theme for better visibility
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
  
  local setup_ok = pcall(function()
    lualine.setup(config)
  end)
  
  if setup_ok then
    -- Force refresh
    lualine.refresh()
    return true
  else
    vim.notify("Failed to setup lualine", vim.log.levels.ERROR)
    return false
  end
end

-- Setup with custom components (safe)
function M.setup_with_custom()
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    return M.setup_visible() -- Fallback to basic setup
  end
  
  -- Clear statusline first
  M.force_visible()
  
  -- Try custom components with fallbacks
  local config = {
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = false,
    },
    sections = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'smart_diagnostics', 'filetype' },
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
  
  local setup_ok = pcall(function()
    lualine.setup(config)
  end)
  
  if setup_ok then
    lualine.refresh()
    return true
  else
    -- Fallback to basic setup
    return M.setup_visible()
  end
end

-- Diagnostic function
function M.diagnose()
  print("🔍 lualine-max diagnostic:")
  print("  laststatus:", vim.o.laststatus)
  print("  statusline:", vim.o.statusline)
  print("  lualine loaded:", pcall(require, 'lualine'))
  
  -- Check if statusline is transparent
  if vim.o.statusline:find("transparent") then
    print("⚠️  Statusline appears to be transparent")
    print("🔧 Attempting to fix...")
    M.force_visible()
    return false
  end
  
  return true
end

return M
