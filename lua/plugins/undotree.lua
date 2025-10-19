-- Plugin: jiaoshijie/undotree
-- Installed via store.nvim

vim.pack.add { 'https://github.com/jiaoshijie/undotree' }

require('undotree').setup {}

vim.keymap.set('n', '<leader>u', require('undotree').toggle, { desc = 'UndoTree Toggle', noremap = true, silent = true })
