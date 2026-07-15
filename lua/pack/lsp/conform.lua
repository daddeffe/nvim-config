require('conform').setup {
  notify_on_error = true,
  format_on_save = nil,
  formatexpr = true,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    php = { 'pint' },
    blade = { 'pint' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    svelte = { 'prettier' },
    vue = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    less = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    graphql = { 'prettier' },
    bash = { 'shfmt' },
    sh = { 'shfmt' },
    zsh = { 'shfmt' },
    go = { 'gofumpt', 'goimports' },
    rust = { 'rustfmt' },
    dockerfile = { 'hadolint' },
  },
  formatters = {
    shfmt = { prepend_args = { '-i', '2' } },
  },
}

vim.keymap.set('n', '<leader>=', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
