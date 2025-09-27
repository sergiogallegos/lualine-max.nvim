# 🔧 lualine-max Lazy.nvim Sync Fix

## 🐛 **Common Lazy Sync Issues**

The `lazy sync` failure is usually caused by:

1. **Plugin not properly configured** in lazy.nvim
2. **Dependencies missing** (nvim-web-devicons)
3. **Configuration errors** in the plugin setup
4. **Plugin conflicts** with original lualine.nvim
5. **Repository access issues**

## 🚀 **Immediate Fix**

### **Step 1: Check Current Lazy Status**
```lua
-- Run in Neovim
:Lazy
-- Press 's' to sync
-- Check for errors in the output
```

### **Step 2: Clean and Reinstall**
```bash
# Remove lazy cache
rm -rf ~/.local/share/nvim/lazy/lualine-max
rm -rf ~/.local/share/nvim/lazy/lualine

# Restart Neovim and run
:Lazy sync
```

### **Step 3: Manual Installation**
```lua
-- Run in Neovim
:Lazy install sergiogallegos/lualine-max
```

## 🛠️ **Correct Lazy.nvim Configuration**

### **Method 1: Basic Configuration (Recommended)**

Add this to your `lazy.lua` or plugin configuration file:

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

### **Method 2: Minimal Configuration (If Method 1 Fails)**

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    require('lualine').setup({
      options = { theme = 'auto' },
      sections = {
        lualine_a = { 'mode' },
        lualine_c = { 'filename' },
        lualine_z = { 'location' }
      },
    })
  end
}
```

### **Method 3: With Error Handling**

```lua
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Clear statusline
    vim.o.statusline = ""
    vim.o.laststatus = 2
    
    -- Load with error handling
    local ok, lualine = pcall(require, 'lualine')
    if not ok then
      vim.notify("Failed to load lualine-max", vim.log.levels.ERROR)
      return
    end
    
    -- Setup with error handling
    local setup_ok, err = pcall(function()
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
    end)
    
    if not setup_ok then
      vim.notify("Failed to setup lualine-max: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
}
```

## 🔍 **Troubleshooting Steps**

### **Step 1: Check Plugin Status**
```lua
-- Run in Neovim
:Lazy
-- Look for lualine-max in the list
-- Check if it shows as "loaded" or has errors
```

### **Step 2: Check Dependencies**
```lua
-- Check if nvim-web-devicons is installed
:Lazy install nvim-tree/nvim-web-devicons
```

### **Step 3: Check for Conflicts**
```bash
# Check if original lualine is installed
ls ~/.local/share/nvim/lazy/ | grep lualine

# Remove original lualine if present
rm -rf ~/.local/share/nvim/lazy/lualine.nvim
```

### **Step 4: Manual Installation**
```bash
# Clone manually if lazy fails
cd ~/.local/share/nvim/lazy/
git clone https://github.com/sergiogallegos/lualine-max.nvim.git lualine-max
```

### **Step 5: Check Lazy Logs**
```lua
-- Check lazy logs for errors
:Lazy log
```

## 🚨 **Common Error Solutions**

### **Error: "Plugin not found"**
```lua
-- Solution: Add to lazy.nvim
{
  'sergiogallegos/lualine-max',
  lazy = false, -- Load immediately
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- your config
  end
}
```

### **Error: "Dependencies not found"**
```lua
-- Solution: Install dependencies first
:Lazy install nvim-tree/nvim-web-devicons
:Lazy sync
```

### **Error: "Configuration failed"**
```lua
-- Solution: Use minimal config first
{
  'sergiogallegos/lualine-max',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.o.statusline = ""
    vim.o.laststatus = 2
    require('lualine').setup()
  end
}
```

### **Error: "Repository not accessible"**
```bash
# Solution: Check network and repository access
git clone https://github.com/sergiogallegos/lualine-max.nvim.git
```

## 🎯 **Verification Steps**

After fixing the sync issue:

1. **Check plugin is loaded:**
   ```lua
   :Lazy
   -- Look for lualine-max as "loaded"
   ```

2. **Check statusline is visible:**
   ```lua
   :lua print(vim.o.laststatus) -- Should be 2
   :lua print(vim.o.statusline) -- Should be empty
   ```

3. **Test lualine functionality:**
   ```lua
   :lua require('lualine').refresh()
   ```

## 🆘 **Still Having Issues?**

### **Alternative Installation Methods**

1. **Manual Git Clone:**
   ```bash
   cd ~/.local/share/nvim/lazy/
   git clone https://github.com/sergiogallegos/lualine-max.nvim.git lualine-max
   ```

2. **Direct Configuration:**
   ```lua
   -- In your init.lua
   vim.o.statusline = ""
   vim.o.laststatus = 2
   require('lualine').setup()
   ```

3. **Check Lazy Configuration:**
   ```lua
   -- Make sure lazy.nvim is properly configured
   :checkhealth lazy
   ```

## 📋 **Complete Working Example**

Here's a complete working configuration for your `lazy.lua`:

```lua
return {
  -- lualine-max configuration
  {
    'sergiogallegos/lualine-max',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false, -- Load immediately
    config = function()
      -- Clear any existing statusline
      vim.o.statusline = ""
      vim.o.laststatus = 2
      
      -- Setup lualine with error handling
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
      end
    end
  }
}
```

---

**Created by Sergio Gallegos - September 2025**

*Complete fix for lazy.nvim sync issues with lualine-max!* 🔧✅
