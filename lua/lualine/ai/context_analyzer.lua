-- Copyright (c) 2024 Modern lualine.nvim
-- MIT license, see LICENSE for more details.

---@class ContextAnalyzer
---@field project_type string
---@field file_patterns table<string, string>
---@field context_cache table<string, any>
---@field learning_data table<string, number>
local ContextAnalyzer = {}
ContextAnalyzer.__index = ContextAnalyzer

---@return ContextAnalyzer
function ContextAnalyzer.new()
  local self = setmetatable({}, ContextAnalyzer)
  self.project_type = 'unknown'
  self.file_patterns = {
    -- Web development
    ['package.json'] = 'web',
    ['yarn.lock'] = 'web',
    ['pnpm-lock.yaml'] = 'web',
    ['webpack.config.js'] = 'web',
    ['vite.config.js'] = 'web',
    ['next.config.js'] = 'nextjs',
    ['nuxt.config.js'] = 'nuxt',
    ['vue.config.js'] = 'vue',
    ['angular.json'] = 'angular',
    ['svelte.config.js'] = 'svelte',
    
    -- Mobile development
    ['android/app/build.gradle'] = 'android',
    ['ios/Podfile'] = 'ios',
    ['pubspec.yaml'] = 'flutter',
    ['react-native.config.js'] = 'react_native',
    
    -- Backend development
    ['requirements.txt'] = 'python',
    ['pyproject.toml'] = 'python',
    ['Pipfile'] = 'python',
    ['go.mod'] = 'go',
    ['Cargo.toml'] = 'rust',
    ['composer.json'] = 'php',
    ['Gemfile'] = 'ruby',
    ['pom.xml'] = 'java',
    ['build.gradle'] = 'java',
    
    -- DevOps
    ['Dockerfile'] = 'docker',
    ['docker-compose.yml'] = 'docker',
    ['k8s.yaml'] = 'kubernetes',
    ['terraform.tf'] = 'terraform',
    ['ansible.cfg'] = 'ansible',
    
    -- Data Science
    ['environment.yml'] = 'data_science',
    ['requirements.txt'] = 'data_science',
    ['jupyter_notebook_config.py'] = 'jupyter',
    
    -- Documentation
    ['mkdocs.yml'] = 'documentation',
    ['docusaurus.config.js'] = 'documentation',
    ['vitepress.config.js'] = 'documentation',
  }
  self.context_cache = {}
  self.learning_data = {}
  return self
end

---@param self ContextAnalyzer
---@return string project_type
function ContextAnalyzer:analyze_project_context()
  return self:get_cached_or_compute('project_context', function()
    local cwd = vim.fn.getcwd()
    local project_type = 'unknown'
    
    -- Check for project indicators
    for pattern, type in pairs(self.file_patterns) do
      if vim.fn.filereadable(cwd .. '/' .. pattern) == 1 then
        project_type = type
        break
      end
    end
    
    -- Check for directory structure patterns
    if vim.fn.isdirectory(cwd .. '/src') == 1 and vim.fn.isdirectory(cwd .. '/tests') == 1 then
      project_type = 'generic_development'
    elseif vim.fn.isdirectory(cwd .. '/app') == 1 and vim.fn.isdirectory(cwd .. '/config') == 1 then
      project_type = 'rails'
    elseif vim.fn.isdirectory(cwd .. '/components') == 1 and vim.fn.isdirectory(cwd .. '/pages') == 1 then
      project_type = 'nextjs'
    end
    
    self.project_type = project_type
    return project_type
  end)
end

---@param self ContextAnalyzer
---@return string file_context
function ContextAnalyzer:analyze_file_context()
  return self:get_cached_or_compute('file_context', function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%:t')
    local filepath = vim.fn.expand('%:p')
    
    local context = {
      filetype = filetype,
      filename = filename,
      is_test = self:is_test_file(filename, filepath),
      is_config = self:is_config_file(filename, filepath),
      is_documentation = self:is_documentation_file(filename, filetype),
      is_asset = self:is_asset_file(filename, filetype),
    }
    
    return context
  end)
end

---@param self ContextAnalyzer
---@param filename string
---@param filepath string
---@return boolean
function ContextAnalyzer:is_test_file(filename, filepath)
  local test_patterns = {
    'test_', '_test', '.test.', '.spec.', '_spec',
    'tests/', 'spec/', '__tests__/', '__spec__/'
  }
  
  for _, pattern in ipairs(test_patterns) do
    if filename:find(pattern) or filepath:find(pattern) then
      return true
    end
  end
  
  return false
end

---@param self ContextAnalyzer
---@param filename string
---@param filepath string
---@return boolean
function ContextAnalyzer:is_config_file(filename, filepath)
  local config_patterns = {
    'config', 'conf', 'cfg', 'ini', 'yaml', 'yml', 'json', 'toml',
    'rc', 'rc.', '.rc', 'env', '.env'
  }
  
  for _, pattern in ipairs(config_patterns) do
    if filename:find(pattern) or filepath:find(pattern) then
      return true
    end
  end
  
  return false
end

---@param self ContextAnalyzer
---@param filename string
---@param filetype string
---@return boolean
function ContextAnalyzer:is_documentation_file(filename, filetype)
  local doc_filetypes = { 'markdown', 'rst', 'tex', 'asciidoc' }
  local doc_patterns = { 'readme', 'changelog', 'license', 'contributing' }
  
  for _, ft in ipairs(doc_filetypes) do
    if filetype == ft then
      return true
    end
  end
  
  for _, pattern in ipairs(doc_patterns) do
    if filename:lower():find(pattern) then
      return true
    end
  end
  
  return false
end

---@param self ContextAnalyzer
---@param filename string
---@param filetype string
---@return boolean
function ContextAnalyzer:is_asset_file(filename, filetype)
  local asset_filetypes = { 'css', 'scss', 'sass', 'less', 'styl' }
  local asset_extensions = { '.png', '.jpg', '.jpeg', '.gif', '.svg', '.ico', '.woff', '.woff2', '.ttf' }
  
  for _, ft in ipairs(asset_filetypes) do
    if filetype == ft then
      return true
    end
  end
  
  for _, ext in ipairs(asset_extensions) do
    if filename:lower():find(ext) then
      return true
    end
  end
  
  return false
end

---@param self ContextAnalyzer
---@return table<string, any> suggested_components
function ContextAnalyzer:suggest_components()
  local project_type = self:analyze_project_context()
  local file_context = self:analyze_file_context()
  
  local suggestions = {
    lualine_a = { 'modern_mode' },
    lualine_b = {},
    lualine_c = { 'smart_filename' },
    lualine_x = {},
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }
  
  -- Project-specific suggestions
  if project_type == 'web' or project_type == 'nextjs' or project_type == 'vue' then
    table.insert(suggestions.lualine_b, 'minimal_git')
    table.insert(suggestions.lualine_x, 'filetype')
    if file_context.is_test then
      table.insert(suggestions.lualine_b, 'test_status')
    end
  elseif project_type == 'python' then
    table.insert(suggestions.lualine_b, 'minimal_git')
    table.insert(suggestions.lualine_x, 'python_env')
    if file_context.is_test then
      table.insert(suggestions.lualine_b, 'pytest_status')
    end
  elseif project_type == 'rust' then
    table.insert(suggestions.lualine_b, 'minimal_git')
    table.insert(suggestions.lualine_x, 'cargo_status')
    if file_context.is_test then
      table.insert(suggestions.lualine_b, 'cargo_test_status')
    end
  elseif project_type == 'go' then
    table.insert(suggestions.lualine_b, 'minimal_git')
    table.insert(suggestions.lualine_x, 'go_version')
    if file_context.is_test then
      table.insert(suggestions.lualine_b, 'go_test_status')
    end
  else
    -- Generic development
    table.insert(suggestions.lualine_b, 'minimal_git')
    table.insert(suggestions.lualine_x, 'filetype')
  end
  
  -- File-specific suggestions
  if file_context.is_config then
    table.insert(suggestions.lualine_x, 'config_status')
  elseif file_context.is_documentation then
    table.insert(suggestions.lualine_x, 'word_count')
  elseif file_context.is_asset then
    table.insert(suggestions.lualine_x, 'file_size')
  end
  
  return suggestions
end

---@param self ContextAnalyzer
---@param key string
---@param compute_fn function
---@return any
function ContextAnalyzer:get_cached_or_compute(key, compute_fn)
  if self.context_cache[key] then
    return self.context_cache[key]
  end
  
  local result = compute_fn()
  self.context_cache[key] = result
  return result
end

---@param self ContextAnalyzer
function ContextAnalyzer:clear_cache()
  self.context_cache = {}
end

---@param self ContextAnalyzer
---@param component_usage table<string, number>
function ContextAnalyzer:learn_from_usage(component_usage)
  for component, usage_count in pairs(component_usage) do
    self.learning_data[component] = (self.learning_data[component] or 0) + usage_count
  end
end

---@param self ContextAnalyzer
---@return table<string, number> optimized_components
function ContextAnalyzer:get_optimized_components()
  local optimized = {}
  
  -- Sort components by usage frequency
  local sorted_components = {}
  for component, count in pairs(self.learning_data) do
    table.insert(sorted_components, { component = component, count = count })
  end
  
  table.sort(sorted_components, function(a, b)
    return a.count > b.count
  end)
  
  -- Return top 5 most used components
  for i = 1, math.min(5, #sorted_components) do
    optimized[sorted_components[i].component] = sorted_components[i].count
  end
  
  return optimized
end

return ContextAnalyzer
