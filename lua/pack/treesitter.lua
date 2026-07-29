vim.pack.add({
  'https://github.com/neovim-treesitter/treesitter-parser-registry',
  'https://github.com/neovim-treesitter/nvim-treesitter',
}, { confirm = false, load = true })

require('nvim-treesitter').setup {}

pcall(vim.treesitter.language.add, 'lua_patterns')

vim.schedule(function()
  require('nvim-treesitter').install {
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
    'lua',
    'luadoc',
    'make',
    'markdown',
    'markdown_inline',
    'php',
    'phpdoc',
    'python',
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
  }
end)
