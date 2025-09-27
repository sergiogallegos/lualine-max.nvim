# 🔧 lualine-max Troubleshooting Guide

## 🚨 **Common Issues and Solutions**

### **Issue 1: Lazy Sync Fails**

**Symptoms:**
- `:Lazy sync` fails with errors
- Plugin doesn't install properly
- Statusline doesn't appear

**Root Cause:** Hardcoded paths in the plugin were looking for `'lualine.nvim'` instead of `'lualine-max.nvim'`

**Solution:**
```lua
-- Run this diagnostic
:lua dofile('CRITICAL_FIX.lua')

-- Or use the working configuration
:lua dofile('WORKING_CONFIG.lua')
```

**Prevention:** Use the working configuration from `WORKING_CONFIG.lua`

---

### **Issue 2: Black Statusline (No Content)**

**Symptoms:**
- Statusline appears as black rectangle
- No text or content visible
- Statusline area is empty

**Root Cause:** Timing issues during plugin initialization

**Solution:**
```lua
-- Quick fix
:lua dofile('BLACK_STATUSLINE_FIX.lua').quick_fix()

-- Or use delayed loading configuration
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    vim.defer_fn(function()
      local ok, lualine = pcall(require, "lualine")
      if ok then
        lualine.setup({
          options = { theme = 'auto' },
          sections = {
            lualine_a = { 'mode' },
            lualine_c = { 'filename' },
            lualine_z = { 'location' }
          },
        })
        lualine.refresh()
      else
        vim.o.statusline = "%f %h%w%m%r %=%y %l,%c %P"
      end
    end, 100)
  end
}
```

---

### **Issue 3: Intermittent Component Loading**

**Symptoms:**
- Components load sometimes, not always
- Inconsistent behavior between sessions
- Statusline appears and disappears randomly

**Root Cause:** Race conditions in component loading

**Solution:**
```lua
-- Use reliable components only
:lua dofile('RELIABLE_COMPONENTS.lua').fix_intermittent_loading()

-- Or use this stable configuration
require('lualine').setup({
  options = {
    theme = 'auto',
    refresh = { statusline = 1000 }, -- Slower refresh for stability
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

---

### **Issue 4: Statusline Not Visible**

**Symptoms:**
- No statusline appears at all
- `laststatus` is set to 0
- Statusline is disabled

**Solution:**
```lua
-- Force statusline visibility
vim.o.statusline = ""
vim.o.laststatus = 2
vim.cmd("redraw!")

-- Check statusline settings
:lua print("laststatus:", vim.o.laststatus)
:lua print("statusline:", vim.o.statusline)
```

---

### **Issue 5: Theme Conflicts**

**Symptoms:**
- Statusline doesn't match colorscheme
- Colors are wrong or missing
- Theme not applying correctly

**Solution:**
```lua
-- Use auto theme
require('lualine').setup({
  options = {
    theme = 'auto', -- Automatically adapts to colorscheme
  },
})

-- Or try specific theme
require('lualine').setup({
  options = {
    theme = 'minimal', -- Clean minimal theme
  },
})
```

---

### **Issue 6: Component Errors**

**Symptoms:**
- Specific components don't work
- Error messages in `:messages`
- Components show as empty

**Solution:**
```lua
-- Test individual components
:lua print(require('lualine.components.mode'))
:lua print(require('lualine.components.branch'))
:lua print(require('lualine.components.filename'))

-- Use fallback components
require('lualine').setup({
  sections = {
    lualine_a = { 'mode' },      -- Instead of 'modern_mode'
    lualine_b = { 'branch' },    -- Instead of 'minimal_git'
    lualine_c = { 'filename' },  -- Instead of 'smart_filename'
  },
})
```

---

## 🔍 **Diagnostic Commands**

### **Check Plugin Status**
```lua
-- Check if lualine is loaded
:lua print(pcall(require, 'lualine'))

-- Check plugin status
:Lazy
```

### **Check Statusline Settings**
```lua
-- Check basic settings
:lua print("laststatus:", vim.o.laststatus)
:lua print("statusline:", vim.o.statusline)

-- Check window info
:lua print(vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].statusline)
```

### **Check Component Availability**
```lua
-- Test components
:lua print(require('lualine.components.mode'))
:lua print(require('lualine.components.branch'))
:lua print(require('lualine.components.filename'))
```

### **Check for Conflicts**
```lua
-- Check loaded plugins
:lua print(vim.inspect(vim.g.loaded_plugins))

-- Check for other statusline plugins
:lua print(vim.o.statusline)
```

---

## 🛠️ **Advanced Troubleshooting**

### **Complete Reset**
```lua
-- Clear everything and start fresh
vim.o.statusline = ""
vim.o.laststatus = 2
package.loaded['lualine'] = nil
package.loaded['lualine.components'] = nil
vim.cmd("redraw!")
```

### **Force Refresh**
```lua
-- Force lualine refresh
:lua require('lualine').refresh()
:redraw!
```

### **Check Lazy Logs**
```lua
-- Check lazy logs for errors
:Lazy log
```

### **Test Minimal Configuration**
```lua
-- Ultra-minimal test
require('lualine').setup({
  options = { theme = 'auto' },
  sections = {
    lualine_a = { 'mode' },
    lualine_c = { 'filename' },
    lualine_z = { 'location' }
  },
})
```

---

## 📋 **Prevention Tips**

### **1. Use Reliable Configuration**
- Stick to standard components
- Use `theme = 'auto'`
- Avoid complex custom components

### **2. Proper Loading Order**
- Load lualine after other plugins
- Use `lazy = false` for immediate loading
- Avoid conflicting events

### **3. Error Handling**
- Always use `pcall()` for component loading
- Provide fallbacks for failed components
- Check for errors in `:messages`

### **4. Testing**
- Test configuration changes incrementally
- Use minimal configuration first
- Verify each component works

---

## 🆘 **Still Having Issues?**

### **1. Check System Requirements**
- Neovim >= 0.7
- Latest lazy.nvim
- nvim-web-devicons installed

### **2. Clean Installation**
```bash
# Remove plugin cache
rm -rf ~/.local/share/nvim/lazy/lualine-max
rm -rf ~/.local/share/nvim/lazy/lualine

# Restart Neovim
```

### **3. Report Issues**
- Include error messages from `:messages`
- Provide your configuration
- Include Neovim version
- Describe steps to reproduce

### **4. Get Help**
- Check the [GitHub Issues](https://github.com/sergiogallegos/lualine-max.nvim/issues)
- Use the diagnostic scripts provided
- Try the working configuration examples

---

**Created by Sergio Gallegos - September 2025**

*Complete troubleshooting guide for lualine-max!* 🔧✅
