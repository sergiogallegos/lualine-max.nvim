-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local utils = require('lualine.utils.utils')
local component_loader = require('lualine.utils.component_loader')

---@class NextGenLualineConfig
---@field options table
---@field sections table
---@field inactive_sections table
---@field tabline table
---@field winbar table
---@field inactive_winbar table
---@field extensions table
---@field ai_features table
---@field performance table

---@return NextGenLualineConfig
local function create_next_gen_config()
  return {
    options = {
      icons_enabled = true,
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
        winbar = {},
      },
      ignore_focus = { 'qf', 'help', 'man', 'lazy' },
      always_divide_middle = false,
      always_show_tabline = false,
      globalstatus = vim.go.laststatus == 3,
      refresh = {
        statusline = 300, -- Even more frequent for AI features
        tabline = 1000,
        winbar = 1000,
        refresh_time = 4, -- 240fps for ultra-smooth AI updates
        events = {
          'WinEnter',
          'BufEnter',
          'ModeChanged',
          'Filetype',
          'CursorMoved',
          'CursorMovedI',
        },
      },
    },
    sections = {
      lualine_a = { 'adaptive_statusline' },
      lualine_b = { 'smart_diagnostics' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'smart_filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
    
    -- AI Features Configuration
    ai_features = {
      context_awareness = {
        enabled = true,
        learning_rate = 0.1,
        adaptation_threshold = 0.7,
        cache_duration = 5000,
      },
      predictive_loading = {
        enabled = true,
        preload_threshold = 0.8,
        learning_enabled = true,
        usage_tracking = true,
      },
      smart_components = {
        enabled = true,
        auto_optimize = true,
        performance_tracking = true,
        adaptive_refresh = true,
      },
    },
    
    -- Performance Configuration
    performance = {
      smart_caching = {
        enabled = true,
        cache_ttl = 200, -- 200ms cache TTL
        max_cache_size = 1000,
        cache_eviction = 'lru',
      },
      predictive_refresh = {
        enabled = true,
        prediction_accuracy_threshold = 0.8,
        adaptive_timing = true,
        context_switching_detection = true,
      },
      memory_optimization = {
        enabled = true,
        component_pooling = true,
        string_interning = true,
        table_reuse = true,
      },
    },
  }
end

---@param config NextGenLualineConfig
---@return NextGenLualineConfig validated_config
local function validate_next_gen_config(config)
  -- Validate AI features
  if config.ai_features then
    if config.ai_features.context_awareness then
      config.ai_features.context_awareness.learning_rate = 
        math.max(0.01, math.min(1.0, config.ai_features.context_awareness.learning_rate or 0.1))
      config.ai_features.context_awareness.adaptation_threshold = 
        math.max(0.1, math.min(1.0, config.ai_features.context_awareness.adaptation_threshold or 0.7))
    end
    
    if config.ai_features.predictive_loading then
      config.ai_features.predictive_loading.preload_threshold = 
        math.max(0.1, math.min(1.0, config.ai_features.predictive_loading.preload_threshold or 0.8))
    end
  end
  
  -- Validate performance settings
  if config.performance then
    if config.performance.smart_caching then
      config.performance.smart_caching.cache_ttl = 
        math.max(50, math.min(5000, config.performance.smart_caching.cache_ttl or 200))
      config.performance.smart_caching.max_cache_size = 
        math.max(100, math.min(10000, config.performance.smart_caching.max_cache_size or 1000))
    end
    
    if config.performance.predictive_refresh then
      config.performance.predictive_refresh.prediction_accuracy_threshold = 
        math.max(0.1, math.min(1.0, config.performance.predictive_refresh.prediction_accuracy_threshold or 0.8))
    end
  end
  
  -- Ensure refresh settings are optimized
  if config.options.refresh then
    config.options.refresh.refresh_time = math.max(4, config.options.refresh.refresh_time or 4)
    config.options.refresh.statusline = math.max(100, config.options.refresh.statusline or 300)
  end
  
  return config
end

---@param user_config table|nil
---@return NextGenLualineConfig
local function apply_next_gen_configuration(user_config)
  local config = create_next_gen_config()
  
  if not user_config then
    return config
  end
  
  -- Deep merge user config with next-gen defaults
  config = vim.tbl_deep_extend('force', config, user_config)
  
  -- Validate and optimize configuration
  config = validate_next_gen_config(config)
  
  return config
end

---@param config NextGenLualineConfig
---@return table<string, any> performance_metrics
local function get_performance_metrics(config)
  return {
    ai_features_enabled = config.ai_features.context_awareness.enabled,
    predictive_loading_enabled = config.ai_features.predictive_loading.enabled,
    smart_caching_enabled = config.performance.smart_caching.enabled,
    refresh_rate = 1000 / config.options.refresh.refresh_time,
    cache_ttl = config.performance.smart_caching.cache_ttl,
    adaptation_threshold = config.ai_features.context_awareness.adaptation_threshold,
  }
end

---@param config NextGenLualineConfig
---@return table<string, any> optimized_sections
local function get_optimized_sections(config)
  local sections = vim.deepcopy(config.sections)
  
  -- Apply AI optimizations with safe component loading
  if config.ai_features.smart_components.enabled then
    -- Replace static components with smart ones using safe loader
    for section, components in pairs(sections) do
      for i, component in ipairs(components) do
        if component == 'diagnostics' then
          components[i] = component_loader.safe_component('smart_diagnostics', 'diagnostics')
        elseif component == 'filename' then
          components[i] = component_loader.safe_component('smart_filename', 'filename')
        elseif component == 'git' or component == 'branch' then
          components[i] = component_loader.safe_component('minimal_git', 'branch')
        elseif component == 'mode' then
          components[i] = component_loader.safe_component('modern_mode', 'mode')
        end
      end
    end
  end
  
  return sections
end

---@param config NextGenLualineConfig
---@return table<string, any> ai_enhanced_sections
local function get_ai_enhanced_sections(config)
  local sections = get_optimized_sections(config)
  
  -- Add AI-powered components
  if config.ai_features.context_awareness.enabled then
    sections.lualine_a = { 'adaptive_statusline' }
  end
  
  if config.ai_features.predictive_loading.enabled then
    -- Add predictive components based on context
    table.insert(sections.lualine_b, 'smart_diagnostics')
  end
  
  return sections
end

return {
  create_next_gen_config = create_next_gen_config,
  apply_next_gen_configuration = apply_next_gen_configuration,
  validate_next_gen_config = validate_next_gen_config,
  get_performance_metrics = get_performance_metrics,
  get_optimized_sections = get_optimized_sections,
  get_ai_enhanced_sections = get_ai_enhanced_sections,
}
