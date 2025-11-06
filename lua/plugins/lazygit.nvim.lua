-- Plugin: kdheepak/lazygit.nvim
-- Installed via store.nvim

vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/kdheepak/lazygit.nvim' }

require('telescope').load_extension 'lazygit'

-- Rename the variable under your cursor
vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = 'LSP: [R]e[n]ame' })
