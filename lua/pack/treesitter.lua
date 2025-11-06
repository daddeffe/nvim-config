vim.pack.add({
  -- MAIN: Treesitter for syntax highlighting and more
  'https://github.com/nvim-treesitter/nvim-treesitter',
}, {
  confirm = false,
})

-- Configure Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'diff',
    'html',
    'json',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'php',
    'query',
    'regex',
    'vim',
    'vimdoc',
    'yaml',
  },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    -- additional_vim_regex_highlighting = { 'ruby' },
  },
  --indent = { enable = false },
  --fold = { enable = false },
}

-- Build treesitter parsers on first run
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local ts_update = require('nvim-treesitter.install').update { with_sync = false }
    ts_update()
  end,
  once = true,
})
