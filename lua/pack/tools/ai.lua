vim.pack.add({
  'https://github.com/NickvanDyke/opencode.nvim',
}, { confirm = false, load = true })

vim.g.opencode_opts = {
  provider = { snacks = { win = { enter = true } } },
}

vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
  require('opencode').ask('@this: ', { submit = true })
end, { desc = 'Ask opencode' })
vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
  require('opencode').select()
end, { desc = 'Execute opencode action…' })
vim.keymap.set({ 'n', 'x' }, '<leader>aa', function()
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
vim.keymap.set({ 'n', 'i' }, '<leader>ak', function()
  if vim.fn.mode() == 'i' then vim.cmd 'stopinsert' end
  require('opencode').ask('@this Complete this code/comment: ' .. vim.api.nvim_get_current_line(), { submit = true })
end, { desc = 'OpenCode autocomplete from current line' })
vim.keymap.set({ 'n', 'x', 'i' }, '<leader>aK', function()
  if vim.fn.mode() == 'i' then vim.cmd 'stopinsert' end
  require('opencode').ask('@this Continue writing this code naturally, providing only the next logical lines without explanation: ', { submit = true })
end, { desc = 'OpenCode smart completion' })
