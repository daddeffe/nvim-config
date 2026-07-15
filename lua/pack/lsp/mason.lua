require('mason').setup {
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
  max_concurrent_installers = 4,
}

require('fidget').setup {}

local ensure_installed = vim.tbl_keys {}
vim.list_extend(ensure_installed, {
  'duster', 'lua_ls', 'markdownlint', 'pint', 'prettier', 'stylua',
  'ruff', 'pyright', 'black', 'isort',
  'intelephense',
  'yamlls', 'helm_ls',
})

require('mason-tool-installer').setup {
  ensure_installed = ensure_installed,
  auto_update = false,
  run_on_start = true,
}
