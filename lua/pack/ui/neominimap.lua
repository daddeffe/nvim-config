-- Plugin: Isrothy/neominimap.nvim
-- Installed via store.nvim

vim.pack.add { 'https://github.com/Isrothy/neominimap.nvim' }

vim.opt.wrap = false
vim.opt.sidescrolloff = 36

--- Put your configuration here
vim.g.neominimap = {
  auto_enable = true,
}
