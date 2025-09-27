# 🚀 lualine-max Statusline Solution Guide

## 🐛 **Problem Identified**

Your statusline is not visible because of one or more of these common issues:

1. **Transparency conflict** - Statusline is set to transparent/invisible
2. **Plugin conflicts** - Original lualine.nvim interfering with lualine-max
3. **Configuration issues** - Missing or incorrect setup
4. **laststatus setting** - Statusline is disabled (laststatus=0)

## 🔧 **Immediate Fix (Run in Neovim)**

### **Step 1: Quick Diagnostic**
```lua
-- Run this in Neovim to diagnose the issue
:lua dofile('diagnose_statusline.lua')
```

### **Step 2: Apply Complete Fix**
```lua
-- Run this in Neovim for complete fix
:lua dofile('fix_statusline_complete.lua')
```

### **Step 3: Manual Quick Fix**
```lua
-- If the above doesn't work, try this manual fix
:lua
vim.o.statusline = ""
vim.o.laststatus = 2
local ok, lualine = pcall(require, 'lualine')
if ok then
  lualine.setup({
    options = { theme = 'auto' },
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
vim.cmd("redraw!")
```

## 🛠️ **Permanent Solution**

### **For lazy.nvim (Recommended)**

Add this to your `lazy.lua` or plugin configuration:

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- CRITICAL: Clear any existing statusline settings
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'auto', -- Automatically adapts to your colorscheme
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'alpha', 'dashboard', 'lazy', 'mason', 'TelescopePrompt' },
        },
        always_divide_middle = true,
        globalstatus = false, -- Use per-window statusline
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
    })
  end
}
```

### **For packer.nvim**

Add this to your `plugins.lua`:

```lua
use {
  'sergiogallegos/lualine-max',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
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

### **For vim-plug**

Add this to your `init.vim` or `.vimrc`:

```vim
Plug 'sergiogallegos/lualine-max'
Plug 'nvim-tree/nvim-web-devicons'

lua << EOF
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
EOF
```

## 🎯 **Troubleshooting**

### **Statusline Still Not Visible?**

1. **Check basic settings:**
   ```lua
   :lua print("laststatus:", vim.o.laststatus)
   :lua print("statusline:", vim.o.statusline)
   ```

2. **Force statusline visibility:**
   ```lua
   :lua vim.o.statusline = ""; vim.o.laststatus = 2; vim.cmd("redraw!")
   ```

3. **Check for conflicts:**
   ```lua
   :lua print(vim.inspect(vim.g.loaded_plugins))
   ```

4. **Restart Neovim:**
   ```bash
   :qa!
   nvim
   ```

### **Custom Components Not Working?**

Use standard components instead:

```lua
sections = {
  lualine_a = { 'mode' },      -- Instead of 'modern_mode'
  lualine_b = { 'branch' },    -- Instead of 'minimal_git'
  lualine_c = { 'filename' },  -- Instead of 'smart_filename'
  lualine_x = { 'diagnostics' }, -- Instead of 'smart_diagnostics'
}
```

### **Theme Issues?**

Try different themes:

```lua
options = {
  theme = 'auto',    -- Automatically adapts
  -- theme = 'minimal', -- Clean minimal theme
  -- theme = 'gruvbox', -- Specific theme
}
```

## 📋 **Verification Checklist**

After applying the fix, verify:

- [ ] **Statusline is visible** - You should see mode, filename, etc.
- [ ] **No errors** - Check `:messages` for errors
- [ ] **Components working** - All sections display content
- [ ] **Theme working** - Statusline matches your colorscheme
- [ ] **Git integration** - Branch and diff info shows (if in git repo)
- [ ] **File info** - Filetype, encoding, location display correctly

## 🚀 **Advanced Configurations**

### **AI-Powered Configuration**
```lua
require('lualine').setup({
  options = { theme = 'minimal' },
  sections = {
    lualine_a = { 'modern_mode' },      -- AI-powered mode
    lualine_b = { 'minimal_git' },      -- Smart git status
    lualine_c = { 'smart_filename' },   -- Intelligent filename
    lualine_x = { 'smart_diagnostics', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  ai_features = {
    context_awareness = { enabled = true },
    predictive_loading = { enabled = true },
  },
})
```

### **Performance-Optimized Configuration**
```lua
require('lualine').setup({
  options = {
    theme = 'minimal',
    refresh = {
      statusline = 200,
      refresh_time = 4, -- 240fps
    },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  performance = {
    smart_caching = { enabled = true },
    lazy_loading = { enabled = true },
  },
})
```

## 🆘 **Still Having Issues?**

1. **Remove original lualine.nvim** if installed
2. **Check plugin manager** is loading lualine-max correctly
3. **Use minimal configuration** first, then add features
4. **Check Neovim version** - Ensure you're using Neovim 0.7+
5. **Report issue** with your configuration details

## 📞 **Quick Test Commands**

```lua
-- Test if lualine-max is working
:lua dofile('examples/working_config.lua')

-- Apply minimal configuration
:lua dofile('fix_statusline_complete.lua').minimal_config()

-- Check current status
:lua dofile('diagnose_statusline.lua')
```

---

**Created by Sergio Gallegos - September 2025**

*Complete solution for lualine-max statusline visibility!* 🚀✨
