-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local M = require('lualine.component'):extend()

local context_analyzer = require('lualine.ai.context_analyzer')
local predictive_loader = require('lualine.utils.predictive_loader')

---@class AdaptiveStatuslineOptions
---@field auto_adapt boolean
---@field learning_enabled boolean
---@field adaptation_threshold number
---@field cache_duration number

local default_options = {
  auto_adapt = true,
  learning_enabled = true,
  adaptation_threshold = 0.7,
  cache_duration = 5000, -- 5 seconds
}

---@param self AdaptiveStatuslineComponent
---@param options AdaptiveStatuslineOptions
function M.init(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  
  -- Initialize AI components
  self.context_analyzer = context_analyzer.new()
  self.predictive_loader = predictive_loader.new()
  
  -- Performance tracking
  self.performance_tracker = {
    adaptation_count = 0,
    last_adaptation = 0,
    adaptation_time = 0,
  }
end

---@param self AdaptiveStatuslineComponent
---@return string statusline_content
function M.update_status(self)
  if not self.options.auto_adapt then
    return self:get_default_statusline()
  end
  
  -- Check if we need to adapt
  if self:should_adapt() then
    return self:adapt_statusline()
  end
  
  -- Return cached or default statusline
  return self:get_cached_statusline()
end

---@param self AdaptiveStatuslineComponent
---@return boolean should_adapt
function M.should_adapt(self)
  local now = vim.loop.now()
  local time_since_last = now - self.performance_tracker.last_adaptation
  
  -- Don't adapt too frequently
  if time_since_last < 1000 then -- 1 second minimum
    return false
  end
  
  -- Check for significant context changes
  local current_context = self:get_current_context()
  local last_context = self.context_cache or {}
  
  -- Compare contexts
  for key, value in pairs(current_context) do
    if last_context[key] ~= value then
      return true
    end
  end
  
  return false
end

---@param self AdaptiveStatuslineComponent
---@return table<string, any> current_context
function M.get_current_context(self)
  return {
    filetype = vim.bo.filetype,
    filename = vim.fn.expand('%:t'),
    project_type = self.context_analyzer:analyze_project_context(),
    file_context = self.context_analyzer:analyze_file_context(),
    window_width = vim.fn.winwidth(0),
    is_focused = vim.api.nvim_get_current_win() == vim.g.actual_curwin,
  }
end

---@param self AdaptiveStatuslineComponent
---@return string adapted_statusline
function M.adapt_statusline(self)
  local start_time = vim.loop.now()
  
  -- Get current context
  local context = self:get_current_context()
  
  -- Get AI suggestions
  local suggested_components = self.context_analyzer:suggest_components()
  local predicted_components = self.predictive_loader:get_optimized_sections(
    context.filetype,
    context.project_type
  )
  
  -- Merge suggestions with predictions
  local optimized_sections = self:merge_suggestions(suggested_components, predicted_components)
  
  -- Apply window width optimizations
  optimized_sections = self:optimize_for_width(optimized_sections, context.window_width)
  
  -- Cache the result
  self.context_cache = context
  self.cached_sections = optimized_sections
  
  -- Record performance
  local adaptation_time = vim.loop.now() - start_time
  self.performance_tracker.adaptation_count = self.performance_tracker.adaptation_count + 1
  self.performance_tracker.last_adaptation = vim.loop.now()
  self.performance_tracker.adaptation_time = adaptation_time
  
  -- Learn from this adaptation
  if self.options.learning_enabled then
    self:learn_from_adaptation(optimized_sections, context)
  end
  
  return self:render_adapted_statusline(optimized_sections)
end

---@param self AdaptiveStatuslineComponent
---@param suggested table<string, any>
---@param predicted table<string, any>
---@return table<string, any> merged_sections
function M.merge_suggestions(self, suggested, predicted)
  local merged = {}
  
  -- Start with suggestions as base
  for section, components in pairs(suggested) do
    merged[section] = vim.deepcopy(components)
  end
  
  -- Add high-confidence predictions
  for section, components in pairs(predicted) do
    if not merged[section] then
      merged[section] = {}
    end
    
    for _, component in ipairs(components) do
      -- Avoid duplicates
      local exists = false
      for _, existing in ipairs(merged[section]) do
        if existing == component then
          exists = true
          break
        end
      end
      
      if not exists then
        table.insert(merged[section], component)
      end
    end
  end
  
  return merged
end

---@param self AdaptiveStatuslineComponent
---@param sections table<string, any>
---@param width number
---@return table<string, any> optimized_sections
function M.optimize_for_width(self, sections, width)
  local optimized = vim.deepcopy(sections)
  
  if width < 80 then
    -- Very narrow: minimal components
    optimized.lualine_b = {}
    optimized.lualine_x = { 'filetype' }
  elseif width < 120 then
    -- Narrow: essential components only
    if #optimized.lualine_b > 2 then
      optimized.lualine_b = { optimized.lualine_b[1], optimized.lualine_b[2] }
    end
  elseif width > 200 then
    -- Wide: can show more components
    if not optimized.lualine_b then
      optimized.lualine_b = {}
    end
    table.insert(optimized.lualine_b, 'encoding')
    table.insert(optimized.lualine_b, 'fileformat')
  end
  
  return optimized
end

---@param self AdaptiveStatuslineComponent
---@param sections table<string, any>
---@param context table<string, any>
function M.learn_from_adaptation(self, sections, context)
  -- Record component usage
  for section, components in pairs(sections) do
    for _, component in ipairs(components) do
      self.predictive_loader:record_component_usage(component, context)
    end
  end
  
  -- Update context analyzer learning data
  local usage_data = {}
  for section, components in pairs(sections) do
    for _, component in ipairs(components) do
      usage_data[component] = (usage_data[component] or 0) + 1
    end
  end
  
  self.context_analyzer:learn_from_usage(usage_data)
end

---@param self AdaptiveStatuslineComponent
---@param sections table<string, any>
---@return string rendered_statusline
function M.render_adapted_statusline(self, sections)
  -- This would integrate with the main lualine rendering system
  -- For now, return a placeholder
  local status_parts = {}
  
  for section, components in pairs(sections) do
    if #components > 0 then
      table.insert(status_parts, table.concat(components, ' '))
    end
  end
  
  return table.concat(status_parts, ' | ')
end

---@param self AdaptiveStatuslineComponent
---@return string default_statusline
function M.get_default_statusline(self)
  return 'modern_mode | smart_filename | filetype | progress | location'
end

---@param self AdaptiveStatuslineComponent
---@return string cached_statusline
function M.get_cached_statusline(self)
  if self.cached_sections then
    return self:render_adapted_statusline(self.cached_sections)
  end
  
  return self:get_default_statusline()
end

---@param self AdaptiveStatuslineComponent
---@return table<string, any> performance_stats
function M.get_performance_stats(self)
  return {
    adaptation_count = self.performance_tracker.adaptation_count,
    last_adaptation = self.performance_tracker.last_adaptation,
    average_adaptation_time = self.performance_tracker.adaptation_time,
    cache_hit_rate = self:calculate_cache_hit_rate(),
  }
end

---@param self AdaptiveStatuslineComponent
---@return number cache_hit_rate
function M.calculate_cache_hit_rate(self)
  -- Simplified cache hit rate calculation
  local total_requests = self.performance_tracker.adaptation_count + 1
  local cache_hits = total_requests - self.performance_tracker.adaptation_count
  return cache_hits / total_requests
end

---@param self AdaptiveStatuslineComponent
function M.clear_cache(self)
  self.context_cache = {}
  self.cached_sections = nil
  self.context_analyzer:clear_cache()
  self.predictive_loader:clear_cache()
end

return M
