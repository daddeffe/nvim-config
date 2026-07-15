vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/mplusp/pack-manager.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/SmiteshP/nvim-navic',
}, { confirm = false, load = true })

require('pack-manager').setup()

require 'pack.core.mini'
require 'pack.core.whichkey'
