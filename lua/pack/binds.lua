-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
  -- Also dismiss Noice notifications if available
  if pcall(require, 'noice') then
    vim.cmd 'NoiceDismiss'
  end
end, { desc = 'Clear highlights and notifications' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list', silent = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Move inside insert mode
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')

vim.keymap.set('n', '<leader><leader>', ':lua vim.cmd.so()<CR>', { desc = 'Source file', silent = true })
vim.keymap.set('v', '<leader>x', '<cmd>.lua<CR><ESC>', { desc = 'Execute the current line' })
-- create a keymap to exit from insert mode and save the file when pressing jk
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode', silent = true })
vim.keymap.set('n', 'xc', ':w<CR>', { desc = 'Write file', silent = true })

-- Move block in visual line
vim.keymap.set('v', 'J', ":m '>+1<CR>", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>", { silent = true })

-- Force cursor at center during J, nav and serach
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<PageUp>', '<C-u>zz')
vim.keymap.set('n', '<PageDown>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- No more Q
--vim.keymap.set('n', 'Q', '<nop>')

-- Easy
vim.keymap.set('i', '<C-c>', '<Esc>')

-- No super interpreted
vim.keymap.set({ 'n', 'i', 'v' }, '<Super>', '<Nop>', { silent = true })

-- Paste with yanking to null reg
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without overvrite last yank' })

-- Move block in visual line
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv'")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv'")

-- Execute selected lines in a new horizontal split terminal (for .sh files)
vim.keymap.set('v', '<leader>r', function()
  -- Get the selected lines
  local start_line = vim.fn.line 'v'
  local end_line = vim.fn.line '.'
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local command = table.concat(lines, '\n')

  vim.cmd 'normal! <Esc>'

  vim.cmd 'split'
  vim.cmd 'terminal'
  vim.fn.chansend(vim.b.terminal_job_id, command .. '\n')
end, { desc = 'Execute selection in new terminal split' })

-- Toggle options under <leader>t
vim.keymap.set('n', '<leader>tW', function()
  vim.cmd 'setlocal wrap!'
end, { desc = 'Toggle [W]rap' })

vim.keymap.set('n', '<leader>ts', function()
  vim.wo.signcolumn = (vim.wo.signcolumn == 'yes') and 'no' or 'yes'
end, { desc = 'Toggle [S]igncolumn' })

vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle [D]iagnostics' })

vim.keymap.set('n', '<leader>tp', function()
  vim.cmd 'setlocal spell!'
end, { desc = 'Toggle S[p]ell' })

vim.keymap.set('n', '<leader>tL', function()
  vim.wo.list = not vim.wo.list
end, { desc = 'Toggle [L]ist chars' })

vim.keymap.set('n', '<leader>tc', function()
  if vim.wo.colorcolumn == '0' or vim.wo.colorcolumn == '' then
    vim.wo.colorcolumn = '85'
  else
    vim.wo.colorcolumn = '0'
  end
end, { desc = 'Toggle [C]olor column' })
