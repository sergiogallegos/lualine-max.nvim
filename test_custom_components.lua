-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Test lualine-max with custom components
print("🧪 Testing lualine-max with custom components...")
print("=" .. string.rep("=", 50))

local ok, lualine = pcall(require, 'lualine')
if ok then
  print("✅ lualine module loaded successfully")
  
  -- Test with custom components
  local config = {
    options = {
      theme = 'minimal',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'modern_mode' },
      lualine_b = { 'minimal_git' },
      lualine_c = { 'smart_filename' },
      lualine_x = { 'smart_diagnostics', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  }
  
  print("🔧 Testing custom components...")
  local setup_ok = pcall(function()
    lualine.setup(config)
  end)
  
  if setup_ok then
    print("✅ lualine setup successful with custom components")
  else
    print("❌ lualine setup failed with custom components")
    
    -- Try with fallback components
    print("🛡️ Trying fallback components...")
    config.sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = { 'diagnostics', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
    
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

print("\n🎉 Custom component test complete!")
