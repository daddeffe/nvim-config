local lazy = require 'pack.lazy'

local function load_harpoon()
  require('harpoon').setup()
end

lazy.by_key('harpoon', 'n', '<leader>a', load_harpoon, function() vim.cmd "lua require('harpoon.mark').add_file()" end, { desc = 'Harpoon [a]dd file' })
lazy.by_key('harpoon', 'n', '<leader>A', load_harpoon, function() vim.cmd "lua require('harpoon.ui').toggle_quick_menu()" end, { desc = 'Harpoon [A]links' })
lazy.by_key('harpoon', { 'n', 'x' }, ']]', load_harpoon, function() vim.cmd "lua require('harpoon.ui').nav_next()" end, { desc = 'Harpoon Next' })
lazy.by_key('harpoon', { 'n', 'x' }, '[[', load_harpoon, function() vim.cmd "lua require('harpoon.ui').nav_prev()" end, { desc = 'Harpoon Previous' })