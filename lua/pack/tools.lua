vim.pack.add({
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/afonsofrancof/worktrees.nvim',
  'https://github.com/madmaxieee/unclash.nvim',

  -- Fuzzy finder
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',

  -- Text manipulation
  'https://github.com/tpope/vim-surround',

  -- Dev tools
  'https://github.com/XXiaoA/atone.nvim',
  'https://github.com/stevearc/dressing.nvim',
  'https://github.com/samharju/yeet.nvim',
  'https://github.com/lambdalisue/vim-suda',

  -- AI
  'https://github.com/NickvanDyke/opencode.nvim',
'https://github.com/ggml-org/llama.vim',

  -- Jupiter Notebook plugin
  'https://github.com/dccsillag/magma-nvim',

  -- Obsidian
  'https://github.com/epwalsh/obsidian.nvim',
}, {
  confirm = false,
  load = true,
})

-- Load optional packages
vim.cmd.packadd 'gitsigns.nvim'
vim.cmd.packadd 'telescope.nvim'
vim.cmd.packadd 'telescope-fzf-native.nvim'
vim.cmd.packadd 'telescope-ui-select.nvim'
vim.cmd.packadd 'vim-surround'

-- Configure Telescope with error handling
local telescope_ok, telescope = pcall(require, 'telescope')
if telescope_ok then
  telescope.setup { -- Fuzzy Finder (files, lsp, etc)
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`
    --
    defaults = {
      mappings = {
        i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      },
    },
    -- pickers = {}
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
    },
  }

  -- Enable Telescope extensions if they are installed
  pcall(telescope.load_extension, 'fzf')
  pcall(telescope.load_extension, 'ui-select')

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Slightly advanced example of overriding default behavior and theme
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
else
  vim.notify('Telescope plugin not loaded', vim.log.levels.WARN)
end

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[H]unk [S]tage' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = '[H]unk [S]tage (visual)' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = '[H]unk [R]eset (visual)' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[H]unk [S]tage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[H]unk [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
    map('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, { desc = '[H]unk [B]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = '[H]unk [D]iff' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '~'
    end, { desc = '[H]unk [D]iff ~' })
    map('n', '<leader>hQ', function()
      gitsigns.setqflist 'all'
    end, { desc = '[H]unk [Q]uickfix list (all)' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = '[H]unk [Q]uickfix list' })
    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = '[I]nner [H]unk' })
  end,
  signs_staged_enable = true,
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = true, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 300,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '  -- <author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
}

-- Vim-fugitive keymaps
vim.keymap.set('n', '<leader>gg', '<cmd>Git<CR>', { desc = '[G]it Status' })
vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit!<CR>', { desc = '[G]it [D]iff' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = '[G]it [C]ommit' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>', { desc = '[G]it [P]ush' })
vim.keymap.set('n', '<leader>gP', '<cmd>Git pull<CR>', { desc = '[G]it [P]ull' })

-- Atone.nvim configuration (undo tree)
require('atone').setup {
  layout = {
    direction = 'left',
    width = 0.35,
  },
  diff_cur_node = {
    enabled = true,
    split_percent = 0.3,
  },
  auto_attach = {
    enabled = true,
    excluded_ft = { 'oil' },
  },
  keymaps = {
    tree = {
      quit = { '<C-c>', 'q' },
      next_node = 'j',
      pre_node = 'k',
      undo_to = '<CR>',
      help = { '?', 'g?' },
    },
    auto_diff = {
      quit = { '<C-c>', 'q' },
      help = { '?', 'g?' },
    },
    help = {
      quit_help = { '<C-c>', 'q' },
    },
  },
  ui = {
    border = 'single',
  },
}

vim.keymap.set('n', '<leader>u', ':Atone toggle<CR>', { desc = '[U]ndo tree (Atone)' })

-- OpenCode.nvim configuration
vim.g.opencode_opts = {
  provider = {
    snacks = {
      win = {
        enter = true,
      },
    },
  },
}

vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
  require('opencode').ask('@this: ', { submit = true })
end, { desc = 'Ask opencode' })

vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
  require('opencode').select()
end, { desc = 'Execute opencode action…' })

-- 'ga' è già usato da mini.align — uso <leader>aa
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

-- <C-k> e <C-S-k> originali confliggono con window-move in binds.lua
-- (<C-S-k> = Move window upper). Uso <leader>ak / <leader>aK.
vim.keymap.set({ 'n', 'i' }, '<leader>ak', function()
  if vim.fn.mode() == 'i' then
    vim.cmd 'stopinsert'
  end
  local line = vim.api.nvim_get_current_line()
  require('opencode').ask('@this Complete this code/comment: ' .. line, { submit = true })
end, { desc = 'OpenCode autocomplete from current line' })

vim.keymap.set({ 'n', 'x', 'i' }, '<leader>aK', function()
  if vim.fn.mode() == 'i' then
    vim.cmd 'stopinsert'
  end
  require('opencode').ask('@this Continue writing this code naturally, providing only the next logical lines without explanation: ', { submit = true })
end, { desc = 'OpenCode smart completion' })

-- Unclash (merge conflict manager) — nessun setup, solo keymap
local unclash = require 'unclash'
vim.keymap.set('n', ']x', unclash.next_conflict, { desc = 'Next [C]onflict' })
vim.keymap.set('n', '[x', unclash.prev_conflict, { desc = 'Prev [C]onflict' })
vim.keymap.set('n', '<leader>co', unclash.open_merge_editor, { desc = '[C]onflict merge editor' })
vim.keymap.set('n', '<leader>cc', unclash.accept_current, { desc = '[C]onflict accept [C]urrent' })
vim.keymap.set('n', '<leader>ci', unclash.accept_incoming, { desc = '[C]onflict accept [I]ncoming' })
vim.keymap.set('n', '<leader>cb', unclash.accept_both, { desc = '[C]onflict accept [B]oth' })

-- Dressing.nvim — sostituisce vim.ui.input/select con UI migliore
require('dressing').setup {
  input = { enabled = true },
  select = { enabled = true, backend = { 'telescope', 'builtin' } },
}

-- ========================================================================
-- llama.vim — completion FIM locale via llama-server (llama.cpp)
-- ========================================================================
-- Config completa (la fusione Lua→Vim non eredita i default in alcune versioni).
vim.g.llama_config = {
  -- Server endpoints
  endpoint_fim = 'http://127.0.0.1:8012/infill',
  endpoint_inst = 'http://127.0.0.1:8012/v1/chat/completions',
  model_fim = '',
  model_inst = '',
  api_key = '',
  -- Sampling
  n_prefix = 256,
  n_suffix = 64,
  n_predict = 128,
  stop_strings = {},
  t_max_prompt_ms = 500,
  t_max_predict_ms = 1000,
  -- UX
  show_info = 2,
  auto_fim = false, -- solo on-demand
  max_line_suffix = 8,
  -- Cache & ring context
  max_cache_keys = 250,
  ring_n_chunks = 16,
  ring_chunk_size = 64,
  ring_scope = 1024,
  ring_update_ms = 1000,
  -- Keymaps (default del plugin)
  keymap_fim_trigger = '<leader>llf',
  keymap_fim_accept_full = '<Tab>',
  keymap_fim_accept_line = '<S-Tab>',
  keymap_fim_accept_word = '<leader>ll]',
  keymap_inst_trigger = '<leader>lli',
  keymap_inst_rerun = '<leader>llr',
  keymap_inst_continue = '<leader>llc',
  keymap_inst_accept = '<Tab>',
  keymap_inst_cancel = '<Esc>',
  keymap_debug_toggle = '<leader>lld',
  enable_at_startup = true,
}

-- Gestione llama-server come job di background.
-- Default model: path locale se scaricato a mano, altrimenti repo HF.
local llama_state = {
  job = nil,
  -- preferisco il file locale (più affidabile della cache hash di -hf)
  model = vim.fn.expand '~/.cache/llama.cpp/qwen2.5-coder-3b-q8_0.gguf',
  port = 8012,
}

local function llama_start(opts)
  if llama_state.job and vim.fn.jobwait({ llama_state.job }, 0)[1] == -1 then
    vim.notify('llama-server già in esecuzione (job ' .. llama_state.job .. ')', vim.log.levels.WARN)
    return
  end
  local model = (opts and opts.args ~= '' and opts.args) or llama_state.model
  -- Se l'arg sembra un path (inizia con /, ~, .) usa -m, altrimenti -hf
  local model_flag = '-hf'
  if model:match '^[/~%.]' then
    model_flag = '-m'
    model = vim.fn.expand(model)
    if vim.fn.filereadable(model) ~= 1 then
      vim.notify('Modello non trovato: ' .. model, vim.log.levels.ERROR)
      return
    end
  end
  local cmd = {
    'llama-server',
    model_flag,
    model,
    '--port',
    tostring(llama_state.port),
    '-ngl',
    '99',
    '-fa',
    'on',
    '--ubatch-size',
    '512',
    '-b',
    '1024',
    '-dt',
    '0.1',
    '--ctx-size',
    '0',
    '--cache-reuse',
    '256',
  }
  local stderr_buf = {}
  local stdout_buf = {}
  llama_state.job = vim.fn.jobstart(cmd, {
    detach = false,
    stderr_buffered = false,
    stdout_buffered = false,
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= '' then
          table.insert(stderr_buf, line)
        end
      end
    end,
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line ~= '' then
          table.insert(stdout_buf, line)
        end
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        local level = code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
        local last_err = ''
        if #stderr_buf > 0 then
          local from = math.max(1, #stderr_buf - 9)
          last_err = '\n--- stderr (ultime righe) ---\n' .. table.concat({ unpack(stderr_buf, from) }, '\n')
        elseif #stdout_buf > 0 then
          local from = math.max(1, #stdout_buf - 9)
          last_err = '\n--- stdout (ultime righe) ---\n' .. table.concat({ unpack(stdout_buf, from) }, '\n')
        end
        vim.notify('llama-server exit ' .. code .. last_err, level)
      end)
      llama_state.job = nil
    end,
  })
  if llama_state.job > 0 then
    vim.notify('llama-server avviato: ' .. model .. ' :' .. llama_state.port, vim.log.levels.INFO)
  else
    vim.notify('Errore avvio llama-server (job=' .. llama_state.job .. ')', vim.log.levels.ERROR)
    llama_state.job = nil
  end
end

local function llama_stop()
  if not llama_state.job then
    vim.notify('llama-server non attivo', vim.log.levels.WARN)
    return
  end
  vim.fn.jobstop(llama_state.job)
  llama_state.job = nil
end

local function llama_status()
  if llama_state.job and vim.fn.jobwait({ llama_state.job }, 0)[1] == -1 then
    vim.notify('llama-server attivo (job ' .. llama_state.job .. ', porta ' .. llama_state.port .. ')', vim.log.levels.INFO)
  else
    vim.notify('llama-server non attivo', vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command('LlamaStart', llama_start, { nargs = '?', desc = 'Avvia llama-server (arg opzionale: modello HF)' })
vim.api.nvim_create_user_command('LlamaStop', llama_stop, { desc = 'Ferma llama-server' })
vim.api.nvim_create_user_command('LlamaStatus', llama_status, { desc = 'Stato llama-server' })

-- Termina il server se nvim viene chiuso
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    if llama_state.job then
      pcall(vim.fn.jobstop, llama_state.job)
    end
  end,
})

-- Magma-nvim (Jupyter) — usa <leader>j come prefix
vim.keymap.set('n', '<leader>ji', '<cmd>MagmaInit<CR>', { desc = '[J]upyter [I]nit' })
vim.keymap.set('n', '<leader>jd', '<cmd>MagmaDeinit<CR>', { desc = '[J]upyter [D]einit' })
vim.keymap.set('n', '<leader>jr', '<cmd>MagmaEvaluateLine<CR>', { desc = '[J]upyter [R]un line' })
vim.keymap.set('x', '<leader>jr', ':<C-u>MagmaEvaluateVisual<CR>', { desc = '[J]upyter [R]un selection' })
vim.keymap.set('n', '<leader>jc', '<cmd>MagmaReevaluateCell<CR>', { desc = '[J]upyter [C]ell re-evaluate' })
vim.keymap.set('n', '<leader>jo', '<cmd>MagmaShowOutput<CR>', { desc = '[J]upyter [O]utput' })
vim.keymap.set('n', '<leader>jx', '<cmd>MagmaDelete<CR>', { desc = '[J]upyter delete cell' })

-- Lazygit configuration
require('telescope').load_extension 'lazygit'

-- Worktrees configuration
require('worktrees').setup {
  base_path = '../.tree',
  path_template = '{branch}',
  commands = {
    create = 'WorktreeCreate',
    delete = 'WorktreeDelete',
    switch = 'WorktreeSwitch',
  },
  mappings = {
    create = '<leader>hwc',
    delete = '<leader>hwd',
    switch = '<leader>hws',
  },
}

-- Yeet configuration
require('yeet').setup {
  yeet_and_run = true,
  interrupt_before_yeet = false,
  clear_before_yeet = true,
  warn_tmux_not_running = false,
  tmux_split_pane_command = "tmux split-window -dhPF  '#D'",
  retry_last_target_on_failure = false,
  hide_term_buffers = false,
  use_cache_file = true,
  cache_window_opts = function() end,
  custom_eval = nil,
}

-- Obsidian Setup
require('obsidian').setup {
  workspaces = {
    {
      name = 'def',
      path = '~/Obsidian',
    },
  },

  -- see below for full list of options 👇
}
