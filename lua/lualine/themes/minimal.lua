-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

---@class MinimalTheme
---@field normal table
---@field insert table
---@field visual table
---@field replace table
---@field command table
---@field terminal table
---@field inactive table

---@return MinimalTheme
local function create_minimal_theme()
  -- Extract colors from current colorscheme
  local bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'bg#')
  local fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'fg#')
  local comment_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Comment')), 'fg#')
  
  -- Fallback colors
  bg = bg ~= '' and bg or '#1e1e1e'
  fg = fg ~= '' and fg or '#ffffff'
  comment_fg = comment_fg ~= '' and comment_fg or '#666666'
  
  -- Create subtle variations
  local function lighten(color, amount)
    if not color or color == '' then return color end
    local r, g, b = color:match('#(%x%x)(%x%x)(%x%x)')
    if not r then return color end
    
    r = math.min(255, tonumber(r, 16) + amount)
    g = math.min(255, tonumber(g, 16) + amount)
    b = math.min(255, tonumber(b, 16) + amount)
    
    return string.format('#%02x%02x%02x', r, g, b)
  end
  
  local function darken(color, amount)
    if not color or color == '' then return color end
    local r, g, b = color:match('#(%x%x)(%x%x)(%x%x)')
    if not r then return color end
    
    r = math.max(0, tonumber(r, 16) - amount)
    g = math.max(0, tonumber(g, 16) - amount)
    b = math.max(0, tonumber(b, 16) - amount)
    
    return string.format('#%02x%02x%02x', r, g, b)
  end
  
  local subtle_bg = lighten(bg, 20)
  local subtle_fg = darken(fg, 20)
  
  return {
    normal = {
      a = { bg = subtle_bg, fg = fg, gui = 'bold' },
      b = { bg = bg, fg = comment_fg },
      c = { bg = bg, fg = fg },
    },
    insert = {
      a = { bg = '#4CAF50', fg = bg, gui = 'bold' },
      b = { bg = bg, fg = '#4CAF50' },
      c = { bg = bg, fg = fg },
    },
    visual = {
      a = { bg = '#FF9800', fg = bg, gui = 'bold' },
      b = { bg = bg, fg = '#FF9800' },
      c = { bg = bg, fg = fg },
    },
    replace = {
      a = { bg = '#F44336', fg = bg, gui = 'bold' },
      b = { bg = bg, fg = '#F44336' },
      c = { bg = bg, fg = fg },
    },
    command = {
      a = { bg = '#9C27B0', fg = bg, gui = 'bold' },
      b = { bg = bg, fg = '#9C27B0' },
      c = { bg = bg, fg = fg },
    },
    terminal = {
      a = { bg = '#607D8B', fg = bg, gui = 'bold' },
      b = { bg = bg, fg = '#607D8B' },
      c = { bg = bg, fg = fg },
    },
    inactive = {
      a = { bg = subtle_bg, fg = comment_fg },
      b = { bg = bg, fg = comment_fg },
      c = { bg = bg, fg = comment_fg },
    },
  }
end

return create_minimal_theme()
