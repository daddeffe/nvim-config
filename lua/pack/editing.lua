vim.pack.add({
  -- Autopairs
  'https://github.com/windwp/nvim-autopairs',

  -- Folding
  'https://github.com/chrisgrieser/nvim-origami',

  -- Indentation guides
  'https://github.com/lukas-reineke/indent-blankline.nvim',

  -- TODO comments highlighting
  'https://github.com/folke/todo-comments.nvim',

  -- Color highlighting for hex codes
  'https://github.com/norcalli/nvim-colorizer.lua',
  'https://github.com/ziontee113/color-picker.nvim',

  -- Advanced editing
  'https://github.com/smjonas/inc-rename.nvim',

  -- CSV viewing
  'https://github.com/hat0uma/csvview.nvim',

  -- Regex patterns
  'https://github.com/OXY2DEV/patterns.nvim',
}, {
  confirm = false,
  load = true,
})

-- Load optional packages
vim.cmd.packadd 'nvim-autopairs'
vim.cmd.packadd 'nvim-origami'
vim.cmd.packadd 'indent-blankline.nvim'
vim.cmd.packadd 'todo-comments.nvim'
vim.cmd.packadd 'nvim-colorizer.lua'

-- Configure autopairs
local autopairs_ok, autopairs = pcall(require, 'nvim-autopairs')
if autopairs_ok then
  autopairs.setup {}
end

-- Configure origami (folding)
local origami_ok, origami = pcall(require, 'origami')
if origami_ok then
  origami.setup {}
end
-- Configure indent-blankline
require('ibl').setup {}

-- Configure todo-comments
require('todo-comments').setup {
  signs = true,
}

-- Configure colorizer
require('colorizer').setup {
  '*', -- Highlight all files, but customize some others.
  css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
  html = { names = false }, -- Disable parsing "names" like Blue or Gray
}

-- Configure increname
vim.keymap.set('n', '<leader>rn', function()
  return ':IncRename ' .. vim.fn.expand '<cword>'
end, { expr = true })

-- Configure color-picker
require('color-picker').setup {
  ['icons'] = { '=', '|' },
}

-- Configure csvview
require('csvview').setup {
  parser = { comments = { '#', '//' } },
  keymaps = {
    textobject_field_inner = { 'if', mode = { 'o', 'x' } },
    textobject_field_outer = { 'af', mode = { 'o', 'x' } },
    jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
    jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
    jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
    jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
  },
}

-- Note: mini.nvim modules are configured in core.lua
