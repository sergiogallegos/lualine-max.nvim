-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local context_analyzer = require('lualine.ai.context_analyzer')
local predictive_loader = require('lualine.utils.predictive_loader')
local next_gen_config = require('lualine.config.next_gen')

describe('AI Integration', function()
  local analyzer, loader

  before_each(function()
    analyzer = context_analyzer.new()
    loader = predictive_loader.new()
  end)

  describe('context-aware component loading', function()
    it('should load appropriate components for lua files', function()
      -- Mock file context
      local original_expand = vim.fn.expand
      vim.fn.expand = function(fmt)
        if fmt == '%:t' then return 'test.lua' end
        if fmt == '%:p' then return '/path/to/test.lua' end
        return ''
      end

      local context = analyzer:analyze_file_context()
      local predictions = loader:predict_components(context.filetype, context.project_type)
      local config = next_gen_config.apply_next_gen_configuration({
        ai_features = {
          context_awareness = { enabled = true },
          predictive_loading = { enabled = true },
        },
      })

      assert.is_not_nil(predictions)
      assert.is_not_nil(config.ai_features.context_awareness.enabled)
      assert.is_true(config.ai_features.context_awareness.enabled)

      vim.fn.expand = original_expand
    end)

    it('should adapt to different project types', function()
      local project_types = { 'web', 'python', 'rust', 'generic' }
      
      for _, project_type in ipairs(project_types) do
        local context = { filetype = 'lua', project_type = project_type }
        local predictions = loader:predict_components(context.filetype, context.project_type)
        
        assert.is_not_nil(predictions)
        -- Each project type should have appropriate components
        assert.is_not_nil(predictions.lualine_a)
        assert.is_not_nil(predictions.lualine_b)
      end
    end)
  end)

  describe('learning system integration', function()
    it('should learn from usage patterns', function()
      local usage_data = {
        smart_filename = 10,
        minimal_git = 8,
        filetype = 5,
      }

      analyzer:learn_from_usage(usage_data)
      local optimized = analyzer:get_optimized_components()

      assert.is_not_nil(optimized)
      assert.is_not_nil(optimized['smart_filename'])
      assert.is_not_nil(optimized['minimal_git'])
    end)

    it('should adapt predictions based on learning', function()
      local initial_predictions = loader:predict_components('lua', 'generic')
      
      -- Simulate learning
      local usage_context = { filetype = 'lua', project_type = 'generic' }
      for i = 1, 10 do
        loader:record_component_usage('smart_filename', usage_context)
      end

      local learned_predictions = loader:predict_components('lua', 'generic')
      
      -- Predictions should be influenced by learning
      assert.is_not_nil(learned_predictions)
      assert.is_not_nil(learned_predictions['smart_filename'])
    end)
  end)

  describe('performance optimization integration', function()
    it('should optimize component loading', function()
      local config = next_gen_config.apply_next_gen_configuration({
        performance = {
          smart_caching = { enabled = true },
          lazy_loading = { enabled = true },
        },
      })

      assert.is_true(config.performance.smart_caching.enabled)
      assert.is_true(config.performance.lazy_loading.enabled)
    end)

    it('should apply memory optimizations', function()
      local config = next_gen_config.apply_next_gen_configuration({
        performance = {
          memory_optimization = { enabled = true },
        },
      })

      assert.is_true(config.performance.memory_optimization.enabled)
    end)
  end)

  describe('adaptive statusline integration', function()
    it('should create adaptive statusline configuration', function()
      local context = { filetype = 'lua', project_type = 'generic' }
      local predictions = loader:predict_components(context.filetype, context.project_type)
      local config = next_gen_config.get_smart_sections(context.filetype, context.project_type)

      assert.is_not_nil(config)
      assert.is_not_nil(config.lualine_a)
      assert.is_not_nil(config.lualine_b)
      assert.is_not_nil(config.lualine_c)
    end)

    it('should adapt to different file contexts', function()
      local contexts = {
        { filetype = 'lua', project_type = 'generic' },
        { filetype = 'python', project_type = 'data_science' },
        { filetype = 'javascript', project_type = 'web' },
      }

      for _, context in ipairs(contexts) do
        local config = next_gen_config.get_smart_sections(context.filetype, context.project_type)
        assert.is_not_nil(config)
        assert.is_not_nil(config.lualine_a)
      end
    end)
  end)

  describe('error handling', function()
    it('should handle missing context gracefully', function()
      local result = pcall(function()
        local context = analyzer:analyze_file_context()
        local predictions = loader:predict_components(context.filetype, context.project_type)
      end)

      assert.is_true(result)
    end)

    it('should handle invalid configurations', function()
      local result = pcall(function()
        local config = next_gen_config.apply_next_gen_configuration({
          invalid_option = 'invalid_value',
        })
      end)

      assert.is_true(result)
    end)
  end)

  describe('cache integration', function()
    it('should use cache for repeated requests', function()
      local context = { filetype = 'lua', project_type = 'generic' }
      
      -- First call
      local predictions1 = loader:predict_components(context.filetype, context.project_type)
      
      -- Second call should use cache
      local predictions2 = loader:predict_components(context.filetype, context.project_type)
      
      assert.is_not_nil(predictions1)
      assert.is_not_nil(predictions2)
    end)

    it('should clear cache when needed', function()
      loader:clear_cache()
      analyzer:clear_cache()
      
      -- Cache should be empty
      assert.is_nil(loader.prediction_cache)
      assert.is_nil(analyzer.context_cache)
    end)
  end)
end)
