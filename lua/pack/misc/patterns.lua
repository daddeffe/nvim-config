local lazy = require 'pack.lazy'

local function load_patterns()
  pcall(function()
    require('patterns.spec').setup {
      lua_patterns = { indent_size = 2, indent_marker = '│' },
      regex = { indent_size = 2, indent_marker = '│' },
    }
  end)
end

lazy.by_key('patterns.nvim', 'n', '<leader>pd', load_patterns, function() vim.cmd 'Patterns explain' end, { desc = '[P]atterns [D]escribe' })
lazy.by_key('patterns.nvim', 'n', '<leader>ph', load_patterns, function() vim.cmd 'Patterns hover' end, { desc = '[P]atterns [H]over' })
