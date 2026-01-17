vim.pack.add({
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/nvim-lua/plenary.nvim',
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

  -- MCP
  'https://github.com/ravitemer/mcphub.nvim',

  -- Jupiter Notebook plugin
  'https://github.com/dccsillag/magma-nvim',

  -- Obsidian
  'https://github.com/nvim-lua/plenary.nvim',
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
-- vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
--   require('opencode').ask('@this: ', { submit = true })
-- end, { desc = 'Ask opencode' })
-- vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
--   require('opencode').select()
-- end, { desc = 'Execute opencode action…' })
-- vim.keymap.set({ 'n', 'x' }, 'ga', function()
--   require('opencode').prompt '@this'
-- end, { desc = 'Add to opencode' })
-- vim.keymap.set({ 'n', 't' }, '<C-.>', function()
--   require('opencode').toggle()
-- end, { desc = 'Toggle opencode' })
-- vim.keymap.set('n', '<S-C-u>', function()
--   require('opencode').command 'session.half.page.up'
-- end, { desc = 'opencode half page up' })
-- vim.keymap.set('n', '<S-C-d>', function()
--   require('opencode').command 'session.half.page.down'
-- end, { desc = 'opencode half page down' })

-- vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
--   if vim.fn.mode() == 'i' then
--     vim.cmd 'stopinsert'
--   end
--
--   local line = vim.api.nvim_get_current_line()
--   require('opencode').ask('@this Complete this code/comment: ' .. line, { submit = true })
-- end, { desc = 'OpenCode autocomplete from current line' })
--
-- vim.keymap.set({ 'n', 'x', 'i' }, '<C-S-k>', function()
--   if vim.fn.mode() == 'i' then
--     vim.cmd 'stopinsert'
--   end
--
--   require('opencode').ask('@this Continue writing this code naturally, providing only the next logical lines without explanation: ', { submit = true })
-- end, { desc = 'OpenCode smart completion' })

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

-- MCPHub configuration
require('mcphub').setup {
  config = vim.fn.expand '~/.config/mcphub/servers.json',
  port = 37373,
  shutdown_delay = 5 * 60 * 000,
  use_bundled_binary = false,
  mcp_request_timeout = 60000,
  global_env = {},
  workspace = {
    enabled = true,
    look_for = { '.mcphub/servers.json', '.vscode/mcp.json', '.cursor/mcp.json' },
    reload_on_dir_changed = true,
    port_range = { min = 40000, max = 41000 },
    get_port = nil,
  },
  auto_approve = false,
  auto_toggle_mcp_servers = true,
  extensions = {
    avante = {
      make_slash_commands = true,
    },
  },
  native_servers = {},
  builtin_tools = {
    edit_file = {
      parser = {
        track_issues = true,
        extract_inline_content = true,
      },
      locator = {
        fuzzy_threshold = 0.8,
        enable_fuzzy_matching = true,
      },
      ui = {
        go_to_origin_on_complete = true,
        keybindings = {
          accept = '.',
          reject = ',',
          next = 'n',
          prev = 'p',
          accept_all = 'ga',
          reject_all = 'gr',
        },
      },
    },
  },
  ui = {
    window = {
      width = 0.8,
      height = 0.8,
      align = 'center',
      relative = 'editor',
      zindex = 50,
      border = 'rounded',
    },
    wo = {
      winhl = 'Normal:MCPHubNormal,FloatBorder:MCPHubBorder',
    },
  },
  on_ready = function(hub) end,
  on_error = function(err) end,
  log = {
    level = vim.log.levels.WARN,
    to_file = false,
    file_path = nil,
    prefix = 'MCPHub',
  },
}

require('obsidian').setup {
  workspaces = {
    {
      name = 'def',
      path = '~/Obsidian',
    },
  },

  -- see below for full list of options 👇
}
