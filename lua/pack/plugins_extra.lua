vim.pack.add({
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/alex-popov-tech/store.nvim',

  -- Text manipulation
  'https://github.com/tpope/vim-surround',

  -- AutoReload file
  'https://github.com/manuuurino/autoread.nvim',

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
vim.cmd.packadd 'autoread.nvim'
--

-- Configure AutoRead
local autoread_ok, autoread = pcall(require, 'autoread')
if autoread_ok then
  autoread.setup {
    -- Check for file changes every 200ms
    poll_time = 200,
    -- Notify when file is reloaded
    notify = false,
  }
end

-- Configure Vim Coach
local coach_ok, coach = pcall(require, 'vim-coach')
if coach_ok then
  coach.setup()
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', { desc = 'Vim Coach' })
end
