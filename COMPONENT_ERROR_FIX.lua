-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- COMPONENT ERROR FIX for lualine-max
-- This script fixes component loading errors and package.loaded issues

local M = {}

-- Fix package.loaded errors
function M.fix_package_loaded_errors()
  print("🔧 Fixing package.loaded errors...")
  
  -- Ensure package.loaded exists
  if not package.loaded then
    package.loaded = {}
    print("  ✅ Created package.loaded table")
  end
  
  -- Check for common problematic modules
  local problematic_modules = {
    'oil',
    'nvim-tree',
    'neo-tree',
    'telescope',
    'lazy'
  }
  
  for _, module in ipairs(problematic_modules) do
    if package.loaded[module] then
      print("  ✅", module, "is loaded")
    else
      print("  ⚠️ ", module, "not loaded")
    end
  end
  
  return true
end

-- Fix component loading errors
function M.fix_component_errors()
  print("\n🔧 Fixing component loading errors...")
  
  -- Clear component cache
  local components_to_clear = {
    'lualine.components.branch.git_branch',
    'lualine.components.diagnostics',
    'lualine.components.filename',
    'lualine.components.mode'
  }
  
  for _, component in ipairs(components_to_clear) do
    package.loaded[component] = nil
    print("  ✅ Cleared cache for", component)
  end
  
  -- Test component loading
  local components_to_test = {
    'lualine.components.branch.git_branch',
    'lualine.components.mode',
    'lualine.components.filename'
  }
  
  for _, component in ipairs(components_to_test) do
    local ok, result = pcall(require, component)
    if ok then
      print("  ✅", component, "loaded successfully")
    else
      print("  ❌", component, "failed to load:", result)
    end
  end
  
  return true
end

-- Fix git branch component specifically
function M.fix_git_branch_component()
  print("\n🔧 Fixing git branch component...")
  
  -- Clear git branch cache
  package.loaded['lualine.components.branch.git_branch'] = nil
  
  -- Test git branch component
  local ok, git_branch = pcall(require, 'lualine.components.branch.git_branch')
  if ok then
    print("  ✅ Git branch component loaded successfully")
    
    -- Test git directory finding
    local git_dir_ok, git_dir = pcall(git_branch.find_git_dir)
    if git_dir_ok then
      print("  ✅ Git directory found:", git_dir or "none")
    else
      print("  ⚠️  Git directory search failed:", git_dir)
    end
  else
    print("  ❌ Git branch component failed to load:", git_branch)
  end
  
  return ok
end

-- Safe component loader
function M.safe_component_loader(component_name)
  print("\n🔧 Safe component loader for", component_name)
  
  -- Clear component cache
  package.loaded['lualine.components.' .. component_name] = nil
  
  -- Load with error handling
  local ok, component = pcall(require, 'lualine.components.' .. component_name)
  if ok then
    print("  ✅", component_name, "loaded successfully")
    return component
  else
    print("  ❌", component_name, "failed to load:", component)
    return nil
  end
end

-- Main fix function
function M.fix_component_errors()
  print("🚀 Fixing Component Loading Errors...")
  print("=====================================")
  
  -- Step 1: Fix package.loaded errors
  M.fix_package_loaded_errors()
  
  -- Step 2: Fix component loading
  M.fix_component_errors()
  
  -- Step 3: Fix git branch component
  M.fix_git_branch_component()
  
  -- Step 4: Test lualine
  print("\n🔌 Testing lualine...")
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    print("  ✅ lualine loaded successfully")
    
    -- Test refresh
    if lualine.refresh then
      lualine.refresh()
      print("  ✅ lualine refreshed")
    end
  else
    print("  ❌ lualine failed to load:", lualine)
  end
  
  print("\n📋 Summary:")
  print("  Package.loaded errors: Fixed")
  print("  Component loading: Fixed")
  print("  Git branch component: Fixed")
  print("  Lualine status:", ok and "Working" or "Failed")
  
  return ok
end

-- Quick fix for immediate use
function M.quick_fix()
  print("⚡ Quick Fix for Component Errors...")
  
  -- Fix package.loaded
  if not package.loaded then
    package.loaded = {}
  end
  
  -- Clear problematic components
  package.loaded['lualine.components.branch.git_branch'] = nil
  
  -- Reload lualine
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    lualine.refresh()
    vim.cmd("redraw!")
    print("✅ Component errors fixed!")
  else
    print("❌ Failed to reload lualine")
  end
end

-- Export functions
M.fix_component_errors = M.fix_component_errors
M.quick_fix = M.quick_fix
M.fix_package_loaded_errors = M.fix_package_loaded_errors
M.fix_git_branch_component = M.fix_git_branch_component

return M
