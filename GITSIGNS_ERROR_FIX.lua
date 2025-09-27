-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- GITSIGNS ERROR FIX for lualine-max
-- This script fixes gitsigns.nvim errors that occur after lazy sync

local M = {}

-- Fix gitsigns preload error
function M.fix_gitsigns_preload_error()
  print("🔧 Fixing gitsigns preload error...")
  print("===================================")
  
  -- Step 1: Check if gitsigns is loaded
  local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
  print("  gitsigns loaded:", gitsigns_ok)
  
  if gitsigns_ok then
    -- Step 2: Clear gitsigns cache
    package.loaded['gitsigns'] = nil
    package.loaded['gitsigns.diff_int'] = nil
    package.loaded['gitsigns.manager'] = nil
    print("  ✅ Cleared gitsigns cache")
    
    -- Step 3: Reset gitsigns state
    if gitsigns.reset then
      gitsigns.reset()
      print("  ✅ Reset gitsigns state")
    end
  end
  
  -- Step 4: Check for git repository
  local git_dir = vim.fn.finddir('.git', ';')
  if git_dir ~= '' then
    print("  ✅ Git repository found:", git_dir)
  else
    print("  ⚠️  No git repository found - this may cause gitsigns errors")
  end
  
  -- Step 5: Reload gitsigns
  vim.defer_fn(function()
    local ok, gitsigns = pcall(require, 'gitsigns')
    if ok then
      print("  ✅ gitsigns reloaded successfully")
      
      -- Setup gitsigns with error handling
      local setup_ok, err = pcall(function()
        gitsigns.setup({
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
        })
      end)
      
      if setup_ok then
        print("  ✅ gitsigns setup successful")
      else
        print("  ❌ gitsigns setup failed:", err)
      end
    else
      print("  ❌ gitsigns failed to reload:", gitsigns)
    end
  end, 500)
end

-- Disable gitsigns temporarily
function M.disable_gitsigns()
  print("🔧 Disabling gitsigns temporarily...")
  
  -- Clear gitsigns
  package.loaded['gitsigns'] = nil
  
  -- Disable gitsigns autocmds
  vim.cmd("augroup gitsigns | autocmd! | augroup END")
  
  print("  ✅ gitsigns disabled temporarily")
end

-- Fix lualine without gitsigns
function M.fix_lualine_without_gitsigns()
  print("🔧 Configuring lualine without gitsigns...")
  
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    lualine.setup({
      options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' }, -- Keep branch but remove diff
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
    lualine.refresh()
    vim.cmd("redraw!")
    print("  ✅ lualine configured without gitsigns integration")
  end
end

-- Complete fix for both issues
function M.fix_both_errors()
  print("🚀 Fixing both lualine and gitsigns errors...")
  print("=============================================")
  
  -- Step 1: Fix gitsigns error
  M.fix_gitsigns_preload_error()
  
  -- Step 2: Wait a bit
  vim.defer_fn(function()
    -- Step 3: Fix lualine
    local ok, lualine = pcall(require, 'lualine')
    if ok then
      lualine.setup({
        options = {
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' }, -- Simple branch without diff
          lualine_c = { 'filename' },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
      lualine.refresh()
      vim.cmd("redraw!")
      print("  ✅ lualine configured successfully")
    end
  end, 1000)
end

-- Quick fix for immediate use
function M.quick_fix()
  print("⚡ Quick fix for gitsigns error...")
  
  -- Clear gitsigns
  package.loaded['gitsigns'] = nil
  
  -- Configure lualine without git integration
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
  end
end

-- Export functions
M.fix_gitsigns_preload_error = M.fix_gitsigns_preload_error
M.disable_gitsigns = M.disable_gitsigns
M.fix_lualine_without_gitsigns = M.fix_lualine_without_gitsigns
M.fix_both_errors = M.fix_both_errors
M.quick_fix = M.quick_fix

return M
