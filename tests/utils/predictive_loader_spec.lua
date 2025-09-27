-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local predictive_loader = require('lualine.utils.predictive_loader')

describe('PredictiveLoader', function()
  local loader

  before_each(function()
    loader = predictive_loader.new()
  end)

  describe('component prediction', function()
    it('should predict components for lua files', function()
      local predictions = loader:predict_components('lua', 'generic')
      
      assert.is_not_nil(predictions)
      assert.is_not_nil(predictions['modern_mode'])
      assert.is_not_nil(predictions['smart_filename'])
      assert.is_not_nil(predictions['minimal_git'])
    end)

    it('should predict components for python files', function()
      local predictions = loader:predict_components('python', 'data_science')
      
      assert.is_not_nil(predictions['python_env'])
      assert.is_not_nil(predictions['minimal_git'])
      assert.is_not_nil(predictions['filetype'])
    end)

    it('should predict components for javascript files', function()
      local predictions = loader:predict_components('javascript', 'web')
      
      assert.is_not_nil(predictions['npm_status'])
      assert.is_not_nil(predictions['minimal_git'])
      assert.is_not_nil(predictions['filetype'])
    end)

    it('should predict components for rust files', function()
      local predictions = loader:predict_components('rust', 'generic')
      
      assert.is_not_nil(predictions['cargo_status'])
      assert.is_not_nil(predictions['minimal_git'])
      assert.is_not_nil(predictions['filetype'])
    end)

    it('should predict components for markdown files', function()
      local predictions = loader:predict_components('markdown', 'documentation')
      
      assert.is_not_nil(predictions['word_count'])
      assert.is_not_nil(predictions['filetype'])
    end)
  end)

  describe('usage tracking', function()
    it('should record component usage', function()
      local usage_context = {
        filetype = 'lua',
        project_type = 'generic',
      }

      loader:record_component_usage('smart_filename', usage_context)
      loader:record_component_usage('minimal_git', usage_context)

      local stats = loader:get_usage_stats()
      assert.is_not_nil(stats['smart_filename_lua'])
      assert.is_not_nil(stats['minimal_git_lua'])
    end)

    it('should track usage frequency', function()
      local usage_context = { filetype = 'lua' }
      
      -- Record multiple usages
      for i = 1, 10 do
        loader:record_component_usage('smart_filename', usage_context)
      end

      local frequent = loader:get_frequently_used_components(5)
      assert.is_not_nil(frequent['smart_filename_lua'])
      assert.equals(10, frequent['smart_filename_lua'])
    end)
  end)

  describe('component preloading', function()
    it('should preload high-confidence components', function()
      local components = {
        smart_filename = 0.9,
        minimal_git = 0.8,
        filetype = 0.6,
      }

      loader:preload_components(components)
      
      -- Check that high-confidence components are preloaded
      assert.is_not_nil(loader.preloaded_components['smart_filename'])
      assert.is_not_nil(loader.preloaded_components['minimal_git'])
      -- Low confidence component should not be preloaded
      assert.is_nil(loader.preloaded_components['filetype'])
    end)
  end)

  describe('optimized sections', function()
    it('should generate optimized sections for python', function()
      local sections = loader:get_optimized_sections('python', 'data_science')
      
      assert.is_not_nil(sections.lualine_a)
      assert.is_not_nil(sections.lualine_b)
      assert.is_not_nil(sections.lualine_c)
      assert.is_not_nil(sections.lualine_x)
      assert.is_not_nil(sections.lualine_y)
      assert.is_not_nil(sections.lualine_z)
    end)

    it('should generate smart components for different filetypes', function()
      local lua_components = loader:get_smart_components('lua', 'generic')
      local python_components = loader:get_smart_components('python', 'data_science')
      local js_components = loader:get_smart_components('javascript', 'web')

      -- Each should have appropriate components
      assert.is_not_nil(lua_components.lualine_a)
      assert.is_not_nil(python_components.lualine_b)
      assert.is_not_nil(js_components.lualine_b)
    end)
  end)

  describe('cache management', function()
    it('should clear cache', function()
      loader.prediction_cache = { test = 'data' }
      loader:clear_cache()
      assert.is_nil(loader.prediction_cache.test)
    end)
  end)
end)
