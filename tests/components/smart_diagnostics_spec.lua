-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

local smart_diagnostics = require('lualine.components.smart_diagnostics')

describe('SmartDiagnostics', function()
  local component

  before_each(function()
    component = smart_diagnostics.new()
    component:init({
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn', 'info', 'hint' },
      symbols = {
        error = 'E',
        warn = 'W',
        info = 'I',
        hint = 'H',
      },
      colored = true,
      smart_grouping = true,
    })
  end)

  describe('diagnostic retrieval', function()
    it('should get nvim diagnostics', function()
      -- Mock vim.diagnostic
      local original_diagnostic = vim.diagnostic
      vim.diagnostic = {
        get = function()
          return {
            { severity = 1 }, -- ERROR
            { severity = 2 }, -- WARN
            { severity = 3 }, -- INFO
            { severity = 4 }, -- HINT
          }
        end,
        severity = {
          ERROR = 1,
          WARN = 2,
          INFO = 3,
          HINT = 4,
        }
      }

      local diagnostics = component:get_nvim_diagnostics()
      assert.is_not_nil(diagnostics)
      assert.is_not_nil(diagnostics.error)
      assert.is_not_nil(diagnostics.warn)
      assert.is_not_nil(diagnostics.info)
      assert.is_not_nil(diagnostics.hint)

      vim.diagnostic = original_diagnostic
    end)

    it('should handle empty diagnostics', function()
      local original_diagnostic = vim.diagnostic
      vim.diagnostic = {
        get = function() return {} end,
        severity = {
          ERROR = 1,
          WARN = 2,
          INFO = 3,
          HINT = 4,
        }
      }

      local diagnostics = component:get_nvim_diagnostics()
      assert.is_not_nil(diagnostics)
      assert.equals(0, diagnostics.error or 0)
      assert.equals(0, diagnostics.warn or 0)

      vim.diagnostic = original_diagnostic
    end)
  end)

  describe('smart grouping', function()
    it('should group diagnostics by severity priority', function()
      local diagnostics = {
        error = 2,
        warn = 3,
        info = 1,
        hint = 1,
      }

      local grouped = component:apply_smart_grouping(diagnostics)
      
      -- Should prioritize error over warn
      assert.is_not_nil(grouped.error)
      assert.equals(2, grouped.error)
    end)

    it('should handle empty diagnostics in grouping', function()
      local diagnostics = {}
      local grouped = component:apply_smart_grouping(diagnostics)
      assert.is_not_nil(grouped)
    end)
  end)

  describe('diagnostic formatting', function()
    it('should format diagnostics correctly', function()
      local diagnostics = {
        error = 2,
        warn = 1,
        info = 0,
        hint = 0,
      }

      local formatted = component:format_diagnostics(diagnostics)
      assert.is_not_nil(formatted)
      assert.matches('E2', formatted)
      assert.matches('W1', formatted)
    end)

    it('should handle colored output', function()
      component.options.colored = true
      local diagnostics = { error = 1 }
      local formatted = component:format_diagnostics(diagnostics)
      
      -- Should contain color codes
      assert.matches('%%#', formatted)
    end)

    it('should handle non-colored output', function()
      component.options.colored = false
      local diagnostics = { error = 1 }
      local formatted = component:format_diagnostics(diagnostics)
      
      -- Should not contain color codes
      assert.not_matches('%%#', formatted)
    end)
  end)

  describe('truncation', function()
    it('should truncate long diagnostic strings', function()
      component.options.max_length = 10
      local long_diagnostics = { error = 999, warn = 888, info = 777 }
      local formatted = component:format_diagnostics(long_diagnostics)
      
      if #formatted > 10 then
        local truncated = component:truncate_diagnostics(formatted)
        assert.is_true(#truncated <= 10)
      end
    end)
  end)

  describe('severity name mapping', function()
    it('should map severity numbers to names', function()
      local original_diagnostic = vim.diagnostic
      vim.diagnostic = {
        severity = {
          ERROR = 1,
          WARN = 2,
          INFO = 3,
          HINT = 4,
        }
      }

      assert.equals('error', component:get_severity_name(1))
      assert.equals('warn', component:get_severity_name(2))
      assert.equals('info', component:get_severity_name(3))
      assert.equals('hint', component:get_severity_name(4))
      assert.is_nil(component:get_severity_name(5))

      vim.diagnostic = original_diagnostic
    end)
  end)

  describe('empty diagnostics check', function()
    it('should identify empty diagnostics', function()
      local empty_diagnostics = { error = 0, warn = 0, info = 0, hint = 0 }
      assert.is_true(component:is_empty(empty_diagnostics))
    end)

    it('should identify non-empty diagnostics', function()
      local non_empty_diagnostics = { error = 1, warn = 0, info = 0, hint = 0 }
      assert.is_false(component:is_empty(non_empty_diagnostics))
    end)
  end)

  describe('performance stats', function()
    it('should provide performance statistics', function()
      local stats = component:get_performance_stats()
      assert.is_not_nil(stats)
      assert.is_not_nil(stats.cache_hit_rate)
      assert.is_not_nil(stats.last_update)
      assert.is_not_nil(stats.grouping_cache_size)
    end)
  end)
end)
