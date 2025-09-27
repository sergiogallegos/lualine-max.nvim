-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Component registration for lualine-max
local M = {}

-- Register custom components
local components = {
  -- AI-powered components
  'adaptive_statusline',
  'smart_diagnostics',
  'smart_filename',
  
  -- Modern components
  'modern_mode',
  'minimal_git',
  
  -- Standard components (fallbacks)
  'mode',
  'branch',
  'filename',
  'diagnostics',
  'filetype',
  'progress',
  'location',
  'encoding',
  'fileformat',
  'filesize',
}

-- Load and register components
for _, component in ipairs(components) do
  local ok, comp = pcall(require, 'lualine.components.' .. component)
  if ok then
    M[component] = comp
  else
    -- Use fallback for missing components
    if component == 'modern_mode' then
      M[component] = require('lualine.components.mode')
    elseif component == 'minimal_git' then
      M[component] = require('lualine.components.branch')
    elseif component == 'smart_filename' then
      M[component] = require('lualine.components.filename')
    elseif component == 'smart_diagnostics' then
      M[component] = require('lualine.components.diagnostics')
    elseif component == 'adaptive_statusline' then
      M[component] = require('lualine.components.mode')
    end
  end
end

-- Safe component loader with fallbacks
function M.safe_component(name, fallback)
  local ok, comp = pcall(require, 'lualine.components.' .. name)
  if ok and comp then
    return comp
  end
  
  -- Try fallback
  if fallback then
    local fallback_ok, fallback_comp = pcall(require, 'lualine.components.' .. fallback)
    if fallback_ok and fallback_comp then
      return fallback_comp
    end
  end
  
  -- Return a simple string component as last resort
  return fallback or name
end

-- Check component availability
function M.check_components()
  local components_to_check = {
    "modern_mode", "minimal_git", "smart_filename", 
    "smart_diagnostics", "adaptive_statusline"
  }
  
  local results = {}
  for _, comp in ipairs(components_to_check) do
    local ok, _ = pcall(require, "lualine.components." .. comp)
    results[comp] = ok
    print(comp .. ":", ok and "✅ Available" or "❌ Missing")
  end
  
  return results
end

-- Get available custom components
function M.get_custom_components()
  local custom_components = {}
  local components_to_check = {
    "modern_mode", "minimal_git", "smart_filename", 
    "smart_diagnostics", "adaptive_statusline"
  }
  
  for _, comp in ipairs(components_to_check) do
    local ok, comp_module = pcall(require, "lualine.components." .. comp)
    if ok and comp_module then
      custom_components[comp] = comp_module
    end
  end
  
  return custom_components
end

return M
