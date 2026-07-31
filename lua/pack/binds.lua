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

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

vim.keymap.set('n', '<leader><leader>', ':lua vim.cmd.so()<CR>', { desc = 'Source file', silent = true })
vim.keymap.set('v', '<leader>x', '<cmd>.lua<CR><ESC>', { desc = 'Execute the current line' })
-- create a keymap to exit from insert mode and save the file when pressing jk
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode', silent = true })
vim.keymap.set('n', 'xc', ':w<CR>', { desc = 'Write file', silent = true })

-- Force cursor at center during J, nav and serach
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<PageUp>', '<C-u>zz')
vim.keymap.set('n', '<PageDown>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Easy
vim.keymap.set('i', '<C-c>', '<Esc>')

-- No super interpreted
vim.keymap.set({ 'n', 'i', 'v' }, '<Super>', '<Nop>', { silent = true })

-- Paste with yanking to null reg
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without overvrite last yank' })

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

vim.keymap.set('n', '<leader>T', function()
  Snacks.terminal()
end, { desc = 'Open [T]erminal' })

vim.keymap.set('n', '<leader>tH', function()
  Snacks.dashboard.open()
end, { desc = 'Toggle [D]im' })

vim.keymap.set('n', '<leader>tD', function()
  Snacks.toggle.dim()
end, { desc = 'Toggle [D]im' })

vim.keymap.set('n', '<leader>tz', function()
  Snacks.zen()
end, { desc = 'Toggle [Z]en' })

-- Toggle options under <leader>t
vim.keymap.set('n', '<leader>tw', function()
  vim.cmd 'setlocal wrap!'
end, { desc = 'Toggle [W]rap' })

vim.keymap.set('n', '<leader>tS', function()
  vim.wo.signcolumn = (vim.wo.signcolumn == 'yes') and 'no' or 'yes'
end, { desc = 'Toggle [S]igncolumn' })

vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle [D]iagnostics' })

vim.keymap.set('n', '<leader>ts', function()
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

vim.keymap.set('n', '<leader>tb', function()
  local cat = require 'catppuccin'
  cat.options.transparent_background = not cat.options.transparent_background
  cat.compile()
  vim.cmd.colorscheme 'catppuccin'
end, { desc = 'Toggle Transparent [B]ackground' })

vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = 'Split horizontal' })
vim.keymap.set('n', '<leader>w|', '<C-w>v', { desc = 'Split vertical' })
vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = 'Close window' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = 'Only this window' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equalize windows' })

vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Buffer next' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = 'Buffer previous' })
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Buffer delete' })
vim.keymap.set('n', '<leader>bD', ':bd!<CR>', { desc = 'Buffer force delete' })
vim.keymap.set('n', '<leader>bs', ':w<CR>', { desc = 'Buffer save' })

vim.keymap.set('n', '<leader>ee', '<cmd>Oil<CR>', { desc = 'Oil explorer' })
vim.keymap.set('n', '<leader>ef', '<cmd>Oil --float<CR>', { desc = 'Oil float' })
vim.keymap.set('n', '<leader>ed', function()
  vim.cmd('Oil ' .. vim.fn.expand '%:p:h')
end, { desc = 'Oil current dir' })

vim.keymap.set('n', '<leader>fn', ':enew<CR>', { desc = 'New buffer' })
vim.keymap.set('n', '<leader>fS', ':wa<CR>', { desc = 'Save all files' })

vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<CR>', { desc = 'LSP info' })
vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', { desc = 'LSP restart' })
vim.keymap.set('n', '<leader>ll', '<cmd>LspLog<CR>', { desc = 'LSP log' })

vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Yank line to clipboard' })
vim.keymap.set('n', '<leader>yY', function()
  vim.fn.setreg('+', vim.fn.expand '%:p')
end, { desc = 'Yank file path to clipboard' })
vim.keymap.set('n', '<leader>yr', '<cmd>Telescope registers<CR>', { desc = 'Telescope registers' })

vim.keymap.set('n', '<leader>mm', '<cmd>Telescope marks<CR>', { desc = 'List marks' })

vim.keymap.set('n', '<leader>Nn', ':enew<CR>', { desc = 'New scratch buffer' })
vim.keymap.set('n', '<leader>Np', ':e ~/scratchpad.md<CR>', { desc = 'Open scratchpad' })

vim.keymap.set('n', '<leader>vr', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'Toggle relative number' })
