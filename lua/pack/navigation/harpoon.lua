require('harpoon').setup()

vim.keymap.set('n', '<leader>a', "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = 'Harpoon [a]dd file' })
vim.keymap.set('n', '<leader>A', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Harpoon [A]links' })
vim.keymap.set('n', '<C-e>', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Harpoon UI' })
vim.keymap.set({ 'n', 'x' }, ']]', "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = 'Harpoon Next' })
vim.keymap.set({ 'n', 'x' }, '[[', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = 'Harpoon Previous' })
