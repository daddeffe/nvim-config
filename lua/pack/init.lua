-- Add custom packpath
vim.opt.packpath:append(vim.fn.expand '~/.local/share/nvim/site/pack/core')

-- Compatibility shim for deprecated vim.tbl_flatten
vim.tbl_flatten = function(t)
  return vim.iter(t):flatten():totable()
end

require 'pack.opt'

require 'pack.core'

require 'pack.treesitter'
require 'pack.completion'

require 'pack.tools'
require 'pack.editing'
require 'pack.lsp'
require 'pack.navigation'

require 'pack.plugins_extra'

require 'pack.binds'
require 'pack.autocmd'

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

vim.api.nvim_create_user_command('AlignColumns', function(opts)
  vim.cmd(string.format("%d,%d!column -t -o ' ' | sed 's/ = /=/' | sed 's/[ \t]*$//'", opts.line1, opts.line2))
end, { range = true })

