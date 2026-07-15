vim.pack.add({
  'https://github.com/catppuccin/nvim',
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/alchezar/fishbone.nvim',
  'https://github.com/stevearc/dressing.nvim',
}, { confirm = false })

require 'pack.ui.catppuccin'
require 'pack.ui.noice'
require 'pack.ui.dressing'
require 'pack.ui.fishbone'
