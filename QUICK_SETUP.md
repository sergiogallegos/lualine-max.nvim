# lualine-max Quick Setup Guide

## 🚀 **Copy & Paste Configurations**

### **For lazy.nvim (Recommended)**

Add this to your `lazy.lua` or plugin configuration:

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Ensure statusline is visible
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'auto', -- Automatically adapts to your colorscheme
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype', 'encoding' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
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
  end
}
```

### **For vim-plug**

Add this to your `init.vim` or `.vimrc`:

```vim
Plug 'sergiogallegos/lualine-max'
Plug 'nvim-tree/nvim-web-devicons'

lua << EOF
-- Ensure statusline is visible
vim.o.statusline = ""
vim.o.laststatus = 2

require('lualine').setup({
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
EOF
```

## 🤖 **AI-Powered Configuration**

For advanced users who want AI features:

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'minimal',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'modern_mode' },      -- AI-powered mode
        lualine_b = { 'minimal_git' },      -- Smart git status
        lualine_c = { 'smart_filename' },   -- Intelligent filename
        lualine_x = { 'smart_diagnostics', 'filetype' }, -- Smart diagnostics
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      ai_features = {
        context_awareness = { enabled = true },
        predictive_loading = { enabled = true },
      },
    })
  end
}
```

## ⚡ **Ultra Performance Configuration**

For maximum performance:

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = {
        theme = 'minimal',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
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
  end
}
```

## 🔧 **Troubleshooting**

### **Statusline Not Visible?**

1. **Check if statusline is enabled:**
   ```lua
   :lua print(vim.o.laststatus)
   ```

2. **Force statusline visibility:**
   ```lua
   :lua vim.o.statusline = ""; vim.o.laststatus = 2; vim.cmd("redraw!")
   ```

3. **Check for conflicts:**
   ```lua
   :lua print(vim.o.statusline)
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

### **Still Having Issues?**

1. **Remove original lualine.nvim** if installed
2. **Restart Neovim** after configuration changes
3. **Check plugin manager** is loading lualine-max correctly
4. **Use basic configuration** first, then add features

## 📋 **Verification**

After setup, verify:

1. **Statusline is visible** - You should see mode, filename, etc.
2. **No errors** - Check `:messages` for errors
3. **Components working** - All sections should display content
4. **Theme working** - Statusline should match your colorscheme

## 🎯 **Quick Test**

Test your configuration:

```lua
-- In Neovim, run:
:lua dofile('examples/working_config.lua')
```

This will apply a working configuration and show if lualine-max is working correctly.

---

**Created by Sergio Gallegos - September 2025**

*Quick setup guide for lualine-max!* 🚀✨
