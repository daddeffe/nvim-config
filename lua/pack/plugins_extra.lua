vim.pack.add({
  -- Store.nvim - Plugin store (already in tools.lua, adding config here)
  -- DEPENDENCY for store: markview.nvim
  'https://github.com/OXY2DEV/markview.nvim',

  -- Claude Code integration
  'https://github.com/coder/claudecode.nvim',

  -- DEPENDENCY for claudecode: snacks.nvim

  -- Vim Coach
  'https://github.com/shahshlok/vim-coach.nvim',
}, {
  confirm = false,
})

-- Load optional packages
vim.cmd.packadd 'markview.nvim'
vim.cmd.packadd 'claudecode.nvim'
vim.cmd.packadd 'snacks.nvim'
vim.cmd.packadd 'vim-coach.nvim'
--
-- Configure Store.nvim
vim.keymap.set('n', '<leader>S', '<cmd>Store<cr>', { desc = 'Open Plugin Store' })

-- Configure Claude Code
local claudecode_ok, claudecode = pcall(require, 'claudecode')
if claudecode_ok then
  claudecode.setup {
    terminal_cmd = '~/.claude/local/claude', -- Point to local installation
    diff_opts = {
      layout = 'vertical',
      open_in_new_tab = true, -- Open diff in a new tab (false = use current tab)
      keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
      hide_terminal_in_new_tab = false, -- If true and opening in a new tab, do not show Claude terminal there
      on_new_file_reject = 'close_window', -- "keep_empty" leaves an empty buffer; "close_window" closes the placeholder split
    },
  }

  -- Claude Code keymaps
  -- Note: <leader>a is used as a prefix for Claude Code commands
  vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
  vim.keymap.set('n', '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
  vim.keymap.set('n', '<leader>cr', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude' })
  vim.keymap.set('n', '<leader>cC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
  vim.keymap.set('n', '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })
  vim.keymap.set('n', '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer' })
  vim.keymap.set('v', '<leader>cs', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })

  -- Special keymap for file trees
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'NvimTree', 'neo-tree', 'oil', 'minifiles' },
    callback = function()
      vim.keymap.set('n', '<leader>cS', '<cmd>ClaudeCodeTreeAdd<cr>', {
        buffer = true,
        desc = 'Add file',
      })
    end,
  })

  -- Diff management
  vim.keymap.set('n', '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
  vim.keymap.set('n', '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })
end

-- Autocomando che intercetta apertura in modalità diff
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    -- Se non siamo in modalità diff, esci
    if not vim.wo.diff then
      return
    end

    local buf = args.buf
    local file = vim.api.nvim_buf_get_name(buf)
    if file == '' then
      return
    end

    -- Cerca se il file è già aperto in un’altra finestra
    local target_buf = vim.fn.bufnr(file, false)
    local target_win = vim.fn.bufwinid(target_buf)

    if target_win ~= -1 and target_win ~= vim.api.nvim_get_current_win() then
      -- Il buffer è già visibile da un'altra parte
      -- Rimuovi diff dallo split corrente per non sovrapporre
      vim.cmd 'diffoff'

      -- Sposta la modalità diff nella finestra originale
      local current_win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(target_win)
      vim.cmd 'diffthis'
      vim.api.nvim_set_current_win(current_win)

      -- Notifica (opzionale)
      vim.notify('Diff riassegnato alla finestra già aperta per: ' .. file, vim.log.levels.INFO)
    else
      -- Se non esiste, crea diff verticale
      vim.cmd('vertical diffsplit ' .. vim.fn.fnameescape(file))
    end
  end,
})

-- Autocomand per entrare in modalita' insert entrando in un buffer terminale
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  group = group,
  pattern = 'term://*',
  callback = function()
    vim.cmd 'startinsert'
  end,
})

-- Configure Vim Coach
local coach_ok, coach = pcall(require, 'vim-coach')
if coach_ok then
  coach.setup()
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', { desc = 'Vim Coach' })
end
