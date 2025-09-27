# lualine-max Statusline Fix

## 🐛 **Issue Identified**

The statusline is not visible because:
1. **Theme conflict** - Statusline is set to `%#lualine_transparent#` (invisible)
2. **Plugin conflict** - Original lualine.nvim is interfering with lualine-max
3. **Component loading error** - Custom components not properly initialized

## 🔧 **Quick Fix**

### **Method 1: Manual Fix (Immediate)**

```lua
-- Run this in Neovim
:lua
-- Clear problematic statusline
vim.o.statusline = ""
vim.o.laststatus = 2

-- Load lualine-max
local ok, lualine = pcall(require, 'lualine')
if ok then
  lualine.setup({
    options = {
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  })
  lualine.refresh()
end
```

### **Method 2: Plugin Manager Fix**

If using lazy.nvim, update your configuration:

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Clear any existing statusline
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
  end
}
```

### **Method 3: Remove Original lualine**

If you have the original lualine.nvim installed, remove it:

```bash
# Remove original lualine
rm -rf ~/.local/share/nvim/lazy/lualine.nvim
rm -rf ~/.local/share/nvim/lazy/lualine

# Restart Neovim
```

## 🚀 **Permanent Fix**

### **1. Update Your Neovim Config**

```lua
-- In your init.lua or config file
vim.o.laststatus = 2
vim.o.statusline = ""

-- Load lualine-max
require('lualine').setup({
  options = {
    theme = 'auto', -- or 'minimal'
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})
```

### **2. Check for Conflicts**

```lua
-- Check if other plugins are setting statusline
:lua print(vim.o.statusline)
:lua print(vim.o.laststatus)

-- Check loaded plugins
:lua print(vim.inspect(vim.g.loaded_plugins))
```

### **3. Force Refresh**

```lua
-- Force lualine to refresh
:lua require('lualine').refresh()
:redraw!
```

## 🎯 **Troubleshooting**

### **Statusline Still Not Visible?**

1. **Check colorscheme**:
   ```lua
   :colorscheme default
   ```

2. **Check laststatus**:
   ```lua
   :set laststatus=2
   ```

3. **Check for other statusline plugins**:
   ```lua
   :lua print(vim.o.statusline)
   ```

4. **Restart Neovim**:
   ```bash
   :qa!
   nvim
   ```

### **Custom Components Not Working?**

Use fallback components:

```lua
require('lualine').setup({
  sections = {
    lualine_a = { 'mode' },      -- Instead of 'modern_mode'
    lualine_b = { 'branch' },    -- Instead of 'minimal_git'
    lualine_c = { 'filename' },  -- Instead of 'smart_filename'
    lualine_x = { 'diagnostics' }, -- Instead of 'smart_diagnostics'
  },
})
```

## 📋 **Verification**

After applying the fix, verify:

1. **Statusline is visible** - You should see mode, filename, etc.
2. **No errors** - Check `:messages` for errors
3. **Components working** - All sections should display content

## 🆘 **Still Having Issues?**

1. **Check plugin conflicts** - Disable other statusline plugins
2. **Update Neovim** - Ensure you're using Neovim 0.7+
3. **Clean install** - Remove all lualine plugins and reinstall
4. **Report issue** - Create an issue with your configuration

---

**Created by Sergio Gallegos - September 2025**

*Quick fix for lualine-max statusline visibility!* 🔧✅
