-- nvim-treesitter branch `main` (API nuova, richiede Neovim >= 0.10)
-- Nota: il branch `master` è archiviato. `version = 'main'` indica a vim.pack
-- di tenere il plugin sul branch main. Per effettuare il checkout dopo il
-- cambio di branch lanciare :lua vim.pack.update() una volta.
vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
}, {
  confirm = false,
  load = true,
})

-- Parser da mantenere installati.
-- Sul branch main non esiste più `ensure_installed`: i parser si installano
-- esplicitamente con require('nvim-treesitter').install(...). La chiamata è
-- asincrona e non blocca lo startup; ripete skip per quelli già presenti.
local parsers = {
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
  -- 'python', -- escluso: query incompatibile con "except*"
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

-- Sul branch main install() non è sempre disponibile al primo avvio (il
-- plugin potrebbe non essere ancora stato scaricato). Proteggiamo con pcall.
local ok, nts = pcall(require, 'nvim-treesitter')
if ok and nts.install then
  nts.install(parsers)
end

-- Attivazione dell'highlight e del folding via treesitter.
-- Sul branch main niente `highlight = { enable = true }`: si chiama
-- vim.treesitter.start() per buffer, tipicamente su FileType.
-- pcall evita errori sui filetype per cui il parser non esiste/non è pronto.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_treesitter_start', { clear = true }),
  callback = function(args)
    local ft = args.match
    if ft == '' then
      return
    end
    -- Salta python: usa la regex highlight di vim (come prima)
    if ft == 'python' then
      return
    end
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local started = pcall(vim.treesitter.start, args.buf, lang)
    if started then
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
    end
  end,
})
