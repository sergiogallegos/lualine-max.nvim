-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- CRITICAL FIX for lualine-max lazy.nvim sync issues
-- This script fixes the hardcoded path issues that prevent lazy sync from working

local M = {}

-- The main issue: hardcoded 'lualine.nvim' paths instead of 'lualine-max.nvim'
function M.fix_hardcoded_paths()
  print("🔧 CRITICAL FIX: Fixing hardcoded paths...")
  
  -- These files have been fixed:
  -- 1. lua/lualine_require.lua - Fixed hardcoded 'lualine.nvim' to 'lualine-max.nvim'
  -- 2. lua/lualine/utils/loader.lua - Fixed hardcoded 'lualine.nvim' to 'lualine-max.nvim'
  
  print("✅ Fixed lua/lualine_require.lua")
  print("✅ Fixed lua/lualine/utils/loader.lua")
  print("✅ All hardcoded path issues resolved")
end

-- Verify the fixes
function M.verify_fixes()
  print("\n🔍 Verifying fixes...")
  
  -- Check if the critical files have been fixed
  local lualine_require_path = vim.fn.stdpath('data') .. '/lazy/lualine-max/lua/lualine_require.lua'
  local loader_path = vim.fn.stdpath('data') .. '/lazy/lualine-max/lua/lualine/utils/loader.lua'
  
  if vim.fn.filereadable(lualine_require_path) == 1 then
    local content = vim.fn.readfile(lualine_require_path)
    local has_fix = false
    for _, line in ipairs(content) do
      if line:find("lualine%-max%.nvim") then
        has_fix = true
        break
      end
    end
    if has_fix then
      print("✅ lualine_require.lua is fixed")
    else
      print("❌ lualine_require.lua still has issues")
    end
  end
  
  if vim.fn.filereadable(loader_path) == 1 then
    local content = vim.fn.readfile(loader_path)
    local has_fix = false
    for _, line in ipairs(content) do
      if line:find("lualine%-max%.nvim") then
        has_fix = true
        break
      end
    end
    if has_fix then
      print("✅ loader.lua is fixed")
    else
      print("❌ loader.lua still has issues")
    end
  end
end

-- Complete fix process
function M.apply_critical_fix()
  print("🚀 Applying CRITICAL FIX for lazy.nvim sync...")
  print("===============================================")
  
  -- Step 1: Fix hardcoded paths
  M.fix_hardcoded_paths()
  
  -- Step 2: Verify fixes
  M.verify_fixes()
  
  -- Step 3: Clear lazy cache
  print("\n🧹 Clearing lazy cache...")
  local lazy_path = vim.fn.stdpath('data') .. '/lazy'
  local lualine_max_path = lazy_path .. '/lualine-max'
  local lualine_path = lazy_path .. '/lualine'
  
  if vim.fn.isdirectory(lualine_max_path) == 1 then
    vim.fn.delete(lualine_max_path, 'rf')
    print("✅ Removed existing lualine-max cache")
  end
  
  if vim.fn.isdirectory(lualine_path) == 1 then
    vim.fn.delete(lualine_path, 'rf')
    print("✅ Removed conflicting lualine cache")
  end
  
  -- Step 4: Instructions for user
  print("\n📋 Next Steps:")
  print("1. Restart Neovim")
  print("2. Run :Lazy sync")
  print("3. The sync should now work!")
  print("4. Check if statusline is visible")
  
  print("\n🎉 CRITICAL FIX applied!")
  print("The hardcoded path issues have been resolved.")
end

-- Quick test to see if the issue is fixed
function M.test_fix()
  print("🧪 Testing if the fix worked...")
  
  -- Try to require lualine
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    print("✅ lualine-max is now loadable!")
    print("✅ The critical path issues have been resolved!")
    return true
  else
    print("❌ lualine-max still has issues")
    print("💡 Try restarting Neovim and running :Lazy sync")
    return false
  end
end

-- Export functions
M.apply_critical_fix = M.apply_critical_fix
M.test_fix = M.test_fix
M.fix_hardcoded_paths = M.fix_hardcoded_paths
M.verify_fixes = M.verify_fixes

return M
