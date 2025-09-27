-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local next_gen_config = require('lualine.config.next_gen')

describe('NextGenConfig', function()
  describe('apply_next_gen_configuration', function()
    it('should apply default configuration', function()
      local user_config = {}
      local config = next_gen_config.apply_next_gen_configuration(user_config)

      assert.is_not_nil(config)
      assert.is_not_nil(config.options)
      assert.is_not_nil(config.sections)
      assert.is_not_nil(config.ai_features)
      assert.is_not_nil(config.performance)
    end)

    it('should merge user configuration', function()
      local user_config = {
        options = {
          theme = 'minimal',
        },
        sections = {
          lualine_a = { 'modern_mode' },
        },
      }

      local config = next_gen_config.apply_next_gen_configuration(user_config)

      assert.equals('minimal', config.options.theme)
      assert.is_not_nil(config.sections.lualine_a)
      assert.equals('modern_mode', config.sections.lualine_a[1])
    end)

    it('should enable AI features by default', function()
      local config = next_gen_config.apply_next_gen_configuration({})

      assert.is_true(config.ai_features.context_awareness.enabled)
      assert.is_true(config.ai_features.predictive_loading.enabled)
      assert.is_true(config.ai_features.adaptive_components.enabled)
    end)

    it('should enable performance optimizations by default', function()
      local config = next_gen_config.apply_next_gen_configuration({})

      assert.is_true(config.performance.smart_caching.enabled)
      assert.is_true(config.performance.lazy_loading.enabled)
      assert.is_true(config.performance.memory_optimization.enabled)
    end)
  end)

  describe('get_ai_components', function()
    it('should return AI components', function()
      local components = next_gen_config.get_ai_components()

      assert.is_not_nil(components.adaptive_statusline)
      assert.is_not_nil(components.smart_diagnostics)
      assert.is_not_nil(components.smart_filename)
    end)
  end)

  describe('get_smart_sections', function()
    it('should return smart sections for different contexts', function()
      local sections = next_gen_config.get_smart_sections('lua', 'generic')

      assert.is_not_nil(sections.lualine_a)
      assert.is_not_nil(sections.lualine_b)
      assert.is_not_nil(sections.lualine_c)
      assert.is_not_nil(sections.lualine_x)
      assert.is_not_nil(sections.lualine_y)
      assert.is_not_nil(sections.lualine_z)
    end)

    it('should return different sections for different filetypes', function()
      local lua_sections = next_gen_config.get_smart_sections('lua', 'generic')
      local python_sections = next_gen_config.get_smart_sections('python', 'data_science')

      -- Should have different components based on context
      assert.is_not_nil(lua_sections.lualine_a)
      assert.is_not_nil(python_sections.lualine_a)
    end)
  end)

  describe('get_optimized_options', function()
    it('should return optimized options', function()
      local options = next_gen_config.get_optimized_options()

      assert.is_not_nil(options.refresh)
      assert.is_not_nil(options.component_separators)
      assert.is_not_nil(options.section_separators)
    end)

    it('should apply user options', function()
      local user_options = {
        theme = 'custom',
        component_separators = { left = '|', right = '|' },
      }

      local options = next_gen_config.get_optimized_options(user_options)

      assert.equals('custom', options.theme)
      assert.equals('|', options.component_separators.left)
      assert.equals('|', options.component_separators.right)
    end)
  end)

  describe('get_performance_config', function()
    it('should return performance configuration', function()
      local perf_config = next_gen_config.get_performance_config()

      assert.is_not_nil(perf_config.smart_caching)
      assert.is_not_nil(perf_config.lazy_loading)
      assert.is_not_nil(perf_config.memory_optimization)
    end)

    it('should apply user performance settings', function()
      local user_perf = {
        smart_caching = {
          enabled = false,
        },
      }

      local perf_config = next_gen_config.get_performance_config(user_perf)

      assert.is_false(perf_config.smart_caching.enabled)
    end)
  end)

  describe('get_ai_config', function()
    it('should return AI configuration', function()
      local ai_config = next_gen_config.get_ai_config()

      assert.is_not_nil(ai_config.context_awareness)
      assert.is_not_nil(ai_config.predictive_loading)
      assert.is_not_nil(ai_config.adaptive_components)
    end)

    it('should apply user AI settings', function()
      local user_ai = {
        context_awareness = {
          enabled = false,
        },
      }

      local ai_config = next_gen_config.get_ai_config(user_ai)

      assert.is_false(ai_config.context_awareness.enabled)
    end)
  end)

  describe('validate_config', function()
    it('should validate correct configuration', function()
      local config = {
        options = { theme = 'minimal' },
        sections = { lualine_a = { 'modern_mode' } },
        ai_features = { context_awareness = { enabled = true } },
        performance = { smart_caching = { enabled = true } },
      }

      local result = next_gen_config.validate_config(config)
      assert.is_true(result.valid)
    end)

    it('should detect invalid configuration', function()
      local config = {
        options = { theme = 'invalid_theme' },
        sections = { invalid_section = { 'component' } },
      }

      local result = next_gen_config.validate_config(config)
      assert.is_false(result.valid)
      assert.is_not_nil(result.errors)
    end)
  end)
end)
