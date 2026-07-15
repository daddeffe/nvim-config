local luasnip_ok, luasnip = pcall(require, 'luasnip')
if luasnip_ok then
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load {
    paths = vim.fn.stdpath 'data' .. '/site/pack/*/start/friendly-snippets',
  }
end

_G.luasnip = luasnip
