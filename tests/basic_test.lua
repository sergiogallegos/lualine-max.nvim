-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Basic test for lualine-max functionality

local M = {}

-- Test results
local results = {
  passed = 0,
  failed = 0,
  total = 0,
  errors = {},
}

-- Simple assertion functions
local function assert_equals(expected, actual, message)
  if expected ~= actual then
    table.insert(results.errors, {
      message = message or "Expected " .. tostring(expected) .. " but got " .. tostring(actual),
      expected = expected,
      actual = actual,
    })
    results.failed = results.failed + 1
    return false
  end
  results.passed = results.passed + 1
  return true
end

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

local function assert_not_nil(value, message)
  if value == nil then
    table.insert(results.errors, {
      message = message or "Value was nil",
      value = value,
    })
    results.failed = results.failed + 1
    return false
  end
  results.passed = results.passed + 1
  return true
end

-- Test lualine setup
local function test_lualine_setup()
  print("Testing lualine setup...")
  
  -- Test that lualine module can be required
  local success, lualine = pcall(require, 'lualine')
  assert_true(success, "lualine module should be loadable")
  
  if success then
    assert_not_nil(lualine, "lualine module should not be nil")
    assert_not_nil(lualine.setup, "lualine should have setup function")
  end
  
  return success
end

-- Test configuration
local function test_configuration()
  print("Testing configuration...")
  
  local success, lualine = pcall(require, 'lualine')
  if not success then
    return false
  end
  
  -- Test basic setup
  local config_success = pcall(function()
    lualine.setup({
      options = {
        theme = 'minimal',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename' },
        lualine_c = { 'filetype' },
        lualine_x = { 'encoding' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    })
  end)
  
  assert_true(config_success, "lualine setup should work with basic configuration")
  
  return config_success
end

-- Test performance
local function test_performance()
  print("Testing performance...")
  
  local start_time = vim.loop.now()
  
  -- Test that lualine can be set up quickly
  local success, lualine = pcall(require, 'lualine')
  if success then
    lualine.setup()
  end
  
  local end_time = vim.loop.now()
  local duration = end_time - start_time
  
  -- Should setup in less than 100ms
  assert_true(duration < 100, "lualine setup should be fast (< 100ms)")
  
  print("Setup time: " .. duration .. "ms")
  
  return success
end

-- Test file structure
local function test_file_structure()
  print("Testing file structure...")
  
  local files_to_check = {
    'lua/lualine.lua',
    'lua/lualine/config.lua',
    'lua/lualine/component.lua',
    'lua/lualine/highlight.lua',
    'README.md',
    'LICENSE',
  }
  
  for _, file in ipairs(files_to_check) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("File not found: " .. file)
      end
    end)
    
    assert_true(success, "File should exist: " .. file)
  end
  
  return true
end

-- Run all tests
function M.run()
  print('🧪 Running lualine-max basic tests...')
  print('=' .. string.rep('=', 50))
  
  -- Reset results
  results.passed = 0
  results.failed = 0
  results.errors = {}
  
  -- Run tests
  local tests = {
    { name = "File Structure", func = test_file_structure },
    { name = "Lualine Setup", func = test_lualine_setup },
    { name = "Configuration", func = test_configuration },
    { name = "Performance", func = test_performance },
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
  print('📊 Test Results:')
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
    print('\n🎉 All basic tests passed!')
    print('lualine-max is working correctly!')
  else
    print('\n⚠️  Some tests failed.')
  end
  
  return results.failed == 0
end

return M
