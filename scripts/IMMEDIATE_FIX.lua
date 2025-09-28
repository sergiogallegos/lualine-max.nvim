-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- IMMEDIATE FIX for package.loaded error
-- Run this in Neovim to fix the error immediately

local M = {}

-- Immediate fix for the package.loaded error
function M.fix_package_loaded_error()
  print("🚨 IMMEDIATE FIX: package.loaded error")
  print("=====================================")
  
  -- Step 1: Ensure package.loaded exists
  if not package.loaded then
    package.loaded = {}
    print("✅ Created package.loaded table")
  end
  
  -- Step 2: Clear lualine cache
  package.loaded['lualine'] = nil
  package.loaded['lualine.components.branch.git_branch'] = nil
  print("✅ Cleared lualine cache")
  
  -- Step 3: Fix the git_branch component directly
  local git_branch_path = vim.fn.stdpath('data') .. '/lazy/lualine-max/lua/lualine/components/branch/git_branch.lua'
  
  if vim.fn.filereadable(git_branch_path) == 1 then
    print("✅ Found git_branch.lua file")
    
    -- Read the file content
    local content = vim.fn.readfile(git_branch_path)
    local fixed = false
    
    -- Fix the problematic line
    for i, line in ipairs(content) do
      if line:match("if package%.loaded%.oil then") then
        content[i] = "  if package.loaded and package.loaded.oil then"
        fixed = true
        print("✅ Fixed line " .. i .. " in git_branch.lua")
        break
      end
    end
    
    if fixed then
      -- Write the fixed content back
      vim.fn.writefile(content, git_branch_path)
      print("✅ Applied fix to git_branch.lua")
    else
      print("⚠️  Could not find the problematic line")
    end
  else
    print("❌ Could not find git_branch.lua file")
  end
  
  -- Step 4: Clear and reload lualine
  vim.cmd("Lazy sync")
  
  -- Step 5: Test the fix
  vim.defer_fn(function()
    local ok, lualine = pcall(require, 'lualine')
    if ok then
      print("✅ lualine loaded successfully")
      lualine.refresh()
      vim.cmd("redraw!")
      print("✅ Statusline should now work!")
    else
      print("❌ lualine still has issues:", lualine)
    end
  end, 1000)
end

-- Alternative fix: Disable git branch component temporarily
function M.disable_git_branch()
  print("🔧 Disabling git branch component temporarily...")
  
  -- Use a configuration without git branch
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
        lualine_b = { 'diff', 'diagnostics' }, -- Removed 'branch' component
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
    lualine.refresh()
    vim.cmd("redraw!")
    print("✅ Statusline configured without git branch component")
  end
end

-- Quick fix: Clear everything and restart
function M.quick_restart()
  print("⚡ Quick restart fix...")
  
  -- Clear everything
  package.loaded['lualine'] = nil
  package.loaded['lualine.components.branch.git_branch'] = nil
  
  -- Force clear statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Restart lualine
  vim.defer_fn(function()
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
      print("✅ Quick restart successful!")
    end
  end, 500)
end

-- Export functions
M.fix_package_loaded_error = M.fix_package_loaded_error
M.disable_git_branch = M.disable_git_branch
M.quick_restart = M.quick_restart

return M
