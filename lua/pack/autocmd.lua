-- highlight yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  pattern = '*',
  desc = 'highlight selection on yank',
  callback = function()
    vim.highlight.on_yank { timeout = 200, visual = true }
  end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd 'normal! zz'
      end)
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'wincmd L',
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', {}),
  callback = function()
    vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
  end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('dotenv_ft', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function()
    vim.bo.filetype = 'dosini'
  end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('LspReferenceHighlight', { clear = true }),
  desc = 'Highlight references under cursor',
  callback = function()
    -- Only run if the cursor is not in insert mode
    if vim.fn.mode() ~= 'i' then
      local clients = vim.lsp.get_clients { bufnr = 0 }
      local supports_highlight = false
      for _, client in ipairs(clients) do
        if client.server_capabilities.documentHighlightProvider then
          supports_highlight = true
          break -- Found a supporting client, no need to check others
        end
      end

      -- 3. Proceed only if an LSP is active AND supports the feature
      if supports_highlight then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd('CursorMovedI', {
  group = 'LspReferenceHighlight',
  desc = 'Clear highlights when entering insert mode',
  callback = function()
    vim.lsp.buf.clear_references()
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
