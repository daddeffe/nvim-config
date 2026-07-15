vim.pack.add({
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-cmdline',
  'https://github.com/saadparwaiz1/cmp_luasnip',
}, { confirm = false, load = true })

require 'pack.completion.lazydev'
require 'pack.completion.luasnip'
require 'pack.completion.cmp'
