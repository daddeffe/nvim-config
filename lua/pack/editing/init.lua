vim.pack.add({
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/chrisgrieser/nvim-origami',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/norcalli/nvim-colorizer.lua',
  'https://github.com/ziontee113/color-picker.nvim',
  'https://github.com/hat0uma/csvview.nvim',
  'https://github.com/Kicamon/markdown-table-mode.nvim',
}, { confirm = false, load = true })

require 'pack.editing.autopairs'
require 'pack.editing.origami'
require 'pack.editing.todo'
require 'pack.editing.colorizer'
require 'pack.editing.csv'
require 'pack.editing.markdown'
