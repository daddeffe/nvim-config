vim.pack.add {
  -- Plugin store
  'https://github.com/alex-popov-tech/store.nvim',

  -- File navigation
  'https://github.com/theprimeagen/harpoon',
  'https://github.com/stevearc/oil.nvim',

  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Fuzzy finder
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',

  -- Text manipulation
  'https://github.com/tpope/vim-surround',
}

-- Oil keymap (set before checking if Oil is loaded)
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Configure Oil with error handling
local oil_ok, oil = pcall(require, 'oil')
if oil_ok then
  oil.setup {
    default_file_explorer = true,
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },
    delete_to_trash = false,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = true,
    },
    constrain_cursor = 'editable',
    watch_for_changes = true,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent ', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    use_default_keymaps = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        local m = name:match '^%.'
        return m ~= nil
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
      natural_order = 'fast',
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
      highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        return nil
      end,
    },
    extra_scp_args = {},
    git = {
      add = function(path)
        return false
      end,
      mv = function(src_path, dest_path)
        return false
      end,
      rm = function(path)
        return false
      end,
    },
    float = {
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      -- preview_split: Split direction: "auto", "left", "right", "above", "below".
      preview_split = 'left',
      override = function(conf)
        return conf
      end,
    },
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = 'fast_scratch',
      disable_preview = function(filename)
        return false
      end,
      win_options = {},
    },
    confirmation = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      minimized_border = 'none',
      win_options = {
        winblend = 0,
      },
    },
    ssh = {
      border = 'rounded',
    },
    keymaps_help = {
      border = 'rounded',
    },
  }
else
  vim.notify('Oil plugin not loaded', vim.log.levels.WARN)
end
-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons

-- Configure Telescope with error handling
local telescope_ok, telescope = pcall(require, 'telescope')
if telescope_ok then
  telescope.setup { -- Fuzzy Finder (files, lsp, etc)
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!

    --     Here are the headline features of the previous releases; for details see the release notes.
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
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

-- require('gitsigns').setup {
--   on_attach = function(bufnr)
--     local gitsigns = require 'gitsigns'
--
--     local function map(mode, l, r, opts)
--       opts = opts or {}
--       opts.buffer = bufnr
--       vim.keymap.set(mode, l, r, opts)
--     end
--
--     -- Navigation
--     map('n', ']c', function()
--       if vim.wo.diff then
--         vim.cmd.normal { ']c', bang = true }
--       else
--         gitsigns.nav_hunk 'next'
--       end
--     end)
--
--     map('n', '[c', function()
--       if vim.wo.diff then
--         vim.cmd.normal { '[c', bang = true }
--       else
--         gitsigns.nav_hunk 'prev'
--       end
--     end)
--
--     -- Actions
--     map('n', '<leader>hs', gitsigns.stage_hunk)
--     map('n', '<leader>hr', gitsigns.reset_hunk)
--     map('v', '<leader>hs', function()
--       gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
--     end)
--     map('v', '<leader>hr', function()
--       gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
--     end)
--     map('n', '<leader>hS', gitsigns.stage_buffer)
--     map('n', '<leader>hR', gitsigns.reset_buffer)
--     map('n', '<leader>hp', gitsigns.preview_hunk)
--     map('n', '<leader>hi', gitsigns.preview_hunk_inline)
--     map('n', '<leader>hb', function()
--       gitsigns.blame_line { full = true }
--     end)
--     map('n', '<leader>hd', gitsigns.diffthis)
--     map('n', '<leader>hD', function()
--       gitsigns.diffthis '~'
--     end)
--     map('n', '<leader>hQ', function()
--       gitsigns.setqflist 'all'
--     end)
--     map('n', '<leader>hq', gitsigns.setqflist)
--     -- Toggles
--     map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
--     map('n', '<leader>tw', gitsigns.toggle_word_diff)
--     -- Text object
--     map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
--   end,
--   signs = {
--     add = { text = '┃' },
--     change = { text = '┃' },
--     delete = { text = '_' },
--     topdelete = { text = '‾' },
--     changedelete = { text = '~' },
--     untracked = { text = '┆' },
--   },
--   signs_staged = {
--     add = { text = '┃' },
--     change = { text = '┃' },
--     delete = { text = '_' },
--     topdelete = { text = '‾' },
--     changedelete = { text = '~' },
--     untracked = { text = '┆' },
--   },
--   signs_staged_enable = true,
--   signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
--   numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
--   linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
--   word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
--   watch_gitdir = {
--     follow_files = true,
--   },
--   auto_attach = true,
--   attach_to_untracked = false,
--   current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
--   current_line_blame_opts = {
--     virt_text = true,
--     virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
--     delay = 1000,
--     ignore_whitespace = false,
--     virt_text_priority = 100,
--     use_focus = true,
--   },
--   current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
--   sign_priority = 6,
--   update_debounce = 100,
--   status_formatter = nil, -- Use default
--   max_file_length = 40000, -- Disable if file is longer than this (in lines)
--   preview_config = {
--     -- Options passed to nvim_open_win
--     style = 'minimal',
--     relative = 'cursor',
--     row = 0,
--     col = 1,
--   },
-- }
