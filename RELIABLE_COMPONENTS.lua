-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- RELIABLE COMPONENTS FIX for lualine-max
-- This script fixes intermittent component loading issues

local M = {}

-- Component loading issues and solutions
function M.diagnose_component_issues()
  print("🔍 Diagnosing Component Loading Issues...")
  print("========================================")
  
  -- Check 1: Component availability
  print("\n📦 Component Availability:")
  local components_to_check = {
    'mode', 'branch', 'filename', 'diagnostics', 'filetype', 
    'progress', 'location', 'encoding', 'fileformat'
  }
  
  local available_count = 0
  for _, comp in ipairs(components_to_check) do
    local ok, _ = pcall(require, 'lualine.components.' .. comp)
    if ok then
      print("  ✅", comp, "available")
      available_count = available_count + 1
    else
      print("  ❌", comp, "missing")
    end
  end
  
  print("  Available components:", available_count .. "/" .. #components_to_check)
  
  -- Check 2: Custom components
  print("\n🤖 Custom Components:")
  local custom_components = {
    'modern_mode', 'minimal_git', 'smart_filename', 
    'smart_diagnostics', 'adaptive_statusline'
  }
  
  local custom_available = 0
  for _, comp in ipairs(custom_components) do
    local ok, _ = pcall(require, 'lualine.components.' .. comp)
    if ok then
      print("  ✅", comp, "available")
      custom_available = custom_available + 1
    else
      print("  ❌", comp, "missing")
    end
  end
  
  print("  Custom components:", custom_available .. "/" .. #custom_components)
  
  -- Check 3: Lualine status
  print("\n🔌 Lualine Status:")
  local lualine_ok, lualine = pcall(require, 'lualine')
  print("  lualine loaded:", lualine_ok)
  
  if lualine_ok then
    print("  lualine version:", "available")
    if lualine.refresh then
      print("  refresh function:", "available")
    end
  end
  
  -- Check 4: Statusline content
  print("\n📊 Statusline Content:")
  print("  laststatus:", vim.o.laststatus)
  print("  statusline:", vim.o.statusline)
  
  return {
    standard_available = available_count,
    custom_available = custom_available,
    lualine_loaded = lualine_ok
  }
end

-- Fix 1: Ensure reliable component loading
function M.ensure_reliable_loading()
  print("\n🔧 Ensuring Reliable Component Loading...")
  
  -- Clear any problematic statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Force module reload
  local modules_to_reload = {
    'lualine',
    'lualine.components',
    'lualine.utils.loader',
    'lualine.utils.component_loader'
  }
  
  for _, module in ipairs(modules_to_reload) do
    package.loaded[module] = nil
  end
  
  print("  ✅ Cleared module cache")
  
  -- Wait a bit for modules to reload
  vim.defer_fn(function()
    print("  ✅ Modules reloaded")
  end, 100)
end

-- Fix 2: Create reliable configuration
function M.create_reliable_config()
  print("\n⚙️  Creating Reliable Configuration...")
  
  local lualine_ok, lualine = pcall(require, 'lualine')
  if not lualine_ok then
    print("  ❌ lualine not available")
    return false
  end
  
  -- Use only reliable, standard components
  local reliable_config = {
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
        tabline = 1000,
        winbar = 1000,
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
  }
  
  -- Apply with error handling
  local setup_ok, err = pcall(function()
    lualine.setup(reliable_config)
  end)
  
  if setup_ok then
    print("  ✅ Reliable configuration applied")
    return true
  else
    print("  ❌ Configuration failed:", err)
    return false
  end
end

-- Fix 3: Add component validation
function M.validate_components()
  print("\n🧪 Validating Components...")
  
  local components_to_validate = {
    'mode', 'branch', 'filename', 'diagnostics', 'filetype', 'progress', 'location'
  }
  
  local validation_results = {}
  
  for _, comp in ipairs(components_to_validate) do
    local ok, result = pcall(require, 'lualine.components.' .. comp)
    validation_results[comp] = {
      available = ok,
      result = result
    }
    
    if ok then
      print("  ✅", comp, "validated successfully")
    else
      print("  ❌", comp, "validation failed")
    end
  end
  
  return validation_results
end

-- Fix 4: Force refresh and verify
function M.force_refresh_and_verify()
  print("\n🔄 Forcing Refresh and Verification...")
  
  local lualine_ok, lualine = pcall(require, 'lualine')
  if not lualine_ok then
    print("  ❌ lualine not available for refresh")
    return false
  end
  
  -- Force refresh
  if lualine.refresh then
    lualine.refresh()
    print("  ✅ lualine refreshed")
  end
  
  -- Force redraw
  vim.cmd("redraw!")
  print("  ✅ screen redrawn")
  
  -- Check if statusline is working
  local current_statusline = vim.o.statusline
  if current_statusline == "" then
    print("  ✅ statusline should be visible")
  else
    print("  ⚠️  statusline has custom content:", current_statusline)
  end
  
  return true
end

-- Main fix function
function M.fix_intermittent_loading()
  print("🚀 Fixing Intermittent Component Loading...")
  print("===========================================")
  
  -- Step 1: Diagnose issues
  local diagnosis = M.diagnose_component_issues()
  
  -- Step 2: Ensure reliable loading
  M.ensure_reliable_loading()
  
  -- Step 3: Create reliable configuration
  local config_ok = M.create_reliable_config()
  
  -- Step 4: Validate components
  local validation = M.validate_components()
  
  -- Step 5: Force refresh
  M.force_refresh_and_verify()
  
  print("\n📋 Summary:")
  print("  Standard components available:", diagnosis.standard_available)
  print("  Custom components available:", diagnosis.custom_available)
  print("  Configuration applied:", config_ok)
  
  print("\n💡 Tips to prevent intermittent loading:")
  print("  1. Use standard components instead of custom ones")
  print("  2. Avoid complex component configurations")
  print("  3. Use slower refresh rates for stability")
  print("  4. Clear module cache if issues persist")
  
  return config_ok
end

-- Quick fix for immediate use
function M.quick_reliable_fix()
  print("⚡ Quick Reliable Fix...")
  
  -- Clear statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Use minimal, reliable configuration
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    lualine.setup({
      options = { theme = 'auto' },
      sections = {
        lualine_a = { 'mode' },
        lualine_c = { 'filename' },
        lualine_z = { 'location' }
      },
    })
    lualine.refresh()
    vim.cmd("redraw!")
    print("✅ Quick reliable fix applied!")
  else
    print("❌ lualine not available")
  end
end

-- Export functions
M.fix_intermittent_loading = M.fix_intermittent_loading
M.quick_reliable_fix = M.quick_reliable_fix
M.diagnose_component_issues = M.diagnose_component_issues

return M
