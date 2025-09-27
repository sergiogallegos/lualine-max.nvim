-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

-- Ultra Performance AI Configuration
-- Maximum performance with AI features

return {
  options = {
    theme = 'minimal',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt', 'qf', 'help', 'man' },
      winbar = {},
    },
    ignore_focus = { 'qf', 'help', 'man', 'lazy', 'mason', 'alpha', 'dashboard' },
    always_divide_middle = false,
    globalstatus = true,
    refresh = {
      statusline = 100, -- Minimal refresh for maximum performance
      refresh_time = 8, -- 120fps for smooth but efficient updates
      events = {
        'WinEnter',
        'BufEnter',
        'ModeChanged',
      },
    },
  },
  
  -- Ultra-Performance Sections
  sections = {
    lualine_a = { 'modern_mode' }, -- Minimal mode indicator
    lualine_b = { 'smart_diagnostics' }, -- Smart diagnostics only
    lualine_c = { 'smart_filename' }, -- Smart filename
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
  
  -- Performance-Focused AI Features
  ai_features = {
    context_awareness = {
      enabled = true,
      learning_rate = 0.05, -- Slower learning for stability
      adaptation_threshold = 0.8, -- Less sensitive adaptation
      cache_duration = 10000, -- 10 second cache for performance
    },
    predictive_loading = {
      enabled = true,
      preload_threshold = 0.9, -- Only preload high-confidence components
      learning_enabled = true,
      usage_tracking = true,
    },
    smart_components = {
      enabled = true,
      auto_optimize = true,
      performance_tracking = true,
      adaptive_refresh = false, -- Disable for maximum performance
    },
  },
  
  -- Ultra Performance Configuration
  performance = {
    smart_caching = {
      enabled = true,
      cache_ttl = 500, -- 500ms cache TTL for stability
      max_cache_size = 500, -- Smaller cache for memory efficiency
      cache_eviction = 'lru',
    },
    predictive_refresh = {
      enabled = true,
      prediction_accuracy_threshold = 0.95, -- Very high accuracy requirement
      adaptive_timing = false, -- Disable for consistent performance
      context_switching_detection = true,
    },
    memory_optimization = {
      enabled = true,
      component_pooling = true,
      string_interning = true,
      table_reuse = true,
      aggressive_cleanup = true,
    },
  },
  
  -- Ultra Performance Settings
  ultra_performance = {
    minimal_components = true,
    disable_animations = true,
    static_refresh_rate = true,
    memory_pressure_handling = true,
    cpu_throttling = true,
  },
  
  -- Context-Specific Performance
  context_performance = {
    web_development = {
      enabled = true,
      minimal_git = true, -- Only essential git info
      no_bundle_tracking = true, -- Disable heavy operations
    },
    mobile_development = {
      enabled = true,
      minimal_build_status = true,
      no_device_tracking = true,
    },
    data_science = {
      enabled = true,
      minimal_jupyter_status = true,
      no_data_tracking = true,
    },
    devops = {
      enabled = true,
      minimal_docker_status = true,
      no_k8s_tracking = true,
    },
  },
}
