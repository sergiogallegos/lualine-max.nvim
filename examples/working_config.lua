-- Copyright (c) 2025 Sergio Gallegos - lualine-max
-- MIT license, see LICENSE for more details.

-- Working configuration for lualine-max
-- This configuration ensures the statusline is visible

-- Clear any problematic statusline settings
vim.o.statusline = ""
vim.o.laststatus = 2

-- Load lualine
local ok, lualine = pcall(require, 'lualine')
if not ok then
  vim.notify("Failed to load lualine", vim.log.levels.ERROR)
  return
end

-- Working configuration with standard components
lualine.setup({
  options = {
    theme = 'auto', -- Use auto theme for better visibility
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})

-- Force refresh to ensure visibility
lualine.refresh()

print("✅ lualine-max working configuration applied")
print("Statusline should now be visible!")
