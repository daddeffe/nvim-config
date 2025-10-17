vim.pack.add {
  -- Store.nvim - Plugin store (already in tools.lua, adding config here)
  -- DEPENDENCY for store: markview.nvim
  'https://github.com/OXY2DEV/markview.nvim',

  -- Claude Code integration
  'https://github.com/coder/claudecode.nvim',

  -- DEPENDENCY for claudecode: snacks.nvim
  'https://github.com/folke/snacks.nvim',

  -- Vim Coach
  'https://github.com/shahshlok/vim-coach.nvim',

  -- Session management
  'https://github.com/jedrzejboczar/possession.nvim',

  -- Videre - Graph viewer
  'https://github.com/Owen-Dechow/videre.nvim',
  'https://github.com/Owen-Dechow/graph_view_yaml_parser',
  'https://github.com/Owen-Dechow/graph_view_toml_parser',
  'https://github.com/a-usr/xml2lua.nvim',
}

-- Load optional packages
vim.cmd.packadd 'markview.nvim'
vim.cmd.packadd 'claudecode.nvim'
vim.cmd.packadd 'snacks.nvim'
vim.cmd.packadd 'vim-coach.nvim'
vim.cmd.packadd 'possession.nvim'
vim.cmd.packadd 'videre.nvim'
vim.cmd.packadd 'graph_view_yaml_parser'
vim.cmd.packadd 'graph_view_toml_parser'
vim.cmd.packadd 'xml2lua.nvim'
--
-- Configure Store.nvim
vim.keymap.set('n', '<leader>S', '<cmd>Store<cr>', { desc = 'Open Plugin Store' })

-- Configure Claude Code
local claudecode_ok, claudecode = pcall(require, 'claudecode')
if claudecode_ok then
  claudecode.setup {}

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
      vim.keymap.set('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = true, desc = 'Add file' })
    end,
  })

  -- Diff management
  vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
  vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })
end

-- Configure Vim Coach
local coach_ok, coach = pcall(require, 'vim-coach')
if coach_ok then
  coach.setup()
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', { desc = 'Vim Coach' })
end

-- Configure Possession (session management)
local possession_ok, possession = pcall(require, 'possession')
if possession_ok then
  possession.setup {
    silent = false,
    load_silent = true,
    debug = false,
    logfile = false,
    prompt_no_cr = false,
    autosave = {
      current = false,
      cwd = false,
      tmp = false,
      tmp_name = 'tmp',
      on_load = true,
      on_quit = true,
    },
    autoload = false,
    commands = {
      save = 'PossessionSave',
      load = 'PossessionLoad',
      save_cwd = 'PossessionSaveCwd',
      load_cwd = 'PossessionLoadCwd',
      rename = 'PossessionRename',
      close = 'PossessionClose',
      delete = 'PossessionDelete',
      show = 'PossessionShow',
      pick = 'PossessionPick',
      list = 'PossessionList',
      list_cwd = 'PossessionListCwd',
      migrate = 'PossessionMigrate',
    },
    hooks = {
      before_save = function(name)
        return {}
      end,
      after_save = function(name, user_data, aborted) end,
      before_load = function(name, user_data)
        return user_data
      end,
      after_load = function(name, user_data) end,
    },
    plugins = {
      close_windows = {
        hooks = { 'before_save', 'before_load' },
        preserve_layout = true,
        match = {
          floating = true,
          buftype = {},
          filetype = {},
          custom = false,
        },
      },
      delete_hidden_buffers = {
        hooks = {
          'before_load',
          vim.o.sessionoptions:match 'buffer' and 'before_save',
        },
        force = false,
      },
      nvim_tree = true,
      neo_tree = true,
      symbols_outline = true,
      outline = true,
      tabby = true,
      dap = true,
      dapui = true,
      neotest = true,
      kulala = true,
      delete_buffers = false,
      stop_lsp_clients = false,
    },
    telescope = {
      previewer = {
        enabled = true,
        previewer = 'pretty',
        wrap_lines = true,
        include_empty_plugin_data = false,
        cwd_colors = {
          cwd = 'Comment',
          tab_cwd = { '#cc241d', '#b16286', '#d79921', '#689d6a', '#d65d0e', '#458588' },
        },
      },
      list = {
        default_action = 'load',
        mappings = {
          save = { n = '<c-x>', i = '<c-x>' },
          load = { n = '<c-v>', i = '<c-v>' },
          delete = { n = '<c-t>', i = '<c-t>' },
          rename = { n = '<c-r>', i = '<c-r>' },
          grep = { n = '<c-g>', i = '<c-g>' },
          find = { n = '<c-f>', i = '<c-f>' },
        },
      },
    },
  }
end

-- Configure Videre
local videre_ok, videre = pcall(require, 'videre')
if videre_ok then
  videre.setup {
    round_units = false,
  }
end
