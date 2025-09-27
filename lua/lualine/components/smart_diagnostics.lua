-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

local M = require('lualine.component'):extend()

local performance = require('lualine.utils.performance')

---@class SmartDiagnosticsOptions
---@field sources table<string>
---@field sections table<string>
---@field symbols table<string, string>
---@field colored boolean
---@field update_in_insert boolean
---@field always_visible boolean
---@field max_length number
---@field smart_grouping boolean
---@field severity_priority table<string, number>

local default_options = {
  sources = { 'nvim_diagnostic' },
  sections = { 'error', 'warn', 'info', 'hint' },
  symbols = {
    error = 'E',
    warn = 'W',
    info = 'I',
    hint = 'H',
  },
  colored = true,
  update_in_insert = false,
  always_visible = false,
  max_length = 0,
  smart_grouping = true,
  severity_priority = {
    error = 1,
    warn = 2,
    info = 3,
    hint = 4,
  },
}

---@param self SmartDiagnosticsComponent
---@param options SmartDiagnosticsOptions
function M.init(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  
  -- Initialize performance optimizer
  self.perf = performance.PerformanceOptimizer.new(200) -- 200ms cache for diagnostics
  
  -- Smart grouping cache
  self.grouping_cache = {}
  self.last_diagnostics = {}
end

---@param self SmartDiagnosticsComponent
---@return string diagnostics_status
function M.update_status(self)
  return self.perf:memoize('smart_diagnostics', function()
    local diagnostics = self:get_diagnostics()
    
    if not diagnostics or self:is_empty(diagnostics) then
      return self.options.always_visible and '0' or ''
    end
    
    -- Apply smart grouping if enabled
    if self.options.smart_grouping then
      diagnostics = self:apply_smart_grouping(diagnostics)
    end
    
    -- Format the output
    local formatted = self:format_diagnostics(diagnostics)
    
    -- Apply length limits
    if self.options.max_length > 0 and #formatted > self.options.max_length then
      formatted = self:truncate_diagnostics(formatted)
    end
    
    return formatted
  end)
end

---@param self SmartDiagnosticsComponent
---@return table<string, number>|nil diagnostics
function M.get_diagnostics(self)
  local diagnostics = {}
  
  for _, source in ipairs(self.options.sources) do
    local source_diagnostics = self:get_source_diagnostics(source)
    if source_diagnostics then
      for severity, count in pairs(source_diagnostics) do
        diagnostics[severity] = (diagnostics[severity] or 0) + count
      end
    end
  end
  
  return diagnostics
end

---@param self SmartDiagnosticsComponent
---@param source string
---@return table<string, number>|nil source_diagnostics
function M.get_source_diagnostics(self, source)
  if source == 'nvim_diagnostic' then
    return self:get_nvim_diagnostics()
  elseif source == 'coc' then
    return self:get_coc_diagnostics()
  elseif source == 'ale' then
    return self:get_ale_diagnostics()
  elseif source == 'vim_lsp' then
    return self:get_vim_lsp_diagnostics()
  end
  
  return nil
end

---@param self SmartDiagnosticsComponent
---@return table<string, number>|nil nvim_diagnostics
function M.get_nvim_diagnostics(self)
  local diagnostics = {}
  
  -- Get diagnostics from nvim.diagnostic
  if vim.diagnostic then
    local all_diagnostics = vim.diagnostic.get(0)
    
    for _, diag in ipairs(all_diagnostics) do
      local severity = self:get_severity_name(diag.severity)
      if severity then
        diagnostics[severity] = (diagnostics[severity] or 0) + 1
      end
    end
  end
  
  return diagnostics
end

---@param self SmartDiagnosticsComponent
---@return table<string, number>|nil coc_diagnostics
function M.get_coc_diagnostics(self)
  if vim.fn.exists('*coc#rpc#ready') == 0 then
    return nil
  end
  
  local diagnostics = {}
  local coc_diagnostics = vim.fn.CocAction('diagnosticList')
  
  if type(coc_diagnostics) == 'table' then
    for _, diag in ipairs(coc_diagnostics) do
      local severity = diag.severity or 'info'
      diagnostics[severity] = (diagnostics[severity] or 0) + 1
    end
  end
  
  return diagnostics
end

---@param self SmartDiagnosticsComponent
---@return table<string, number>|nil ale_diagnostics
function M.get_ale_diagnostics(self)
  if vim.fn.exists('*ale#statusline#Count') == 0 then
    return nil
  end
  
  local diagnostics = {}
  local ale_counts = vim.fn['ale#statusline#Count'](vim.api.nvim_get_current_buf())
  
  if type(ale_counts) == 'table' then
    diagnostics.error = ale_counts[1] or 0
    diagnostics.warn = ale_counts[2] or 0
    diagnostics.info = ale_counts[3] or 0
  end
  
  return diagnostics
end

---@param self SmartDiagnosticsComponent
---@return table<string, number>|nil vim_lsp_diagnostics
function M.get_vim_lsp_diagnostics(self)
  local diagnostics = {}
  
  -- Get LSP diagnostics from vim.lsp
  if vim.lsp then
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    
    for _, client in ipairs(clients) do
      if client.diagnostics then
        local client_diagnostics = client.diagnostics.get(0)
        
        for _, diag in ipairs(client_diagnostics) do
          local severity = self:get_severity_name(diag.severity)
          if severity then
            diagnostics[severity] = (diagnostics[severity] or 0) + 1
          end
        end
      end
    end
  end
  
  return diagnostics
end

---@param self SmartDiagnosticsComponent
---@param severity number
---@return string|nil severity_name
function M.get_severity_name(self, severity)
  local severity_map = {
    [vim.diagnostic.severity.ERROR] = 'error',
    [vim.diagnostic.severity.WARN] = 'warn',
    [vim.diagnostic.severity.INFO] = 'info',
    [vim.diagnostic.severity.HINT] = 'hint',
  }
  
  return severity_map[severity]
end

---@param self SmartDiagnosticsComponent
---@param diagnostics table<string, number>
---@return boolean is_empty
function M.is_empty(self, diagnostics)
  for _, count in pairs(diagnostics) do
    if count > 0 then
      return false
    end
  end
  return true
end

---@param self SmartDiagnosticsComponent
---@param diagnostics table<string, number>
---@return table<string, number> grouped_diagnostics
function M.apply_smart_grouping(self, diagnostics)
  local grouped = {}
  
  -- Group by severity priority
  for severity, count in pairs(diagnostics) do
    if count > 0 then
      local priority = self.options.severity_priority[severity] or 999
      
      -- Only show the highest priority severity
      if not grouped.priority or priority < grouped.priority then
        grouped = { [severity] = count, priority = priority }
      elseif priority == grouped.priority then
        -- Same priority, combine
        grouped[severity] = (grouped[severity] or 0) + count
      end
    end
  end
  
  -- Remove priority field
  grouped.priority = nil
  
  return grouped
end

---@param self SmartDiagnosticsComponent
---@param diagnostics table<string, number>
---@return string formatted_diagnostics
function M.format_diagnostics(self, diagnostics)
  local parts = {}
  
  -- Sort by severity priority
  local sorted_severities = {}
  for severity, count in pairs(diagnostics) do
    if count > 0 then
      table.insert(sorted_severities, {
        severity = severity,
        count = count,
        priority = self.options.severity_priority[severity] or 999
      })
    end
  end
  
  table.sort(sorted_severities, function(a, b)
    return a.priority < b.priority
  end)
  
  -- Format each severity
  for _, item in ipairs(sorted_severities) do
    local symbol = self.options.symbols[item.severity] or item.severity:upper():sub(1, 1)
    local formatted = symbol .. item.count
    
    if self.options.colored then
      -- Apply color based on severity
      local color = self:get_severity_color(item.severity)
      if color then
        formatted = color .. formatted .. '%*'
      end
    end
    
    table.insert(parts, formatted)
  end
  
  return table.concat(parts, ' ')
end

---@param self SmartDiagnosticsComponent
---@param severity string
---@return string|nil color_code
function M.get_severity_color(self, severity)
  local colors = {
    error = '%#DiagnosticError#',
    warn = '%#DiagnosticWarn#',
    info = '%#DiagnosticInfo#',
    hint = '%#DiagnosticHint#',
  }
  
  return colors[severity]
end

---@param self SmartDiagnosticsComponent
---@param formatted string
---@return string truncated_diagnostics
function M.truncate_diagnostics(self, formatted)
  if #formatted <= self.options.max_length then
    return formatted
  end
  
  -- Smart truncation: keep most important diagnostics
  local parts = vim.split(formatted, ' ')
  local truncated = {}
  local current_length = 0
  
  for _, part in ipairs(parts) do
    if current_length + #part + 1 <= self.options.max_length then
      table.insert(truncated, part)
      current_length = current_length + #part + 1
    else
      break
    end
  end
  
  local result = table.concat(truncated, ' ')
  if #result < #formatted then
    result = result .. '...'
  end
  
  return result
end

---@param self SmartDiagnosticsComponent
---@return table<string, any> performance_stats
function M.get_performance_stats(self)
  return {
    cache_hit_rate = self.perf:calculate_cache_hit_rate(),
    last_update = self.perf.last_refresh,
    grouping_cache_size = vim.tbl_count(self.grouping_cache),
  }
end

return M
