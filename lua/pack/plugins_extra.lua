vim.pack.add({
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/alex-popov-tech/store.nvim',

  -- Text manipulation
  'https://github.com/tpope/vim-surround',

  -- Vim Coach
  'https://github.com/shahshlok/vim-coach.nvim',
}, {
  confirm = false,
})

-- Load optional packages
vim.cmd.packadd 'markview.nvim'
vim.cmd.packadd 'snacks.nvim'
vim.cmd.packadd 'vim-coach.nvim'
vim.cmd.packadd 'store.nvim'
--

-- Configure Vim Coach
local coach_ok, coach = pcall(require, 'vim-coach')
if coach_ok then
  coach.setup()
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', { desc = 'Vim Coach' })
end
