-- Core dependencies and shared libraries
require 'pack.core'

-- UI and theming
require 'pack.ui'

-- Development tools
require 'pack.lsp'
require 'pack.completion'
require 'pack.treesitter'

-- Editor enhancements
require 'pack.editing'
require 'pack.navigation'
require 'pack.tools'

-- Additional plugins
require 'pack.plugins_extra'

-- Load plugins from lua/plugins/ directory
local plugins_path = vim.fn.stdpath('config') .. '/lua/plugins'
if vim.fn.isdirectory(plugins_path) == 1 then
  local plugins = vim.fn.glob(plugins_path .. '/*.lua', false, true)
  for _, plugin_file in ipairs(plugins) do
    local plugin_name = vim.fn.fnamemodify(plugin_file, ':t:r')
    pcall(require, 'plugins.' .. plugin_name)
  end
end
