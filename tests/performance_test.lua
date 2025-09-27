-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Performance test for lualine-max

local M = {}

-- Test results
local results = {
  passed = 0,
  failed = 0,
  total = 0,
  errors = {},
}

-- Simple assertion functions
local function assert_true(condition, message)
  if not condition then
    table.insert(results.errors, {
      message = message or "Condition was false",
      condition = condition,
    })
    results.failed = results.failed + 1
    return false
  end
  results.passed = results.passed + 1
  return true
end

-- Test startup performance
local function test_startup_performance()
  print("Testing startup performance...")
  
  local start_time = vim.loop.now()
  
  -- Load lualine
  local success, lualine = pcall(require, 'lualine')
  if success then
    lualine.setup()
  end
  
  local end_time = vim.loop.now()
  local duration = end_time - start_time
  
  print("Startup time: " .. duration .. "ms")
  
  -- Should be fast (less than 50ms)
  assert_true(duration < 50, "Startup should be fast (< 50ms)")
  
  return success
end

-- Test memory usage
local function test_memory_usage()
  print("Testing memory usage...")
  
  local initial_memory = collectgarbage('count')
  
  -- Load and setup lualine multiple times
  for i = 1, 10 do
    local success, lualine = pcall(require, 'lualine')
    if success then
      lualine.setup({
        options = { theme = 'minimal' },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'filename' },
          lualine_c = { 'filetype' },
        },
      })
    end
  end
  
  local final_memory = collectgarbage('count')
  local memory_increase = final_memory - initial_memory
  
  print("Memory increase: " .. memory_increase .. "KB")
  
  -- Should not increase memory significantly (less than 2MB for 10 loads)
  assert_true(memory_increase < 2048, "Memory usage should be reasonable (< 2MB for 10 loads)")
  
  return true
end

-- Test configuration performance
local function test_configuration_performance()
  print("Testing configuration performance...")
  
  local start_time = vim.loop.now()
  
  -- Test multiple configuration setups
  local configs = {
    {
      options = { theme = 'minimal' },
      sections = { lualine_a = { 'mode' } },
    },
    {
      options = { theme = 'auto' },
      sections = { lualine_a = { 'mode' }, lualine_b = { 'filename' } },
    },
    {
      options = { theme = 'gruvbox' },
      sections = { lualine_a = { 'mode' }, lualine_b = { 'filename' }, lualine_c = { 'filetype' } },
    },
  }
  
  for _, config in ipairs(configs) do
    local success, lualine = pcall(require, 'lualine')
    if success then
      lualine.setup(config)
    end
  end
  
  local end_time = vim.loop.now()
  local duration = end_time - start_time
  
  print("Configuration time: " .. duration .. "ms")
  
  -- Should be fast (less than 100ms)
  assert_true(duration < 100, "Configuration should be fast (< 100ms)")
  
  return true
end

-- Test theme loading performance
local function test_theme_loading_performance()
  print("Testing theme loading performance...")
  
  local start_time = vim.loop.now()
  
  -- Test different themes
  local themes = { 'minimal', 'auto', 'gruvbox', 'tokyonight', 'nord' }
  
  for _, theme in ipairs(themes) do
    local success, lualine = pcall(require, 'lualine')
    if success then
      lualine.setup({
        options = { theme = theme },
        sections = { lualine_a = { 'mode' } },
      })
    end
  end
  
  local end_time = vim.loop.now()
  local duration = end_time - start_time
  
  print("Theme loading time: " .. duration .. "ms")
  
  -- Should be fast (less than 200ms)
  assert_true(duration < 200, "Theme loading should be fast (< 200ms)")
  
  return true
end

-- Test component performance
local function test_component_performance()
  print("Testing component performance...")
  
  local start_time = vim.loop.now()
  
  -- Test with many components
  local success, lualine = pcall(require, 'lualine')
  if success then
    lualine.setup({
      options = { theme = 'minimal' },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename', 'filetype', 'encoding' },
        lualine_c = { 'progress', 'location' },
        lualine_x = { 'fileformat', 'filesize' },
        lualine_y = { 'branch', 'diff' },
        lualine_z = { 'datetime' },
      },
    })
  end
  
  local end_time = vim.loop.now()
  local duration = end_time - start_time
  
  print("Component setup time: " .. duration .. "ms")
  
  -- Should be fast (less than 50ms)
  assert_true(duration < 50, "Component setup should be fast (< 50ms)")
  
  return success
end

-- Run all tests
function M.run()
  print('⚡ Running lualine-max performance tests...')
  print('=' .. string.rep('=', 50))
  
  -- Reset results
  results.passed = 0
  results.failed = 0
  results.errors = {}
  
  -- Run tests
  local tests = {
    { name = "Startup Performance", func = test_startup_performance },
    { name = "Memory Usage", func = test_memory_usage },
    { name = "Configuration Performance", func = test_configuration_performance },
    { name = "Theme Loading Performance", func = test_theme_loading_performance },
    { name = "Component Performance", func = test_component_performance },
  }
  
  for _, test in ipairs(tests) do
    print("Running " .. test.name .. "...")
    local success = test.func()
    
    if success then
      print("✅ " .. test.name .. " passed")
    else
      print("❌ " .. test.name .. " failed")
    end
  end
  
  results.total = results.passed + results.failed
  
  -- Print results
  print('=' .. string.rep('=', 50))
  print('📊 Performance Test Results:')
  print('  Total: ' .. results.total)
  print('  Passed: ' .. results.passed)
  print('  Failed: ' .. results.failed)
  print('  Success Rate: ' .. math.floor((results.passed / results.total) * 100) .. '%')
  
  if #results.errors > 0 then
    print('\n❌ Errors:')
    for _, error in ipairs(results.errors) do
      print('  ' .. (error.message or tostring(error)))
    end
  end
  
  if results.failed == 0 then
    print('\n🎉 All performance tests passed!')
    print('lualine-max performance optimizations are working!')
  else
    print('\n⚠️  Some performance tests failed.')
  end
  
  return results.failed == 0
end

return M
