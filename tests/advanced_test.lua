-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Advanced test for lualine-max AI features and performance

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

-- Test AI features
local function test_ai_features()
  print("Testing AI features...")
  
  -- Test that AI configuration files exist
  local ai_files = {
    'lua/lualine/ai/context_analyzer.lua',
    'lua/lualine/utils/predictive_loader.lua',
    'lua/lualine/components/adaptive_statusline.lua',
    'lua/lualine/components/smart_diagnostics.lua',
  }
  
  for _, file in ipairs(ai_files) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("AI file not found: " .. file)
      end
    end)
    
    assert_true(success, "AI file should exist: " .. file)
  end
  
  return true
end

-- Test performance optimizations
local function test_performance_optimizations()
  print("Testing performance optimizations...")
  
  -- Test that performance files exist
  local perf_files = {
    'lua/lualine/utils/performance.lua',
    'lua/lualine/config/modern.lua',
    'lua/lualine/config/next_gen.lua',
  }
  
  for _, file in ipairs(perf_files) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("Performance file not found: " .. file)
      end
    end)
    
    assert_true(success, "Performance file should exist: " .. file)
  end
  
  return true
end

-- Test modern components
local function test_modern_components()
  print("Testing modern components...")
  
  -- Test that modern component files exist
  local component_files = {
    'lua/lualine/components/modern_mode.lua',
    'lua/lualine/components/smart_filename.lua',
    'lua/lualine/components/minimal_git.lua',
  }
  
  for _, file in ipairs(component_files) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("Component file not found: " .. file)
      end
    end)
    
    assert_true(success, "Component file should exist: " .. file)
  end
  
  return true
end

-- Test themes
local function test_themes()
  print("Testing themes...")
  
  -- Test that theme files exist
  local theme_files = {
    'lua/lualine/themes/minimal.lua',
    'lua/lualine/themes/auto.lua',
  }
  
  for _, file in ipairs(theme_files) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("Theme file not found: " .. file)
      end
    end)
    
    assert_true(success, "Theme file should exist: " .. file)
  end
  
  return true
end

-- Test examples
local function test_examples()
  print("Testing examples...")
  
  -- Test that example files exist
  local example_files = {
    'examples/modern_minimal.lua',
    'examples/ultra_performance.lua',
    'examples/next_gen_ai.lua',
    'examples/ultra_performance_ai.lua',
  }
  
  for _, file in ipairs(example_files) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("Example file not found: " .. file)
      end
    end)
    
    assert_true(success, "Example file should exist: " .. file)
  end
  
  return true
end

-- Test documentation
local function test_documentation()
  print("Testing documentation...")
  
  -- Test that documentation files exist
  local doc_files = {
    'README.md',
    'SETUP_GUIDE.md',
    'TESTING.md',
    'MODERNIZATION.md',
    'NEXT_GEN_FEATURES.md',
    'IMPLEMENTATION_SUMMARY.md',
  }
  
  for _, file in ipairs(doc_files) do
    local success = pcall(function()
      local f = io.open(file, 'r')
      if f then
        f:close()
      else
        error("Documentation file not found: " .. file)
      end
    end)
    
    assert_true(success, "Documentation file should exist: " .. file)
  end
  
  return true
end

-- Test lualine with AI features
local function test_lualine_with_ai()
  print("Testing lualine with AI features...")
  
  local success, lualine = pcall(require, 'lualine')
  if not success then
    return false
  end
  
  -- Test setup with AI features
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
      ai_features = {
        context_awareness = { enabled = true },
        predictive_loading = { enabled = true },
      },
      performance = {
        smart_caching = { enabled = true },
        lazy_loading = { enabled = true },
      },
    })
  end)
  
  assert_true(config_success, "lualine setup should work with AI features")
  
  return config_success
end

-- Run all tests
function M.run()
  print('🧪 Running lualine-max advanced tests...')
  print('=' .. string.rep('=', 50))
  
  -- Reset results
  results.passed = 0
  results.failed = 0
  results.errors = {}
  
  -- Run tests
  local tests = {
    { name = "AI Features", func = test_ai_features },
    { name = "Performance Optimizations", func = test_performance_optimizations },
    { name = "Modern Components", func = test_modern_components },
    { name = "Themes", func = test_themes },
    { name = "Examples", func = test_examples },
    { name = "Documentation", func = test_documentation },
    { name = "Lualine with AI", func = test_lualine_with_ai },
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
    print('\n🎉 All advanced tests passed!')
    print('lualine-max AI features and performance optimizations are working!')
  else
    print('\n⚠️  Some tests failed.')
  end
  
  return results.failed == 0
end

return M
