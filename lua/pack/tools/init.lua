-- Dispatcher: tools are now split into focused modules
-- Order matters: telescope must load before git (lazygit extension)
vim.pack.add({
  'https://github.com/XXiaoA/atone.nvim',
}, { confirm = false, load = true })

require 'pack.tools.telescope'
require 'pack.tools.git'
require 'pack.tools.ai'
require 'pack.tools.atone'
