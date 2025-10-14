vim.pack.add {
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
}

-- Configure autopairs
local autopairs_ok, autopairs = pcall(require, 'nvim-autopairs')
if autopairs_ok then
  autopairs.setup {}
end

-- Configure origami (folding)
local origami_ok, origami = pcall(require, 'nvim-origami')

-- Configure indent-blankline
require('ibl').setup {}

-- Configure todo-comments
require('todo-comments').setup {
  --signs = false,
}

-- Configure colorizer
require('colorizer').setup {
  '*', -- Highlight all files, but customize some others.
  css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
  html = { names = false }, -- Disable parsing "names" like Blue or Gray
}

-- Note: mini.nvim modules are configured in core.lua

