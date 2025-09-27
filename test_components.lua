-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Test script to validate lualine-max component loading
print("🧪 Testing lualine-max component loading...")
print("=" .. string.rep("=", 50))

-- Test component loader
local component_loader = require('lualine.utils.component_loader')

print("📋 Component Validation:")
component_loader.validate_components()

print("\n🔧 Safe Component Loading:")
local safe_sections = component_loader.create_safe_sections()
for section, components in pairs(safe_sections) do
  print(section .. ": " .. table.concat(components, ", "))
end

print("\n🧠 Smart Component Loading:")
local smart_sections = component_loader.create_smart_sections()
for section, components in pairs(smart_sections) do
  print(section .. ": " .. table.concat(components, ", "))
end

print("\n🛡️ Fallback Component Loading:")
local fallback_sections = component_loader.create_fallback_sections()
for section, components in pairs(fallback_sections) do
  print(section .. ": " .. table.concat(components, ", "))
end

-- Test lualine setup with safe components
print("\n🚀 Testing lualine setup with safe components...")
local ok, lualine = pcall(require, 'lualine')
if ok then
  local config = {
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = component_loader.create_safe_sections(),
  }
  
  local setup_ok = pcall(function()
    lualine.setup(config)
  end)
  
  if setup_ok then
    print("✅ lualine setup successful with safe components")
  else
    print("❌ lualine setup failed, trying fallback...")
    
    -- Try with fallback components
    config.sections = component_loader.create_fallback_sections()
    local fallback_ok = pcall(function()
      lualine.setup(config)
    end)
    
    if fallback_ok then
      print("✅ lualine setup successful with fallback components")
    else
      print("❌ lualine setup failed even with fallbacks")
    end
  end
else
  print("❌ Failed to load lualine module")
end

print("\n🎉 Component loading test complete!")
