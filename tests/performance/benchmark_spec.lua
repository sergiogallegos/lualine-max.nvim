-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local performance = require('lualine.utils.performance')
local context_analyzer = require('lualine.ai.context_analyzer')
local predictive_loader = require('lualine.utils.predictive_loader')

describe('Performance Benchmarks', function()
  local analyzer, loader, optimizer

  before_each(function()
    analyzer = context_analyzer.new()
    loader = predictive_loader.new()
    optimizer = performance.PerformanceOptimizer.new(100)
  end)

  describe('startup performance', function()
    it('should initialize quickly', function()
      local start_time = vim.loop.now()
      
      -- Initialize all components
      local context = analyzer:analyze_file_context()
      local predictions = loader:predict_components('lua', 'generic')
      local memoized_func = optimizer:memoize('test', function() return 'result' end)
      
      local end_time = vim.loop.now()
      local duration = end_time - start_time
      
      -- Should initialize in less than 50ms
      assert.is_true(duration < 50)
    end)
  end)

  describe('memory usage', function()
    it('should use minimal memory', function()
      local initial_memory = collectgarbage('count')
      
      -- Create multiple instances
      for i = 1, 100 do
        local temp_analyzer = context_analyzer.new()
        local temp_loader = predictive_loader.new()
        local temp_optimizer = performance.PerformanceOptimizer.new(100)
        
        -- Use them
        temp_analyzer:analyze_file_context()
        temp_loader:predict_components('lua', 'generic')
        temp_optimizer:memoize('test' .. i, function() return 'result' end)
      end
      
      local final_memory = collectgarbage('count')
      local memory_increase = final_memory - initial_memory
      
      -- Should not increase memory by more than 1MB
      assert.is_true(memory_increase < 1024)
    end)
  end)

  describe('cache performance', function()
    it('should have high cache hit rate', function()
      local cache_hits = 0
      local total_calls = 100
      
      for i = 1, total_calls do
        local result = optimizer:memoize('cache_test', function()
          return 'cached_result'
        end)
        
        if optimizer.cache['cache_test'] then
          cache_hits = cache_hits + 1
        end
      end
      
      local hit_rate = cache_hits / total_calls
      
      -- Should have at least 90% cache hit rate
      assert.is_true(hit_rate >= 0.9)
    end)

    it('should handle cache eviction efficiently', function()
      local max_cache_size = 10
      local optimizer_limited = performance.PerformanceOptimizer.new(100)
      optimizer_limited.max_cache_size = max_cache_size
      
      -- Fill cache beyond limit
      for i = 1, max_cache_size + 5 do
        optimizer_limited:memoize('key' .. i, function() return 'result' .. i end)
      end
      
      -- Cache should not exceed max size
      local cache_size = 0
      for _ in pairs(optimizer_limited.cache) do
        cache_size = cache_size + 1
      end
      
      assert.is_true(cache_size <= max_cache_size)
    end)
  end)

  describe('component prediction performance', function()
    it('should predict components quickly', function()
      local start_time = vim.loop.now()
      
      for i = 1, 1000 do
        loader:predict_components('lua', 'generic')
      end
      
      local end_time = vim.loop.now()
      local duration = end_time - start_time
      
      -- Should predict 1000 components in less than 100ms
      assert.is_true(duration < 100)
    end)

    it('should use cache for repeated predictions', function()
      local start_time = vim.loop.now()
      
      -- First prediction (should be slower)
      loader:predict_components('lua', 'generic')
      local first_duration = vim.loop.now() - start_time
      
      -- Second prediction (should be faster due to cache)
      local second_start = vim.loop.now()
      loader:predict_components('lua', 'generic')
      local second_duration = vim.loop.now() - second_start
      
      -- Second call should be faster
      assert.is_true(second_duration < first_duration)
    end)
  end)

  describe('context analysis performance', function()
    it('should analyze context quickly', function()
      local start_time = vim.loop.now()
      
      for i = 1, 100 do
        analyzer:analyze_file_context()
      end
      
      local end_time = vim.loop.now()
      local duration = end_time - start_time
      
      -- Should analyze 100 contexts in less than 50ms
      assert.is_true(duration < 50)
    end)

    it('should cache context analysis results', function()
      local start_time = vim.loop.now()
      
      -- First analysis
      analyzer:analyze_file_context()
      local first_duration = vim.loop.now() - start_time
      
      -- Second analysis (should use cache)
      local second_start = vim.loop.now()
      analyzer:analyze_file_context()
      local second_duration = vim.loop.now() - second_start
      
      -- Second call should be faster
      assert.is_true(second_duration < first_duration)
    end)
  end)

  describe('memory cleanup', function()
    it('should clean up memory properly', function()
      local initial_memory = collectgarbage('count')
      
      -- Create and use components
      for i = 1, 50 do
        local temp_analyzer = context_analyzer.new()
        local temp_loader = predictive_loader.new()
        
        temp_analyzer:analyze_file_context()
        temp_loader:predict_components('lua', 'generic')
      end
      
      -- Force garbage collection
      collectgarbage('collect')
      
      local final_memory = collectgarbage('count')
      local memory_increase = final_memory - initial_memory
      
      -- Memory increase should be minimal after cleanup
      assert.is_true(memory_increase < 100)
    end)
  end)

  describe('concurrent access', function()
    it('should handle concurrent access safely', function()
      local results = {}
      local errors = {}
      
      -- Simulate concurrent access
      for i = 1, 10 do
        local co = coroutine.create(function()
          local success, result = pcall(function()
            return loader:predict_components('lua', 'generic')
          end)
          
          if success then
            table.insert(results, result)
          else
            table.insert(errors, result)
          end
        end)
        
        coroutine.resume(co)
      end
      
      -- Should not have errors
      assert.equals(0, #errors)
      assert.equals(10, #results)
    end)
  end)
end)
