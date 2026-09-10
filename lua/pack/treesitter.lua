vim.pack.add({
  'https://github.com/neovim-treesitter/treesitter-parser-registry',
  'https://github.com/neovim-treesitter/nvim-treesitter',
}, { confirm = false, load = true })

require('nvim-treesitter').setup {}

pcall(vim.treesitter.language.add, 'lua_patterns')

-- filetype 'yaml.helm-values' (values.yaml nei chart Helm) evidenzia come yaml
vim.treesitter.language.add('yaml.helm-values', 'yaml')

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
    'gotmpl',
    'helm',
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
