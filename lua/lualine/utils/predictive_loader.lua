-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

---@class PredictiveLoader
---@field usage_patterns table<string, number>
---@field component_weights table<string, number>
---@field preloaded_components table<string, any>
---@field prediction_cache table<string, any>
local PredictiveLoader = {}
PredictiveLoader.__index = PredictiveLoader

---@return PredictiveLoader
function PredictiveLoader.new()
  local self = setmetatable({}, PredictiveLoader)
  self.usage_patterns = {}
  self.component_weights = {}
  self.preloaded_components = {}
  self.prediction_cache = {}
  return self
end

---@param self PredictiveLoader
---@param filetype string
---@param project_type string
---@return table<string, number> predicted_components
function PredictiveLoader:predict_components(filetype, project_type)
  local cache_key = filetype .. '_' .. project_type
  if self.prediction_cache[cache_key] then
    return self.prediction_cache[cache_key]
  end
  
  local predictions = {}
  
  -- Base predictions for all contexts
  predictions['modern_mode'] = 0.9
  predictions['smart_filename'] = 0.8
  predictions['progress'] = 0.7
  predictions['location'] = 0.6
  
  -- Filetype-specific predictions
  if filetype == 'lua' then
    predictions['minimal_git'] = 0.8
    predictions['filetype'] = 0.7
    predictions['lsp_status'] = 0.6
  elseif filetype == 'python' then
    predictions['minimal_git'] = 0.9
    predictions['python_env'] = 0.8
    predictions['filetype'] = 0.7
    predictions['diagnostics'] = 0.6
  elseif filetype == 'javascript' or filetype == 'typescript' then
    predictions['minimal_git'] = 0.9
    predictions['npm_status'] = 0.7
    predictions['filetype'] = 0.8
    predictions['diagnostics'] = 0.7
  elseif filetype == 'rust' then
    predictions['minimal_git'] = 0.9
    predictions['cargo_status'] = 0.8
    predictions['filetype'] = 0.7
    predictions['diagnostics'] = 0.6
  elseif filetype == 'go' then
    predictions['minimal_git'] = 0.9
    predictions['go_version'] = 0.7
    predictions['filetype'] = 0.7
    predictions['diagnostics'] = 0.6
  elseif filetype == 'markdown' then
    predictions['word_count'] = 0.8
    predictions['filetype'] = 0.6
  elseif filetype == 'css' or filetype == 'scss' or filetype == 'sass' then
    predictions['filetype'] = 0.8
    predictions['file_size'] = 0.6
  end
  
  -- Project type adjustments
  if project_type == 'web' then
    predictions['bundle_size'] = 0.6
    predictions['npm_status'] = 0.7
  elseif project_type == 'mobile' then
    predictions['device_status'] = 0.7
    predictions['build_status'] = 0.6
  elseif project_type == 'data_science' then
    predictions['python_env'] = 0.9
    predictions['jupyter_status'] = 0.7
    predictions['data_status'] = 0.6
  elseif project_type == 'devops' then
    predictions['docker_status'] = 0.8
    predictions['k8s_status'] = 0.6
    predictions['terraform_status'] = 0.5
  end
  
  -- Apply usage pattern learning
  for component, weight in pairs(predictions) do
    local usage_boost = self.usage_patterns[component] or 0
    predictions[component] = weight + (usage_boost * 0.1)
  end
  
  -- Sort by prediction confidence
  local sorted_predictions = {}
  for component, confidence in pairs(predictions) do
    table.insert(sorted_predictions, { component = component, confidence = confidence })
  end
  
  table.sort(sorted_predictions, function(a, b)
    return a.confidence > b.confidence
  end)
  
  self.prediction_cache[cache_key] = sorted_predictions
  return sorted_predictions
end

---@param self PredictiveLoader
---@param component_name string
---@param usage_context table<string, any>
function PredictiveLoader:record_component_usage(component_name, usage_context)
  local context_key = component_name .. '_' .. (usage_context.filetype or 'unknown')
  self.usage_patterns[context_key] = (self.usage_patterns[context_key] or 0) + 1
  
  -- Update component weights based on usage
  self.component_weights[component_name] = (self.component_weights[component_name] or 0) + 1
end

---@param self PredictiveLoader
---@param components table<string, number>
function PredictiveLoader:preload_components(components)
  for component_name, confidence in pairs(components) do
    if confidence > 0.7 and not self.preloaded_components[component_name] then
      -- Preload high-confidence components
      local ok, component = pcall(require, 'lualine.components.' .. component_name)
      if ok and component then
        self.preloaded_components[component_name] = component
      end
    end
  end
end

---@param self PredictiveLoader
---@param filetype string
---@param project_type string
---@return table<string, any> optimized_sections
function PredictiveLoader:get_optimized_sections(filetype, project_type)
  local predictions = self:predict_components(filetype, project_type)
  
  local sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
  
  -- Always include core components
  table.insert(sections.lualine_a, 'modern_mode')
  table.insert(sections.lualine_c, 'smart_filename')
  table.insert(sections.lualine_y, 'progress')
  table.insert(sections.lualine_z, 'location')
  
  -- Add predicted components based on confidence
  for _, prediction in ipairs(predictions) do
    local component = prediction.component
    local confidence = prediction.confidence
    
    if confidence > 0.8 then
      -- High confidence: add to primary sections
      if component == 'minimal_git' then
        table.insert(sections.lualine_b, component)
      elseif component == 'filetype' or component == 'encoding' then
        table.insert(sections.lualine_x, component)
      end
    elseif confidence > 0.6 then
      -- Medium confidence: add to secondary sections
      if component:find('status') or component:find('diagnostics') then
        table.insert(sections.lualine_b, component)
      end
    end
  end
  
  return sections
end

---@param self PredictiveLoader
---@param filetype string
---@param project_type string
---@return table<string, any> smart_components
function PredictiveLoader:get_smart_components(filetype, project_type)
  local smart_components = {}
  
  -- Filetype-specific smart components
  if filetype == 'python' then
    smart_components = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git', 'python_env' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'filetype', 'diagnostics' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
  elseif filetype == 'javascript' or filetype == 'typescript' then
    smart_components = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git', 'npm_status' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'filetype', 'diagnostics' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
  elseif filetype == 'rust' then
    smart_components = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git', 'cargo_status' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'filetype', 'diagnostics' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
  elseif filetype == 'markdown' then
    smart_components = {
      lualine_a = { 'modern_mode' },
      lualine_b = {},
      lualine_c = { 'smart_filename' },
      lualine_x = { 'word_count', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
  else
    -- Generic smart components
    smart_components = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
  end
  
  return smart_components
end

---@param self PredictiveLoader
function PredictiveLoader:clear_cache()
  self.prediction_cache = {}
end

---@param self PredictiveLoader
---@return table<string, number> usage_stats
function PredictiveLoader:get_usage_stats()
  return self.usage_patterns
end

---@param self PredictiveLoader
---@param threshold number
---@return table<string, any> frequently_used_components
function PredictiveLoader:get_frequently_used_components(threshold)
  threshold = threshold or 5
  local frequent = {}
  
  for component, count in pairs(self.usage_patterns) do
    if count >= threshold then
      frequent[component] = count
    end
  end
  
  return frequent
end

return PredictiveLoader
