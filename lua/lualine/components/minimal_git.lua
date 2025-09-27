-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local M = require('lualine.component'):extend()

local performance = require('lualine.utils.performance')

---@class MinimalGitOptions
---@field symbols table<string, string>
---@field show_branch boolean
---@field show_status boolean
---@field max_length number
---@field icons_enabled boolean

local default_options = {
  symbols = {
    branch = '',
    added = '+',
    modified = '~',
    removed = '-',
    untracked = '?',
    renamed = '→',
    unmerged = '!',
  },
  show_branch = true,
  show_status = true,
  max_length = 0,
  icons_enabled = true,
}

---@param self MinimalGitComponent
---@param options MinimalGitOptions
function M.init(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  
  -- Initialize performance optimizer
  self.perf = performance.PerformanceOptimizer.new(500) -- 500ms cache for git operations
end

---@param self MinimalGitComponent
---@return string
function M.update_status(self)
  return self.perf:memoize('git_status', function()
    local result = {}
    
    -- Get git branch
    if self.options.show_branch then
      local branch = vim.fn.FugitiveHead()
      if branch and branch ~= '' then
        if self.options.icons_enabled then
          table.insert(result, ' ' .. branch)
        else
          table.insert(result, branch)
        end
      end
    end
    
    -- Get git status
    if self.options.show_status then
      local status = self:get_git_status()
      if status and #status > 0 then
        table.insert(result, status)
      end
    end
    
    local result_str = table.concat(result, ' ')
    
    -- Truncate if needed
    if self.options.max_length > 0 and #result_str > self.options.max_length then
      result_str = result_str:sub(1, self.options.max_length - 3) .. '...'
    end
    
    return result_str
  end)
end

---@param self MinimalGitComponent
---@return string|nil
function M.get_git_status(self)
  -- Check if we're in a git repository
  local git_dir = vim.fn.finddir('.git', '.;')
  if git_dir == '' then
    return nil
  end
  
  -- Get git status using vim-fugitive if available
  if vim.fn.exists('*FugitiveGitDir') == 1 then
    local git_status = vim.fn.FugitiveGitDir()
    if git_status and git_status ~= '' then
      -- Parse git status output
      local status_output = vim.fn.system('git status --porcelain')
      if vim.v.shell_error == 0 then
        local status = self:parse_git_status(status_output)
        return status
      end
    end
  end
  
  return nil
end

---@param self MinimalGitComponent
---@param status_output string
---@return string
function M.parse_git_status(self, status_output)
  local counts = {
    added = 0,
    modified = 0,
    removed = 0,
    untracked = 0,
    renamed = 0,
    unmerged = 0,
  }
  
  for line in status_output:gmatch('[^\r\n]+') do
    local status = line:sub(1, 2)
    local staged = status:sub(1, 1)
    local unstaged = status:sub(2, 2)
    
    if staged == 'A' or unstaged == 'A' then
      counts.added = counts.added + 1
    elseif staged == 'M' or unstaged == 'M' then
      counts.modified = counts.modified + 1
    elseif staged == 'D' or unstaged == 'D' then
      counts.removed = counts.removed + 1
    elseif staged == 'R' or unstaged == 'R' then
      counts.renamed = counts.renamed + 1
    elseif staged == 'U' or unstaged == 'U' or staged == 'A' and unstaged == 'A' then
      counts.unmerged = counts.unmerged + 1
    elseif status == '??' then
      counts.untracked = counts.untracked + 1
    end
  end
  
  local status_parts = {}
  for status, count in pairs(counts) do
    if count > 0 then
      table.insert(status_parts, self.options.symbols[status] .. count)
    end
  end
  
  return table.concat(status_parts, '')
end

return M
