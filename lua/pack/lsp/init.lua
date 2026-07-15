vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}, { confirm = false, load = true })

require 'pack.lsp.mason'
require 'pack.lsp.conform'
require 'pack.lsp.lint'
require 'pack.lsp.keymaps'
require 'pack.lsp.diagnostics'
require 'pack.lsp.servers'
