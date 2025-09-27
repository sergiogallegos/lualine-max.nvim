-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Diagnostic script for lualine-max statusline issues
-- Run this in Neovim to diagnose the problem

print("🔍 lualine-max Statusline Diagnostic")
print("=====================================")

-- Check basic statusline settings
print("\n📊 Basic Settings:")
print("  laststatus:", vim.o.laststatus)
print("  statusline:", vim.o.statusline)
print("  ruler:", vim.o.ruler)

-- Check if lualine is loaded
print("\n🔌 Plugin Status:")
local lualine_ok, lualine = pcall(require, 'lualine')
print("  lualine loaded:", lualine_ok)

if lualine_ok then
  print("  lualine version:", lualine.get_config and "available" or "unknown")
end

-- Check for transparency issues
print("\n🎨 Transparency Check:")
if vim.o.statusline:find("transparent") then
  print("  ⚠️  Statusline appears to be transparent!")
  print("  🔧 This is likely the cause of invisibility")
else
  print("  ✅ No transparency issues detected")
end

-- Check for other statusline plugins
print("\n🔍 Plugin Conflicts:")
local loaded_plugins = vim.g.loaded_plugins or {}
local statusline_plugins = {}
for plugin, _ in pairs(loaded_plugins) do
  if plugin:find("statusline") or plugin:find("lualine") then
    table.insert(statusline_plugins, plugin)
  end
end

if #statusline_plugins > 0 then
  print("  ⚠️  Potential conflicts found:")
  for _, plugin in ipairs(statusline_plugins) do
    print("    -", plugin)
  end
else
  print("  ✅ No obvious plugin conflicts")
end

-- Check colorscheme
print("\n🎨 Colorscheme:")
print("  current:", vim.g.colors_name or "default")

-- Check window status
print("\n🪟 Window Status:")
print("  current window:", vim.api.nvim_get_current_win())
print("  window count:", #vim.api.nvim_list_wins())

-- Recommendations
print("\n💡 Recommendations:")
if vim.o.laststatus == 0 then
  print("  🔧 Set laststatus=2 to enable statusline")
end

if vim.o.statusline:find("transparent") then
  print("  🔧 Clear statusline to remove transparency")
end

if not lualine_ok then
  print("  🔧 Install or properly configure lualine-max")
end

print("\n🚀 Quick Fix Commands:")
print("  :lua vim.o.statusline = ''; vim.o.laststatus = 2; vim.cmd('redraw!')")
print("  :lua dofile('examples/working_config.lua')")

print("\n✅ Diagnostic complete!")
