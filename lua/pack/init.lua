-- Add custom packpath
vim.opt.packpath:append(vim.fn.expand '~/.local/share/nvim/site/pack/core')

-- Compatibility shim for deprecated vim.tbl_flatten
vim.tbl_flatten = function(t)
  return vim.iter(t):flatten():totable()
end

require 'pack.opt'

require 'pack.core'
require 'pack.ui'

require 'pack.completion'

require 'pack.tools'
require 'pack.editing'
require 'pack.lsp'
require 'pack.navigation'

--require 'pack.plugins_extra'

require 'pack.binds'
require 'pack.autocmd'

vim.api.nvim_create_user_command('AlignColumns', function(opts)
  vim.cmd(string.format("%d,%d!column -t -o ' ' | sed 's/ = /=/' | sed 's/[ \t]*$//'", opts.line1, opts.line2))
end, { range = true })
