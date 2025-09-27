-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local performance = require('lualine.utils.performance')

describe('PerformanceOptimizer', function()
  local optimizer

  before_each(function()
    optimizer = performance.PerformanceOptimizer.new(100) -- 100ms throttle
  end)

  describe('memoization', function()
    it('should cache function results', function()
      local call_count = 0
      local test_function = function()
        call_count = call_count + 1
        return 'cached_result'
      end

      -- First call should execute function
      local result1 = optimizer:memoize('test_key', test_function)
      assert.equals(1, call_count)
      assert.equals('cached_result', result1)

      -- Second call should use cache
      local result2 = optimizer:memoize('test_key', test_function)
      assert.equals(1, call_count) -- Should not increment
      assert.equals('cached_result', result2)
    end)

    it('should respect TTL', function()
      local call_count = 0
      local test_function = function()
        call_count = call_count + 1
        return 'cached_result'
      end

      -- First call
      optimizer:memoize('ttl_key', test_function, 50) -- 50ms TTL
      assert.equals(1, call_count)

      -- Wait for TTL to expire (simulate)
      optimizer.cache['ttl_key'].timestamp = optimizer.cache['ttl_key'].timestamp - 100

      -- Should call function again
      optimizer:memoize('ttl_key', test_function, 50)
      assert.equals(2, call_count)
    end)

    it('should invalidate specific keys', function()
      optimizer:memoize('key1', function() return 'result1' end)
      optimizer:memoize('key2', function() return 'result2' end)

      assert.is_not_nil(optimizer.cache['key1'])
      assert.is_not_nil(optimizer.cache['key2'])

      optimizer:invalidate('key1')
      assert.is_nil(optimizer.cache['key1'])
      assert.is_not_nil(optimizer.cache['key2'])
    end)

    it('should clear all cache', function()
      optimizer:memoize('key1', function() return 'result1' end)
      optimizer:memoize('key2', function() return 'result2' end)

      assert.is_not_nil(optimizer.cache['key1'])
      assert.is_not_nil(optimizer.cache['key2'])

      optimizer:clear()
      assert.is_nil(optimizer.cache['key1'])
      assert.is_nil(optimizer.cache['key2'])
    end)
  end)

  describe('throttling', function()
    it('should throttle function calls', function()
      local call_count = 0
      local throttled_function = optimizer:throttle(function()
        call_count = call_count + 1
      end)

      -- First call should execute
      throttled_function()
      assert.equals(1, call_count)

      -- Immediate second call should be throttled
      throttled_function()
      assert.equals(1, call_count) -- Should not increment
    end)
  end)
end)

describe('Smart Truncation', function()
  describe('smart_truncate', function()
    it('should not truncate short strings', function()
      local result = performance.smart_truncate('short', 10)
      assert.equals('short', result)
    end)

    it('should truncate long strings', function()
      local long_string = 'this is a very long string that should be truncated'
      local result = performance.smart_truncate(long_string, 20)
      assert.is_true(#result <= 23) -- 20 + '...'
      assert.matches('%.%.%.$', result)
    end)

    it('should handle empty strings', function()
      local result = performance.smart_truncate('', 10)
      assert.equals('', result)
    end)
  end)

  describe('smart_path_truncate', function()
    it('should not truncate short paths', function()
      local result = performance.smart_path_truncate('short/path', 20)
      assert.equals('short/path', result)
    end)

    it('should truncate long paths intelligently', function()
      local long_path = 'very/long/path/to/some/file/that/should/be/truncated'
      local result = performance.smart_path_truncate(long_path, 30)
      assert.is_true(#result <= 33) -- 30 + '...'
    end)

    it('should handle single segment paths', function()
      local result = performance.smart_path_truncate('filename', 5)
      assert.is_true(#result <= 8) -- 5 + '...'
    end)

    it('should handle two segment paths', function()
      local result = performance.smart_path_truncate('parent/child', 10)
      assert.is_true(#result <= 13) -- 10 + '...'
    end)
  end)
end)
