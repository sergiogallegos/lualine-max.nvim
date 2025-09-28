-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- BLACK STATUSLINE FIX for lualine-max
-- This script fixes the black rectangle statusline issue

local M = {}

-- Diagnose black statusline issue
function M.diagnose_black_statusline()
  print("🔍 Diagnosing Black Statusline Issue...")
  print("=====================================")
  
  -- Check 1: Basic statusline settings
  print("\n📊 Basic Settings:")
  print("  laststatus:", vim.o.laststatus)
  print("  statusline:", vim.o.statusline)
  print("  ruler:", vim.o.ruler)
  
  -- Check 2: Lualine status
  print("\n🔌 Lualine Status:")
  local lualine_ok, lualine = pcall(require, 'lualine')
  print("  lualine loaded:", lualine_ok)
  
  if lualine_ok then
    print("  lualine version:", "available")
    if lualine.refresh then
      print("  refresh function:", "available")
    end
  end
  
  -- Check 3: Component availability
  print("\n📦 Component Availability:")
  local components_to_check = {
    'mode', 'branch', 'filename', 'filetype', 'progress', 'location'
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
  
  -- Check 4: Theme issues
  print("\n🎨 Theme Status:")
  print("  colorscheme:", vim.g.colors_name or "default")
  
  -- Check 5: Window status
  print("\n🪟 Window Status:")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
  if #wininfo > 0 then
    print("  statusline content:", wininfo[1].statusline or "empty")
  end
  
  return {
    lualine_loaded = lualine_ok,
    components_available = available_count,
    laststatus = vim.o.laststatus,
    statusline = vim.o.statusline
  }
end

-- Fix 1: Clear and reset statusline
function M.clear_and_reset()
  print("\n🧹 Clearing and Resetting Statusline...")
  
  -- Clear any problematic statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  vim.o.ruler = true
  
  -- Force clear any custom statusline
  vim.cmd("set statusline=")
  vim.cmd("set laststatus=2")
  
  print("  ✅ Statusline cleared and reset")
end

-- Fix 2: Force basic statusline
function M.force_basic_statusline()
  print("\n🔧 Forcing Basic Statusline...")
  
  -- Set a basic statusline as fallback
  vim.o.statusline = "%f %h%w%m%r %=%y %l,%c %P"
  vim.o.laststatus = 2
  
  -- Force redraw
  vim.cmd("redraw!")
  
  print("  ✅ Basic statusline applied")
end

-- Fix 3: Minimal lualine configuration
function M.minimal_lualine_config()
  print("\n⚙️  Applying Minimal Lualine Configuration...")
  
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    print("  ❌ lualine not available")
    return false
  end
  
  -- Ultra-minimal configuration
  local config_ok, err = pcall(function()
    lualine.setup({
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
        lualine_c = { 'filename' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_c = { 'filename' },
        lualine_z = { 'location' }
      },
    })
  end)
  
  if config_ok then
    print("  ✅ Minimal configuration applied")
    
    -- Force refresh
    lualine.refresh()
    vim.cmd("redraw!")
    
    return true
  else
    print("  ❌ Configuration failed:", err)
    return false
  end
end

-- Fix 4: Test individual components
function M.test_components()
  print("\n🧪 Testing Individual Components...")
  
  local components_to_test = {
    { name = 'mode', test = function() return 'NORMAL' end },
    { name = 'filename', test = function() return vim.fn.expand('%:t') end },
    { name = 'location', test = function() return vim.fn.line('.') .. ',' .. vim.fn.col('.') end }
  }
  
  for _, comp in ipairs(components_to_test) do
    local ok, result = pcall(comp.test)
    if ok then
      print("  ✅", comp.name, "works:", result)
    else
      print("  ❌", comp.name, "failed")
    end
  end
end

-- Fix 5: Force statusline visibility
function M.force_visibility()
  print("\n👁️  Forcing Statusline Visibility...")
  
  -- Clear statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Force redraw multiple times
  vim.cmd("redraw!")
  vim.cmd("redrawstatus!")
  
  -- Wait and redraw again
  vim.defer_fn(function()
    vim.cmd("redraw!")
    vim.cmd("redrawstatus!")
    print("  ✅ Forced visibility")
  end, 100)
end

-- Main fix function
function M.fix_black_statusline()
  print("🚀 Fixing Black Statusline Issue...")
  print("====================================")
  
  -- Step 1: Diagnose
  local diagnosis = M.diagnose_black_statusline()
  
  -- Step 2: Clear and reset
  M.clear_and_reset()
  
  -- Step 3: Try minimal lualine
  local lualine_ok = M.minimal_lualine_config()
  
  -- Step 4: If lualine fails, use basic statusline
  if not lualine_ok then
    print("\n⚠️  Lualine failed, using basic statusline...")
    M.force_basic_statusline()
  end
  
  -- Step 5: Test components
  M.test_components()
  
  -- Step 6: Force visibility
  M.force_visibility()
  
  print("\n📋 Summary:")
  print("  Lualine loaded:", diagnosis.lualine_loaded)
  print("  Components available:", diagnosis.components_available)
  print("  Laststatus:", diagnosis.laststatus)
  
  print("\n💡 If still black:")
  print("  1. Try different colorscheme: :colorscheme default")
  print("  2. Check for theme conflicts")
  print("  3. Restart Neovim")
  print("  4. Use basic statusline as fallback")
  
  return lualine_ok
end

-- Quick fix for immediate use
function M.quick_fix()
  print("⚡ Quick Fix for Black Statusline...")
  
  -- Clear everything
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Try lualine first
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
    print("✅ Lualine quick fix applied!")
  else
    -- Fallback to basic statusline
    vim.o.statusline = "%f %h%w%m%r %=%y %l,%c %P"
    vim.cmd("redraw!")
    print("✅ Basic statusline fallback applied!")
  end
end

-- Export functions
M.fix_black_statusline = M.fix_black_statusline
M.quick_fix = M.quick_fix
M.diagnose_black_statusline = M.diagnose_black_statusline

return M
