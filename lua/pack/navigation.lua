vim.pack.add {
  -- VSCode like winbar
  'https://github.com/utilyre/barbecue.nvim',
  'https://github.com/SmiteshP/nvim-navic',

  -- Macro management
  'https://github.com/sahilsehwag/macrobank.nvim',
}

-- Configure barbecue
local barbecue_ok, barbecue = pcall(require, 'barbecue')
if barbecue_ok then
  barbecue.setup {
    -- Configuration options can be added here
  }
end

-- Configure macrobank
local macrobank_ok, macrobank = pcall(require, 'macrobank')
if macrobank_ok then
  macrobank.setup()
end

-- Harpoon keymaps
local harpoon_ok, harpoon = pcall(require, 'harpoon')
if harpoon_ok then
  vim.keymap.set('n', '<leader>a', "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = 'Add File to Harpoon' })
  vim.keymap.set('n', '<C-e>', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Harpoon UI' })
  vim.keymap.set({ 'n', 'x' }, ']]', "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = 'Harpoon Next' })
  vim.keymap.set({ 'n', 'x' }, '[[', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = 'Harpoon Previous' })
end