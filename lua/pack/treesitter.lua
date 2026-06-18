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
    'cpp',
    'css',
    'diff',
    'dockerfile',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'lua',
    'luadoc',
    'make',
    'markdown',
    'markdown_inline',
    'php',
    'phpdoc',
    -- 'python', -- Disabled due to query incompatibility with Neovim version
    'query',
    'regex',
    'rust',
    'sql',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
  },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Disable Python due to treesitter query incompatibility with "except*" syntax
    disable = { 'python' },
    -- Use traditional vim regex highlighting for Python instead
    additional_vim_regex_highlighting = { 'python' },
  },
  --indent = { enable = false },
  --fold = { enable = false },
}

-- Build treesitter parsers on first run
-- Commented out to avoid conflicts
-- vim.api.nvim_create_autocmd('VimEnter', {
--   callback = function()
--     local ts_update = require('nvim-treesitter.install').update { with_sync = false }
--     ts_update()
--   end,
--   once = true,
-- })
