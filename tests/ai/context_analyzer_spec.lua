-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local context_analyzer = require('lualine.ai.context_analyzer')

describe('ContextAnalyzer', function()
  local analyzer

  before_each(function()
    analyzer = context_analyzer.new()
  end)

  describe('project context analysis', function()
    it('should detect web projects', function()
      -- Mock file system for web project
      local original_filereadable = vim.fn.filereadable
      vim.fn.filereadable = function(path)
        if path:find('package.json') then return 1 end
        return 0
      end

      local project_type = analyzer:analyze_project_context()
      assert.equals('web', project_type)

      vim.fn.filereadable = original_filereadable
    end)

    it('should detect python projects', function()
      local original_filereadable = vim.fn.filereadable
      vim.fn.filereadable = function(path)
        if path:find('requirements.txt') then return 1 end
        return 0
      end

      local project_type = analyzer:analyze_project_context()
      assert.equals('python', project_type)

      vim.fn.filereadable = original_filereadable
    end)

    it('should detect rust projects', function()
      local original_filereadable = vim.fn.filereadable
      vim.fn.filereadable = function(path)
        if path:find('Cargo.toml') then return 1 end
        return 0
      end

      local project_type = analyzer:analyze_project_context()
      assert.equals('rust', project_type)

      vim.fn.filereadable = original_filereadable
    end)

    it('should return unknown for unrecognized projects', function()
      local original_filereadable = vim.fn.filereadable
      vim.fn.filereadable = function() return 0 end

      local project_type = analyzer:analyze_project_context()
      assert.equals('unknown', project_type)

      vim.fn.filereadable = original_filereadable
    end)
  end)

  describe('file context analysis', function()
    it('should identify test files', function()
      local original_expand = vim.fn.expand
      vim.fn.expand = function(fmt)
        if fmt == '%:t' then return 'test_component.lua' end
        if fmt == '%:p' then return '/path/to/test_component.lua' end
        return ''
      end

      local context = analyzer:analyze_file_context()
      assert.is_true(context.is_test)

      vim.fn.expand = original_expand
    end)

    it('should identify config files', function()
      local original_expand = vim.fn.expand
      vim.fn.expand = function(fmt)
        if fmt == '%:t' then return 'config.lua' end
        if fmt == '%:p' then return '/path/to/config.lua' end
        return ''
      end

      local context = analyzer:analyze_file_context()
      assert.is_true(context.is_config)

      vim.fn.expand = original_expand
    end)

    it('should identify documentation files', function()
      local original_expand = vim.fn.expand
      local original_filetype = vim.bo.filetype
      vim.fn.expand = function(fmt)
        if fmt == '%:t' then return 'README.md' end
        return ''
      end
      vim.bo.filetype = 'markdown'

      local context = analyzer:analyze_file_context()
      assert.is_true(context.is_documentation)

      vim.fn.expand = original_expand
      vim.bo.filetype = original_filetype
    end)
  end)

  describe('component suggestions', function()
    it('should suggest web development components', function()
      local original_filereadable = vim.fn.filereadable
      vim.fn.filereadable = function(path)
        if path:find('package.json') then return 1 end
        return 0
      end

      local suggestions = analyzer:suggest_components()
      assert.is_not_nil(suggestions.lualine_b)
      assert.is_not_nil(suggestions.lualine_x)

      vim.fn.filereadable = original_filereadable
    end)

    it('should suggest python development components', function()
      local original_filereadable = vim.fn.filereadable
      vim.fn.filereadable = function(path)
        if path:find('requirements.txt') then return 1 end
        return 0
      end

      local suggestions = analyzer:suggest_components()
      assert.is_not_nil(suggestions.lualine_b)
      assert.is_not_nil(suggestions.lualine_x)

      vim.fn.filereadable = original_filereadable
    end)
  end)

  describe('learning system', function()
    it('should learn from usage patterns', function()
      local usage_data = {
        smart_filename = 10,
        minimal_git = 8,
        filetype = 5,
      }

      analyzer:learn_from_usage(usage_data)
      local optimized = analyzer:get_optimized_components()

      assert.is_not_nil(optimized['smart_filename'])
      assert.is_not_nil(optimized['minimal_git'])
    end)

    it('should clear cache', function()
      analyzer.context_cache = { test = 'data' }
      analyzer:clear_cache()
      assert.is_nil(analyzer.context_cache.test)
    end)
  end)
end)
