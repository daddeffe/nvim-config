vim.pack.add({
  'https://github.com/theprimeagen/harpoon',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/refractalize/oil-git-status.nvim',
  'https://github.com/sahilsehwag/macrobank.nvim',
  'https://github.com/serhez/bento.nvim',
}, { confirm = false, load = true })

require('macrobank').setup()

require 'pack.navigation.oil'
require 'pack.navigation.harpoon'
require 'pack.navigation.bento'
