vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.o.number = true
vim.o.wrap = false
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = false
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.spell = true
vim.o.spelllang = 'it,en'

vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.splitkeep = 'topline'

vim.o.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

--vim.o.foldmethod = 'expr' -- Definisci i fold usando un'espressione
--vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Usa Treesitter per il folding
vim.o.foldlevel = 99 -- Apri tutti i fold di default all'apertura di un file
vim.opt.foldtext = '' -- Evidenzia la sintassi della prima riga del fold

-- length of an actual \t character:
vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
vim.opt.shiftround = true

vim.opt.expandtab = true
vim.opt.autoindent = true

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 8

vim.o.confirm = true

vim.o.autoread = true
vim.o.autowrite = true
