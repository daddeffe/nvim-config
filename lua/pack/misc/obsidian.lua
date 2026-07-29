require('obsidian').setup {
  workspaces = { { name = 'def', path = '~/Obsidian' } },
}

vim.keymap.set('n', '<leader>oo', '<cmd>ObsidianQuickSwitch<CR>', { desc = '[O]bsidian quick [o]pen' })
vim.keymap.set('n', '<leader>os', '<cmd>ObsidianSearch<CR>', { desc = '[O]bsidian [s]earch' })
vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianToday<CR>', { desc = '[O]bsidian [t]oday' })
vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<CR>', { desc = '[O]bsidian [n]ew note' })
