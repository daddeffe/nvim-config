vim.pack.add({
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/milanglacier/minuet-ai.nvim',
}, { confirm = false, load = true })

require 'pack.completion.lazydev'
require 'pack.completion.luasnip'
require 'pack.completion.minuet'
require 'pack.completion.blink'

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    local lib = vim.fn.glob(vim.fn.stdpath 'data' .. '/site/pack/*/opt/blink.cmp/lib')
    if lib ~= '' then
      return
    end
    local ok, err = pcall(function()
      require('blink.cmp').build():pwait()
    end)
    if not ok then
      vim.notify('blink.cmp build failed: ' .. tostring(err), vim.log.levels.WARN)
    end
  end,
})
