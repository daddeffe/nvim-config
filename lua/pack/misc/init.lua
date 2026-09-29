vim.pack.add({
  'https://github.com/lambdalisue/vim-suda',
  'https://github.com/dccsillag/magma-nvim',
  'https://github.com/epwalsh/obsidian.nvim',
  'https://github.com/OXY2DEV/patterns.nvim',
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/alex-popov-tech/store.nvim',
}, { confirm = false, load = false })

-- Plugin disabilitati: decommenta per attivare
require 'pack.misc.obsidian'
require 'pack.misc.magma'
require 'pack.misc.patterns'
require 'pack.misc.store'

local plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'
for _, file in ipairs(vim.fn.glob(plugins_dir .. '/*.lua', true, true)) do
  dofile(file)
end
