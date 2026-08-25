local lazy = require 'pack.lazy'

local function load_obsidian()
  require('obsidian').setup {
    workspaces = { { name = 'def', path = '~/Obsidian' } },
  }
end

lazy.by_key('obsidian.nvim', 'n', '<leader>oo', load_obsidian, function() vim.cmd 'ObsidianQuickSwitch' end, { desc = '[O]bsidian quick [o]pen' })
lazy.by_key('obsidian.nvim', 'n', '<leader>os', load_obsidian, function() vim.cmd 'ObsidianSearch' end, { desc = '[O]bsidian [s]earch' })
lazy.by_key('obsidian.nvim', 'n', '<leader>ot', load_obsidian, function() vim.cmd 'ObsidianToday' end, { desc = '[O]bsidian [t]oday' })
lazy.by_key('obsidian.nvim', 'n', '<leader>on', load_obsidian, function() vim.cmd 'ObsidianNew' end, { desc = '[O]bsidian [n]ew note' })
