-- Add custom packpath
vim.opt.packpath:append(vim.fn.expand '~/.local/share/nvim/site/pack/core')

-- Compatibility shim for deprecated vim.tbl_flatten
vim.tbl_flatten = function(t)
  return vim.iter(t):flatten():totable()
end

counter = 0
-- Core dependencies and shared libraries
require 'pack.core'

-- UI and theming
require 'pack.ui'

-- Development tools
require 'pack.lsp'
require 'pack.treesitter'
require 'pack.completion'

-- Editor enhancements
require 'pack.editing'
require 'pack.navigation'
require 'pack.tools'

-- Additional plugins
require 'pack.plugins_extra'

-- Load plugins from lua/plugins/ directory
local fs = vim.fs -- nvim ≥ 0.9
local plugins_dir = fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugins')

if vim.fn.isdirectory(plugins_dir) == 1 then
  local pattern = fs.joinpath(plugins_dir, '*.lua')
  for _, plugin_file in ipairs(vim.fn.glob(pattern, true, true)) do
    local ok, err = pcall(dofile, plugin_file) -- carica ed esegue il file
    if not ok then
      vim.notify(('Errore in %s: %s'):format(plugin_file, err), vim.log.levels.ERROR)
    end
  end
end

vim.schedule(function()
  vim.notify 'Plugin caricati'
end)
