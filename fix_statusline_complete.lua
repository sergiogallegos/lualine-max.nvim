-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Complete fix for lualine-max statusline visibility issues
-- This script addresses all common causes of invisible statusline

local M = {}

-- Step 1: Clear any problematic statusline settings
function M.clear_statusline()
  print("🔧 Clearing problematic statusline settings...")
  
  -- Clear any existing statusline
  vim.o.statusline = ""
  
  -- Ensure statusline is enabled
  vim.o.laststatus = 2
  
  -- Clear any ruler settings that might interfere
  vim.o.ruler = true
  
  -- Force redraw
  vim.cmd("redraw!")
  
  print("✅ Statusline settings cleared")
end

-- Step 2: Load lualine with error handling
function M.load_lualine()
  print("🔌 Loading lualine-max...")
  
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    print("❌ Failed to load lualine-max")
    print("💡 Make sure lualine-max is installed and configured")
    return false, nil
  end
  
  print("✅ lualine-max loaded successfully")
  return true, lualine
end

-- Step 3: Apply working configuration
function M.apply_working_config(lualine)
  print("⚙️  Applying working configuration...")
  
  -- Basic working configuration
  local config = {
    options = {
      theme = 'auto', -- Use auto theme for better visibility
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
        winbar = {},
      },
      ignore_focus = { 'qf', 'help', 'man', 'lazy' },
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
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
  
  -- Apply configuration with error handling
  local setup_ok, err = pcall(function()
    lualine.setup(config)
  end)
  
  if not setup_ok then
    print("❌ Failed to setup lualine:", err)
    return false
  end
  
  print("✅ Configuration applied successfully")
  return true
end

-- Step 4: Force refresh and verify
function M.verify_and_refresh(lualine)
  print("🔄 Refreshing statusline...")
  
  -- Force refresh
  if lualine.refresh then
    lualine.refresh()
  end
  
  -- Force redraw
  vim.cmd("redraw!")
  
  -- Check if statusline is now visible
  local current_statusline = vim.o.statusline
  if current_statusline == "" then
    print("✅ Statusline should now be visible!")
    print("🎯 You should see: mode, branch, filename, filetype, progress, location")
  else
    print("⚠️  Statusline still has custom content:", current_statusline)
  end
  
  return true
end

-- Main fix function
function M.fix_statusline()
  print("🚀 Starting lualine-max statusline fix...")
  print("=========================================")
  
  -- Step 1: Clear problematic settings
  M.clear_statusline()
  
  -- Step 2: Load lualine
  local lualine_ok, lualine = M.load_lualine()
  if not lualine_ok then
    print("\n❌ Cannot proceed without lualine-max")
    print("💡 Please install lualine-max first")
    return false
  end
  
  -- Step 3: Apply configuration
  local config_ok = M.apply_working_config(lualine)
  if not config_ok then
    print("\n❌ Failed to apply configuration")
    return false
  end
  
  -- Step 4: Verify and refresh
  M.verify_and_refresh(lualine)
  
  print("\n🎉 Statusline fix completed!")
  print("📋 If statusline is still not visible:")
  print("   1. Restart Neovim")
  print("   2. Check for other statusline plugins")
  print("   3. Run :lua print(vim.o.statusline) to check statusline content")
  
  return true
end

-- Alternative: Minimal configuration for troubleshooting
function M.minimal_config()
  print("🔧 Applying minimal configuration...")
  
  M.clear_statusline()
  
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    print("❌ lualine-max not available")
    return false
  end
  
  -- Ultra-minimal configuration
  lualine.setup({
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
  
  lualine.refresh()
  vim.cmd("redraw!")
  
  print("✅ Minimal configuration applied")
  return true
end

-- Export functions
M.fix_statusline = M.fix_statusline
M.minimal_config = M.minimal_config
M.clear_statusline = M.clear_statusline

return M
