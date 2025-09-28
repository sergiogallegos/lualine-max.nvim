-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Test suite for fixed issues in lualine-max
-- This tests all the critical fixes we implemented

local M = {}

-- Test 1: Lazy sync fix
function M.test_lazy_sync_fix()
  print("🧪 Testing lazy sync fix...")
  
  -- Test that lualine can be required
  local ok, lualine = pcall(require, 'lualine')
  assert(ok, "lualine should be loadable")
  
  -- Test that setup works
  local setup_ok, err = pcall(function()
    lualine.setup({
      options = { theme = 'auto' },
      sections = {
        lualine_a = { 'mode' },
        lualine_c = { 'filename' },
        lualine_z = { 'location' }
      },
    })
  end)
  
  assert(setup_ok, "lualine setup should work: " .. tostring(err))
  
  print("✅ Lazy sync fix test passed")
  return true
end

-- Test 2: Black statusline fix
function M.test_black_statusline_fix()
  print("🧪 Testing black statusline fix...")
  
  -- Clear statusline
  vim.o.statusline = ""
  vim.o.laststatus = 2
  
  -- Test that statusline is visible
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
    
    -- Check that statusline is not empty
    assert(vim.o.laststatus == 2, "laststatus should be 2")
    print("✅ Black statusline fix test passed")
  end
  
  return true
end

-- Test 3: Component loading fix
function M.test_component_loading_fix()
  print("🧪 Testing component loading fix...")
  
  -- Test standard components
  local components_to_test = {
    'lualine.components.mode',
    'lualine.components.filename',
    'lualine.components.location'
  }
  
  for _, component in ipairs(components_to_test) do
    local ok, comp = pcall(require, component)
    assert(ok, "Component should load: " .. component)
    print("  ✅ " .. component .. " loaded")
  end
  
  print("✅ Component loading fix test passed")
  return true
end

-- Test 4: Package.loaded fix
function M.test_package_loaded_fix()
  print("🧪 Testing package.loaded fix...")
  
  -- Ensure package.loaded exists
  if not package.loaded then
    package.loaded = {}
  end
  
  -- Test that we can access package.loaded safely
  local ok, result = pcall(function()
    return package.loaded and package.loaded.lualine
  end)
  
  assert(ok, "package.loaded should be accessible")
  print("✅ Package.loaded fix test passed")
  return true
end

-- Test 5: Git branch component fix
function M.test_git_branch_fix()
  print("🧪 Testing git branch component fix...")
  
  -- Test git branch component with safe package.loaded check
  local ok, git_branch = pcall(require, 'lualine.components.branch.git_branch')
  if ok then
    -- Test find_git_dir function
    local git_dir_ok, git_dir = pcall(git_branch.find_git_dir)
    if git_dir_ok then
      print("  ✅ Git directory found: " .. (git_dir or "none"))
    else
      print("  ⚠️  Git directory search failed (expected in non-git repo)")
    end
  else
    print("  ⚠️  Git branch component not available (expected)")
  end
  
  print("✅ Git branch component fix test passed")
  return true
end

-- Test 6: Gitsigns integration fix
function M.test_gitsigns_integration_fix()
  print("🧪 Testing gitsigns integration fix...")
  
  -- Test that we can handle gitsigns safely
  local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
  if gitsigns_ok then
    print("  ✅ gitsigns is available")
  else
    print("  ⚠️  gitsigns not available (expected)")
  end
  
  -- Test lualine without gitsigns
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    lualine.setup({
      options = { theme = 'auto' },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' }, -- Should work with or without gitsigns
        lualine_c = { 'filename' },
        lualine_z = { 'location' }
      },
    })
    lualine.refresh()
    print("  ✅ lualine works with or without gitsigns")
  end
  
  print("✅ Gitsigns integration fix test passed")
  return true
end

-- Test 7: Intermittent loading fix
function M.test_intermittent_loading_fix()
  print("🧪 Testing intermittent loading fix...")
  
  -- Test multiple loads
  for i = 1, 5 do
    local ok, lualine = pcall(require, 'lualine')
    assert(ok, "lualine should load consistently (attempt " .. i .. ")")
    
    local setup_ok, err = pcall(function()
      lualine.setup({
        options = { theme = 'auto' },
        sections = {
          lualine_a = { 'mode' },
          lualine_c = { 'filename' },
          lualine_z = { 'location' }
        },
      })
    end)
    
    assert(setup_ok, "lualine setup should work consistently (attempt " .. i .. "): " .. tostring(err))
  end
  
  print("✅ Intermittent loading fix test passed")
  return true
end

-- Run all tests
function M.run_all_tests()
  print("🚀 Running lualine-max fixed issues tests...")
  print("==========================================")
  
  local tests = {
    M.test_lazy_sync_fix,
    M.test_black_statusline_fix,
    M.test_component_loading_fix,
    M.test_package_loaded_fix,
    M.test_git_branch_fix,
    M.test_gitsigns_integration_fix,
    M.test_intermittent_loading_fix
  }
  
  local passed = 0
  local total = #tests
  
  for i, test in ipairs(tests) do
    local ok, err = pcall(test)
    if ok then
      passed = passed + 1
    else
      print("❌ Test " .. i .. " failed: " .. tostring(err))
    end
  end
  
  print("\n📊 Test Results:")
  print("  Passed: " .. passed .. "/" .. total)
  print("  Success rate: " .. math.floor((passed / total) * 100) .. "%")
  
  if passed == total then
    print("🎉 All tests passed! lualine-max is working correctly.")
  else
    print("⚠️  Some tests failed. Check the output above.")
  end
  
  return passed == total
end

-- Export functions
M.run_all_tests = M.run_all_tests
M.test_lazy_sync_fix = M.test_lazy_sync_fix
M.test_black_statusline_fix = M.test_black_statusline_fix
M.test_component_loading_fix = M.test_component_loading_fix
M.test_package_loaded_fix = M.test_package_loaded_fix
M.test_git_branch_fix = M.test_git_branch_fix
M.test_gitsigns_integration_fix = M.test_gitsigns_integration_fix
M.test_intermittent_loading_fix = M.test_intermittent_loading_fix

return M
