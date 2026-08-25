vim.pack.add({
  'https://github.com/lambdalisue/vim-suda',
  'https://github.com/dccsillag/magma-nvim',
  'https://github.com/epwalsh/obsidian.nvim',
  'https://github.com/OXY2DEV/patterns.nvim',
}, { confirm = false, load = false })

-- Plugin disabilitati: decommenta per attivare
require 'pack.misc.obsidian'
require 'pack.misc.magma'
require 'pack.misc.patterns'
