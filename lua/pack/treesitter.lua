vim.pack.add({
  'https://github.com/neovim-treesitter/treesitter-parser-registry',
  'https://github.com/neovim-treesitter/nvim-treesitter',
}, { confirm = false, load = true })

require('nvim-treesitter').setup {}

pcall(vim.treesitter.language.add, 'lua_patterns')

vim.schedule(function()
  require('nvim-treesitter').install { 'markdown', 'markdown_inline', 'regex' }
end)
