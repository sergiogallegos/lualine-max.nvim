-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Safe component loading example for lualine-max
-- This example demonstrates how to use lualine-max with fallback components

local M = {}

-- Safe component loader with fallbacks
local function safe_component(name, fallback)
  local ok, comp = pcall(require, "lualine.components." .. name)
  if ok and comp then
    return comp
  end
  
  -- Try fallback
  if fallback then
    local fallback_ok, fallback_comp = pcall(require, "lualine.components." .. fallback)
    if fallback_ok and fallback_comp then
      return fallback_comp
    end
  end
  
  -- Return string as last resort
  return fallback or name
end

-- Component fallback mapping
local fallback_map = {
  modern_mode = "mode",
  minimal_git = "branch",
}

-- Create safe sections with fallbacks
local function create_safe_sections()
  return {
    lualine_a = { safe_component("modern_mode", "mode") },
    lualine_b = { safe_component("minimal_git", "branch") },
    lualine_c = { safe_component("filename", "filename") },
    lualine_x = { safe_component("diagnostics", "diagnostics"), "filetype" },
    lualine_y = { safe_component("progress", "progress") },
    lualine_z = { "location" },
  }
end

-- Create fallback sections (standard components only)
local function create_fallback_sections()
  return {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  }
end

-- Modern section creator that tries custom first, falls back to standard
local function create_modern_sections()
  local sections = {}
  local custom_components = {
    lualine_a = { "modern_mode", "mode" },
    lualine_b = { "minimal_git", "branch" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  }
  
  for section, components in pairs(custom_components) do
    sections[section] = {}
    for _, comp in ipairs(components) do
      local ok, _ = pcall(require, "lualine.components." .. comp)
      if ok then
        table.insert(sections[section], comp)
        break -- Use first available component
      end
    end
    
    -- Ensure section has at least one component
    if #sections[section] == 0 then
      sections[section] = { components[#components] } -- Use last fallback
    end
  end
  
  return sections
end

-- Validate component availability
local function validate_components()
  local components_to_check = {
    "modern_mode", "minimal_git"
  }
  
  local results = {}
  local available_count = 0
  
  for _, comp in ipairs(components_to_check) do
    local ok, _ = pcall(require, "lualine.components." .. comp)
    results[comp] = ok
    if ok then
      available_count = available_count + 1
    end
    print(comp .. ":", ok and "✅ Available" or "❌ Missing")
  end
  
  print("Custom components available: " .. available_count .. "/" .. #components_to_check)
  return results
end

-- Setup lualine with safe component loading
function M.setup()
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    vim.notify("Failed to load lualine", vim.log.levels.ERROR)
    return
  end
  
  -- Try to use custom components first
  local config = {
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = create_modern_sections(),
  }
  
  -- Try setup with custom components
  local setup_ok = pcall(function()
    lualine.setup(config)
  end)
  
  if not setup_ok then
    print("Custom components failed, using fallback...")
    config.sections = create_fallback_sections()
    
    local fallback_ok = pcall(function()
      lualine.setup(config)
    end)
    
    if not fallback_ok then
      vim.notify("Failed to setup lualine even with fallbacks", vim.log.levels.ERROR)
    end
  end
end

-- Test component loading
function M.test_components()
  print("🧪 Testing lualine-max component loading...")
  print("=" .. string.rep("=", 50))
  
  print("📋 Component Validation:")
  validate_components()
  
  print("\n🔧 Safe Component Loading:")
  local safe_sections = create_safe_sections()
  for section, components in pairs(safe_sections) do
    print(section .. ": " .. table.concat(components, ", "))
  end
  
  print("\n🔧 Modern Component Loading:")
  local modern_sections = create_modern_sections()
  for section, components in pairs(modern_sections) do
    print(section .. ": " .. table.concat(components, ", "))
  end
  
  print("\n🛡️ Fallback Component Loading:")
  local fallback_sections = create_fallback_sections()
  for section, components in pairs(fallback_sections) do
    print(section .. ": " .. table.concat(components, ", "))
  end
end

return M
