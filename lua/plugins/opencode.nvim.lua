-- Plugin: NickvanDyke/opencode.nvim
-- Installed via store.nvim

vim.pack.add { 'https://github.com/folke/snacks.nvim' }
vim.pack.add { 'https://github.com/NickvanDyke/opencode.nvim' }

vim.g.opencode_opts = {}
vim.o.autoread = true
vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
  require('opencode').ask('@this: ', { submit = true })
end, { desc = 'Ask opencode' })
vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
  require('opencode').select()
end, { desc = 'Execute opencode action…' })
vim.keymap.set({ 'n', 'x' }, 'ga', function()
  require('opencode').prompt '@this'
end, { desc = 'Add to opencode' })
vim.keymap.set({ 'n', 't' }, '<C-.>', function()
  require('opencode').toggle()
end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<S-C-u>', function()
  require('opencode').command 'session.half.page.up'
end, { desc = 'opencode half page up' })
vim.keymap.set('n', '<S-C-d>', function()
  require('opencode').command 'session.half.page.down'
end, { desc = 'opencode half page down' })
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })

-- Autocompletamento personalizzato
vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
  -- In modalità insert, ritorna a normal mode temporaneamente
  if vim.fn.mode() == 'i' then
    vim.cmd 'stopinsert'
  end

  -- Ottieni la linea corrente come contesto
  local line = vim.api.nvim_get_current_line()

  -- Invia richiesta di completamento con @this per includere il file corrente
  require('opencode').ask('@this Complete this code/comment: ' .. line, { submit = true })
end, { desc = 'OpenCode autocomplete from current line' })

-- Alternativa: usa la selezione visuale o la linea corrente
vim.keymap.set({ 'n', 'x', 'i' }, '<C-S-k>', function()
  if vim.fn.mode() == 'i' then
    vim.cmd 'stopinsert'
  end

  require('opencode').ask('@this Continue writing this code naturally, providing only the next logical lines without explanation: ', { submit = true })
end, { desc = 'OpenCode smart completion' })
