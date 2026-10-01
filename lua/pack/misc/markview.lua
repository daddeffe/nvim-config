local lazy = require 'pack.lazy'

local function load_markview()
  require('markview').setup {
    preview = {
      filetypes = { 'markdown', 'Avante' },
      ignore_buftypes = {},
    },
  }
end

lazy.by_filetype('markview.nvim', { 'markdown', 'Avante' }, load_markview)
lazy.by_key('markview.nvim', 'n', '<leader>tm', load_markview, function()
  vim.cmd 'Markview'
end, { desc = 'Toggle markview' })
