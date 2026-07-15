vim.cmd.packadd 'nvim-colorizer.lua'

require('colorizer').setup {
  '*',
  css = { rgb_fn = true },
  html = { names = false },
}

require('color-picker').setup { ['icons'] = { '=', '|' } }
