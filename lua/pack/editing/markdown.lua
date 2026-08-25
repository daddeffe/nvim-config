local lazy = require 'pack.lazy'

local function load_markdown()
  require('markdown-table-mode').setup()
end

lazy.by_filetype('markdown-table-mode.nvim', 'markdown', load_markdown)