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

-- lazy treesitter fold: only enable foldexpr when a parser exists for the buffer
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ts_fold', { clear = true }),
  callback = function()
    local ft = vim.bo.ft
    if ft == '' then
      return
    end
    vim.treesitter.language.add(ft)
    local lang = vim.treesitter.language.get_lang(ft)
    if vim.fn.glob(vim.fn.stdpath 'data' .. '/site/parser/' .. lang .. '.so') ~= '' then
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
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
    if vim.bo.filetype ~= 'snacks_dashboard' then
      vim.opt_local.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Autocomand per entrare in modalita' insert entrando in un buffer terminale con focus obbligatorio
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('terminal_auto_insert', { clear = true }),
  pattern = 'term://*',
  callback = function(args)
    -- Focus obbligatorio e insert mode immediato per buffer terminali
    vim.schedule(function()
      -- Verifica che il buffer sia ancora valido e che la finestra corrente sia quella giusta
      if vim.api.nvim_buf_is_valid(args.buf) and vim.api.nvim_get_current_buf() == args.buf then
        vim.cmd 'startinsert'
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('terminal_no_spell', { clear = true }),
  pattern = 'term://*',
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('telescope_no_spell', { clear = true }),
  pattern = { 'Telescope', 'TelescopePrompt' },
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd('TextChangedI', {
  group = vim.api.nvim_create_augroup('prompt_cursor_fix', { clear = true }),
  pattern = '*',
  desc = 'Fix cursor one char back in prompt buffers after cross-window redraws',
  callback = function()
    if vim.bo.buftype ~= 'prompt' then
      return
    end
    local n1 = 1
    local n0 = n1 - n1
    local function fix()
      if vim.bo.buftype ~= 'prompt' then
        return
      end
      local cur = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
      local ln = vim.api.nvim_get_current_line()
      if cur[2] == #ln - n1 then
        vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { cur[1], #ln })
      end
    end
    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local line = vim.api.nvim_get_current_line()
    if cursor[2] == #line - n1 and cursor[2] > n0 then
      vim.schedule(fix)
      vim.defer_fn(fix, 120)
      vim.defer_fn(fix, 350)
      vim.defer_fn(fix, 650)
    end
  end,
})

local force_disable_ft = {
  'DiffviewFiles',
  'Oil',
  'Telescope',
  'TelescopePrompt',
  'Trouble',
  'alpha',
  'checkhealth',
  'dap-repl',
  'dashboard',
  'fugitive',
  'git',
  'help',
  'lazy',
  'mason',
  'md',
  'nofile',
  'oil',
  'prompt',
  'qf',
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'BufWritePost', 'InsertLeave', 'TermEnter', 'TextChanged' }, {
  callback = function()
    if not vim.bo.modifiable or vim.tbl_contains(force_disable_ft, vim.bo.ft) or vim.tbl_contains(force_disable_ft, vim.bo.buftype) then
      vim.opt.colorcolumn = '0'
      vim.o.list = false
    else
      vim.opt.colorcolumn = '85'
      vim.o.list = true
    end
  end,
})

-- Helm chart filetype detection: template files -> 'helm', values files -> 'yaml.helm-values'
-- Serve a far partire helm_ls sui file dentro un chart Helm (go-to-definition su .Values.*)
local function find_helm_chart_dir(dir)
  for _ = 1, 6 do
    if vim.fn.filereadable(dir .. '/Chart.yaml') == 1 or vim.fn.filereadable(dir .. '/Chart.yml') == 1 then
      return true
    end
    local parent = vim.fn.fnamemodify(dir, ':h')
    if parent == dir then
      return false
    end
    dir = parent
  end
  return false
end

local function path_has_component(path, component)
  for part in path:gmatch('[^/]+') do
    if part == component then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('helm_filetype', { clear = true }),
  desc = 'helm: filetype helm/yaml.helm-values per i file di un chart Helm',
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == '' or vim.bo[args.buf].buftype ~= '' then
      return
    end
    local dir = vim.fn.fnamemodify(file, ':h')
    if not find_helm_chart_dir(dir) then
      return
    end
    local base = vim.fn.fnamemodify(file, ':t')
    local ft
    if base == 'values.yaml' or base == 'values.yml' or base == 'values.schema.json' then
      ft = 'yaml.helm-values'
    elseif path_has_component(vim.fn.fnamemodify(file, ':p'), 'templates') or base:match('%.tpl$') or base == 'Chart.yaml' or base == 'Chart.yml' then
      ft = 'helm'
    end
    if ft and ft ~= vim.bo[args.buf].filetype then
      vim.bo[args.buf].filetype = ft
    end
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

    -- Cerca se il file è già aperto in un'altra finestra
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
