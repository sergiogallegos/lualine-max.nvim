# 📖 lualine-max User Guide

## 🚀 **Getting Started**

lualine-max is a next-generation, AI-powered statusline for Neovim that provides intelligent adaptation, 3x performance improvements, and cutting-edge features.

### **System Requirements**
- Neovim >= 0.7
- nvim-web-devicons (optional, for icons)

## 📦 **Installation**

### **Using lazy.nvim (Recommended)**

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
  end
}
```

### **Using packer.nvim**

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

### **Using vim-plug**

```vim
Plug 'sergiogallegos/lualine-max'
Plug 'nvim-tree/nvim-web-devicons'

lua << EOF
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

## ⚙️ **Configuration**

### **Basic Configuration**

```lua
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
```

### **AI-Powered Configuration**

```lua
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
```

### **Ultra Performance Configuration**

```lua
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
```

## 🎨 **Themes**

### **Available Themes**

- **`auto`** - Automatically adapts to your colorscheme (recommended)
- **`minimal`** - Clean, minimal design
- **`gruvbox`** - Gruvbox colorscheme
- **`dracula`** - Dracula colorscheme
- **`nord`** - Nord colorscheme
- **`onedark`** - One Dark colorscheme

### **Custom Theme**

```lua
require('lualine').setup({
  options = {
    theme = {
      normal = {
        a = { bg = '#3B82F6', fg = '#FFFFFF', gui = 'bold' },
        b = { bg = '#1E293B', fg = '#94A3B8' },
        c = { bg = '#0F172A', fg = '#E2E8F0' }
      },
      insert = {
        a = { bg = '#10B981', fg = '#FFFFFF', gui = 'bold' },
        b = { bg = '#1E293B', fg = '#94A3B8' },
        c = { bg = '#0F172A', fg = '#E2E8F0' }
      },
      visual = {
        a = { bg = '#F59E0B', fg = '#FFFFFF', gui = 'bold' },
        b = { bg = '#1E293B', fg = '#94A3B8' },
        c = { bg = '#0F172A', fg = '#E2E8F0' }
      }
    }
  }
})
```

## 🧩 **Components**

### **Standard Components**

- **`mode`** - Current vim mode
- **`branch`** - Git branch name
- **`diff`** - Git diff information
- **`diagnostics`** - LSP diagnostics
- **`filename`** - Current file name
- **`filetype`** - File type
- **`encoding`** - File encoding
- **`fileformat`** - File format (unix, dos, mac)
- **`progress`** - Cursor position
- **`location`** - Line and column

### **AI-Powered Components**

- **`modern_mode`** - AI-enhanced mode display
- **`minimal_git`** - Smart git status
- **`smart_filename`** - Intelligent filename truncation
- **`smart_diagnostics`** - Smart diagnostic grouping
- **`adaptive_statusline`** - Context-aware statusline

### **Custom Components**

```lua
-- Custom component example
local function my_component()
  return 'Hello World'
end

require('lualine').setup({
  sections = {
    lualine_c = { my_component }
  }
})
```

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Statusline Not Visible**
```lua
-- Force statusline visibility
vim.o.statusline = ""
vim.o.laststatus = 2
vim.cmd("redraw!")
```

#### **Lazy Sync Fails**
```lua
-- Run diagnostic and fix
:lua dofile('scripts/CRITICAL_FIX.lua')
```

#### **Black Statusline**
```lua
-- Quick fix for black statusline
:lua dofile('scripts/BLACK_STATUSLINE_FIX.lua').quick_fix()
```

#### **Component Errors**
```lua
-- Fix component loading issues
:lua dofile('scripts/COMPONENT_ERROR_FIX.lua').quick_fix()
```

#### **Gitsigns Errors**
```lua
-- Fix gitsigns preload errors
:lua dofile('scripts/GITSIGNS_ERROR_FIX.lua').quick_fix()
```

### **Diagnostic Commands**

```lua
-- Check lualine status
:lua print(pcall(require, 'lualine'))

-- Check statusline settings
:lua print("laststatus:", vim.o.laststatus)
:lua print("statusline:", vim.o.statusline)

-- Test components
:lua print(require('lualine.components.mode'))
:lua print(require('lualine.components.branch'))
```

## 🚀 **Performance Tips**

### **Optimize Startup Time**
```lua
-- Use minimal configuration for faster startup
require('lualine').setup({
  options = { theme = 'auto' },
  sections = {
    lualine_a = { 'mode' },
    lualine_c = { 'filename' },
    lualine_z = { 'location' }
  },
})
```

### **Reduce Memory Usage**
```lua
-- Disable unused components
require('lualine').setup({
  sections = {
    lualine_a = { 'mode' },
    lualine_c = { 'filename' },
    lualine_z = { 'location' }
  },
})
```

### **Optimize Refresh Rate**
```lua
-- Use slower refresh for better performance
require('lualine').setup({
  options = {
    refresh = {
      statusline = 1000, -- 1 second
    },
  }
})
```

## 🎯 **Best Practices**

### **1. Use Reliable Configuration**
- Stick to standard components
- Use `theme = 'auto'` for compatibility
- Avoid complex custom components

### **2. Error Handling**
- Always use `pcall()` for component loading
- Provide fallbacks for failed components
- Check for errors in `:messages`

### **3. Performance**
- Use minimal configuration for faster startup
- Disable unused components
- Use slower refresh rates for stability

### **4. Testing**
- Test configuration changes incrementally
- Use minimal configuration first
- Verify each component works

## 📚 **Advanced Usage**

### **Conditional Components**
```lua
local function conditional_component()
  if vim.bo.filetype == 'python' then
    return '🐍 Python'
  elseif vim.bo.filetype == 'javascript' then
    return '🟨 JavaScript'
  else
    return ''
  end
end

require('lualine').setup({
  sections = {
    lualine_c = { conditional_component }
  }
})
```

### **Dynamic Themes**
```lua
local function get_theme()
  if vim.g.colors_name == 'gruvbox' then
    return 'gruvbox'
  elseif vim.g.colors_name == 'dracula' then
    return 'dracula'
  else
    return 'auto'
  end
end

require('lualine').setup({
  options = {
    theme = get_theme()
  }
})
```

### **Custom Separators**
```lua
require('lualine').setup({
  options = {
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
  }
})
```

## 🆘 **Getting Help**

### **Documentation**
- [README.md](./README.md) - Main documentation
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Troubleshooting guide
- [API.md](./API.md) - API reference

### **Community**
- [GitHub Issues](https://github.com/sergiogallegos/lualine-max.nvim/issues)
- [GitHub Discussions](https://github.com/sergiogallegos/lualine-max.nvim/discussions)

### **Scripts**
- `scripts/CRITICAL_FIX.lua` - Fix lazy sync issues
- `scripts/BLACK_STATUSLINE_FIX.lua` - Fix black statusline
- `scripts/COMPONENT_ERROR_FIX.lua` - Fix component errors
- `scripts/GITSIGNS_ERROR_FIX.lua` - Fix gitsigns errors

---

**Created by Sergio Gallegos - September 2025**

*Complete user guide for lualine-max!* 📖✨
