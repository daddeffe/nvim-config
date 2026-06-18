vim.pack.add({
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/alex-popov-tech/store.nvim',

  -- Text manipulation
  'https://github.com/tpope/vim-surround',

  -- Vim Coach
  'https://github.com/shahshlok/vim-coach.nvim',

  -- Presentations
  'https://github.com/sotte/presenting.nvim',

  -- Encryption
  'https://github.com/Gitello448/aegis.nvim',

  -- Store
  'https://github.com/alex-popov-tech/store.nvim',
}, {
  confirm = false,
  load = true,
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

-- Configure presenting.nvim
require('presenting').setup {}
