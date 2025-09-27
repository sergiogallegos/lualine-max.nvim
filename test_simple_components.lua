-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Simple test for lualine-max component loading
print("🧪 Testing lualine-max component loading...")
print("=" .. string.rep("=", 50))

-- Test component availability
local components_to_check = {
  "modern_mode", "minimal_git", "smart_filename", 
  "smart_diagnostics", "adaptive_statusline"
}

print("📋 Component Availability:")
for _, comp in ipairs(components_to_check) do
  local ok, _ = pcall(require, "lualine.components." .. comp)
  print(comp .. ":", ok and "✅ Available" or "❌ Missing")
end

-- Test lualine setup with fallback components
print("\n🚀 Testing lualine setup...")
local ok, lualine = pcall(require, 'lualine')
if ok then
  print("✅ lualine module loaded successfully")
  
  -- Test with standard components first
  local config = {
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = { 'diagnostics', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  }
  
  local setup_ok = pcall(function()
    lualine.setup(config)
  end)
  
  if setup_ok then
    print("✅ lualine setup successful with standard components")
  else
    print("❌ lualine setup failed")
  end
else
  print("❌ Failed to load lualine module")
end

print("\n🎉 Component loading test complete!")
