pcall(function()
  require('patterns.spec').setup {
    lua_patterns = { indent_size = 2, indent_marker = '│' },
    regex = { indent_size = 2, indent_marker = '│' },
  }
end)

vim.keymap.set('n', '<leader>pd', '<cmd>Patterns explain<CR>', { desc = '[P]atterns [D]escribe' })
vim.keymap.set('n', '<leader>ph', '<cmd>Patterns hover<CR>', { desc = '[P]atterns [H]over' })
