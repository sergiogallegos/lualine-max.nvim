-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Fix script for lazy.nvim sync issues with lualine-max
-- Run this in Neovim to diagnose and fix lazy sync problems

local M = {}

-- Step 1: Diagnose lazy.nvim issues
function M.diagnose_lazy()
  print("🔍 lualine-max Lazy.nvim Diagnostic")
  print("===================================")
  
  -- Check if lazy is loaded
  local lazy_ok, lazy = pcall(require, 'lazy')
  print("\n📦 Lazy.nvim Status:")
  print("  lazy loaded:", lazy_ok)
  
  if lazy_ok then
    print("  lazy version:", lazy.version or "unknown")
  end
  
  -- Check plugin status
  print("\n🔌 Plugin Status:")
  local lualine_ok, lualine = pcall(require, 'lualine')
  print("  lualine loaded:", lualine_ok)
  
  -- Check dependencies
  print("\n📋 Dependencies:")
  local devicons_ok = pcall(require, 'nvim-web-devicons')
  print("  nvim-web-devicons:", devicons_ok)
  
  -- Check for conflicts
  print("\n⚠️  Potential Conflicts:")
  local loaded_plugins = vim.g.loaded_plugins or {}
  local conflicts = {}
  
  for plugin, _ in pairs(loaded_plugins) do
    if plugin:find("lualine") and not plugin:find("lualine-max") then
      table.insert(conflicts, plugin)
    end
  end
  
  if #conflicts > 0 then
    print("  ⚠️  Found potential conflicts:")
    for _, plugin in ipairs(conflicts) do
      print("    -", plugin)
    end
  else
    print("  ✅ No obvious conflicts")
  end
  
  -- Check lazy cache
  print("\n🗂️  Lazy Cache:")
  local lazy_path = vim.fn.stdpath('data') .. '/lazy'
  local lualine_max_path = lazy_path .. '/lualine-max'
  local lualine_path = lazy_path .. '/lualine'
  
  print("  lualine-max exists:", vim.fn.isdirectory(lualine_max_path) == 1)
  print("  original lualine exists:", vim.fn.isdirectory(lualine_path) == 1)
  
  if vim.fn.isdirectory(lualine_path) == 1 then
    print("  ⚠️  Original lualine found - this may cause conflicts!")
  end
  
  return {
    lazy_ok = lazy_ok,
    lualine_ok = lualine_ok,
    devicons_ok = devicons_ok,
    conflicts = conflicts,
    lualine_max_exists = vim.fn.isdirectory(lualine_max_path) == 1,
    original_lualine_exists = vim.fn.isdirectory(lualine_path) == 1
  }
end

-- Step 2: Clean lazy cache
function M.clean_lazy_cache()
  print("\n🧹 Cleaning Lazy Cache...")
  
  local lazy_path = vim.fn.stdpath('data') .. '/lazy'
  local lualine_max_path = lazy_path .. '/lualine-max'
  local lualine_path = lazy_path .. '/lualine'
  
  -- Remove lualine-max if exists
  if vim.fn.isdirectory(lualine_max_path) == 1 then
    vim.fn.delete(lualine_max_path, 'rf')
    print("  ✅ Removed existing lualine-max")
  end
  
  -- Remove original lualine if exists
  if vim.fn.isdirectory(lualine_path) == 1 then
    vim.fn.delete(lualine_path, 'rf')
    print("  ✅ Removed original lualine (conflict resolved)")
  end
  
  print("  ✅ Cache cleaned")
end

-- Step 3: Install dependencies
function M.install_dependencies()
  print("\n📦 Installing Dependencies...")
  
  local lazy_ok, lazy = pcall(require, 'lazy')
  if not lazy_ok then
    print("  ❌ Lazy.nvim not available")
    return false
  end
  
  -- Install nvim-web-devicons
  local devicons_ok = pcall(require, 'nvim-web-devicons')
  if not devicons_ok then
    print("  🔧 Installing nvim-web-devicons...")
    -- This would need to be done through lazy
    print("  💡 Run :Lazy install nvim-tree/nvim-web-devicons")
  else
    print("  ✅ nvim-web-devicons already installed")
  end
  
  return true
end

-- Step 4: Apply working configuration
function M.apply_working_config()
  print("\n⚙️  Applying Working Configuration...")
  
  -- Clear statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Load lualine with error handling
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    print("  ❌ lualine-max not available")
    print("  💡 Make sure it's properly configured in lazy.nvim")
    return false
  end
  
  -- Apply minimal working configuration
  local config_ok, err = pcall(function()
    lualine.setup({
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
  end)
  
  if not config_ok then
    print("  ❌ Configuration failed:", err)
    return false
  end
  
  print("  ✅ Configuration applied successfully")
  return true
end

-- Step 5: Verify installation
function M.verify_installation()
  print("\n✅ Verifying Installation...")
  
  -- Check statusline
  print("  laststatus:", vim.o.laststatus)
  print("  statusline:", vim.o.statusline)
  
  -- Check lualine
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    print("  lualine loaded: ✅")
    
    -- Test refresh
    if lualine.refresh then
      lualine.refresh()
      print("  lualine refresh: ✅")
    end
  else
    print("  lualine loaded: ❌")
  end
  
  -- Force redraw
  vim.cmd("redraw!")
  print("  redraw: ✅")
  
  print("\n🎉 Verification complete!")
  print("📋 If statusline is visible, the fix worked!")
end

-- Main fix function
function M.fix_lazy_sync()
  print("🚀 Starting lualine-max Lazy.nvim Fix...")
  print("=========================================")
  
  -- Step 1: Diagnose
  local diagnosis = M.diagnose_lazy()
  
  -- Step 2: Clean cache if needed
  if diagnosis.original_lualine_exists then
    M.clean_lazy_cache()
  end
  
  -- Step 3: Install dependencies
  M.install_dependencies()
  
  -- Step 4: Apply configuration
  local config_ok = M.apply_working_config()
  
  -- Step 5: Verify
  if config_ok then
    M.verify_installation()
  end
  
  print("\n📋 Next Steps:")
  print("1. Restart Neovim")
  print("2. Run :Lazy sync")
  print("3. Check if lualine-max is loaded")
  print("4. Verify statusline is visible")
  
  return config_ok
end

-- Quick fix for immediate use
function M.quick_fix()
  print("⚡ Quick Fix for Lazy Sync...")
  
  -- Clear statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Try to load lualine
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
    print("✅ Quick fix applied!")
  else
    print("❌ lualine-max not available")
    print("💡 Run :Lazy sync first")
  end
end

-- Export functions
M.fix_lazy_sync = M.fix_lazy_sync
M.quick_fix = M.quick_fix
M.diagnose_lazy = M.diagnose_lazy

return M
