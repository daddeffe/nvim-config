vim.pack.add({
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/alex-popov-tech/store.nvim',

  -- Text manipulation
  'https://github.com/tpope/vim-surround',

  -- AutoReload file
  'https://github.com/manuuurino/autoread.nvim',

  -- Vim Coach
  'https://github.com/shahshlok/vim-coach.nvim',
}, {
  confirm = false,
})

-- Load optional packages
vim.cmd.packadd 'markview.nvim'
vim.cmd.packadd 'snacks.nvim'
vim.cmd.packadd 'vim-coach.nvim'
vim.cmd.packadd 'store.nvim'
--

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
