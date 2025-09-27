-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Safe component loader with fallbacks for lualine-max
local M = {}

-- Component fallback mapping
local fallback_map = {
  modern_mode = "mode",
  minimal_git = "branch",
  smart_filename = "filename",
  smart_diagnostics = "diagnostics",
  adaptive_statusline = "mode",
  adaptive_progress = "progress",
}

-- Safe component loader with fallbacks
function M.safe_component(name, custom_fallback)
  local fallback = custom_fallback or fallback_map[name] or name
  
  -- Try to load custom component
  local ok, comp = pcall(require, "lualine.components." .. name)
  if ok and comp then
    return comp
  end
  
  -- Try fallback component
  local fallback_ok, fallback_comp = pcall(require, "lualine.components." .. fallback)
  if fallback_ok and fallback_comp then
    return fallback_comp
  end
  
  -- Return string as last resort
  return fallback
end

-- Check if custom component is available
function M.is_custom_available(name)
  local ok, comp = pcall(require, "lualine.components." .. name)
  return ok and comp ~= nil
end

-- Get component with validation
function M.get_component(name)
  local ok, comp = pcall(require, "lualine.components." .. name)
  if ok and comp then
    return comp
  end
  
  -- Try fallback
  local fallback = fallback_map[name]
  if fallback then
    local fallback_ok, fallback_comp = pcall(require, "lualine.components." .. fallback)
    if fallback_ok and fallback_comp then
      return fallback_comp
    end
  end
  
  -- Return string component
  return fallback or name
end

-- Validate all custom components
function M.validate_components()
  local components_to_check = {
    "modern_mode", "minimal_git", "smart_filename", 
    "smart_diagnostics", "adaptive_statusline", "adaptive_progress"
  }
  
  local results = {}
  local available_count = 0
  
  for _, comp in ipairs(components_to_check) do
    local is_available = M.is_custom_available(comp)
    results[comp] = is_available
    if is_available then
      available_count = available_count + 1
    end
    print(comp .. ":", is_available and "✅ Available" or "❌ Missing")
  end
  
  print("Custom components available: " .. available_count .. "/" .. #components_to_check)
  return results
end

-- Create safe sections with fallbacks
function M.create_safe_sections()
  return {
    lualine_a = { M.safe_component("modern_mode", "mode") },
    lualine_b = { M.safe_component("minimal_git", "branch") },
    lualine_c = { M.safe_component("smart_filename", "filename") },
    lualine_x = { M.safe_component("smart_diagnostics", "diagnostics"), "filetype" },
    lualine_y = { M.safe_component("adaptive_progress", "progress") },
    lualine_z = { "location" },
  }
end

-- Create fallback sections (standard components only)
function M.create_fallback_sections()
  return {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  }
end

-- Smart section creator that tries custom first, falls back to standard
function M.create_smart_sections()
  local sections = {}
  local custom_components = {
    lualine_a = { "modern_mode", "mode" },
    lualine_b = { "minimal_git", "branch" },
    lualine_c = { "smart_filename", "filename" },
    lualine_x = { "smart_diagnostics", "diagnostics" },
    lualine_y = { "adaptive_progress", "progress" },
    lualine_z = { "location" },
  }
  
  for section, components in pairs(custom_components) do
    sections[section] = {}
    for _, comp in ipairs(components) do
      if M.is_custom_available(comp) then
        table.insert(sections[section], comp)
        break -- Use first available component
      else
        -- Try standard component
        local standard_ok, _ = pcall(require, "lualine.components." .. comp)
        if standard_ok then
          table.insert(sections[section], comp)
          break
        end
      end
    end
    
    -- Ensure section has at least one component
    if #sections[section] == 0 then
      sections[section] = { components[#components] } -- Use last fallback
    end
  end
  
  return sections
end

return M
