require('conform').setup {
  notify_on_error = true,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    end
    return { timeout_ms = 5000, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    svelte = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    graphql = { 'prettier' },
    lua = { 'stylua' },
    python = { 'isort', 'black' },
  },
}

vim.keymap.set('n', '<leader>=', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
