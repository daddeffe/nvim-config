-- Core dependencies used by multiple plugins
vim.pack.add {
  -- Core library used by many plugins
  'https://github.com/nvim-lua/plenary.nvim',

  -- Icon support
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Mini.nvim - Collection of minimal, independent plugins
  'https://github.com/echasnovski/mini.nvim',

  -- Package manager UI
  'https://github.com/mplusp/pack-manager.nvim',

  -- Keymap helper
  'https://github.com/folke/which-key.nvim',
}

-- Setup pack-manager
require('pack-manager').setup()

-- Configure mini.nvim modules
require('mini.icons').setup()
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()

-- Configure mini.statusline
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

-- Custom statusline section for cursor location
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- Configure which-key
require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
    -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
    -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },

  -- Document existing key chains
  spec = {
    { '<leader>q', desc = 'Diagnostic [Q]uickfix' },
    { '<leader>x', desc = '[X] Delete Buffer' },
    { '<leader>w', desc = '[W]rite file' },
    { '<leader>Q', desc = '[Q]uit all' },
    { '<leader>zf', desc = 'Toggle LSP folding' },
    { '<leader>p', desc = 'Paste without overwrite yank', mode = 'x' },
    { '<leader>S', desc = 'Plugin Store' },
    { '<leader>a', desc = 'Add File to Harpoon' },
    { '<leader>?', desc = 'Vim Coach' },

    -- Search group
    { '<leader>s', group = '[S]earch' },
    { '<leader>sh', desc = '[S]earch [H]elp' },
    { '<leader>sk', desc = '[S]earch [K]eymaps' },
    { '<leader>sf', desc = '[S]earch [F]iles' },
    { '<leader>ss', desc = '[S]earch [S]elect Telescope' },
    { '<leader>sw', desc = '[S]earch current [W]ord' },
    { '<leader>sg', desc = '[S]earch by [G]rep' },
    { '<leader>sd', desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', desc = '[S]earch [R]esume' },
    { '<leader>s.', desc = '[S]earch Recent Files' },
    { '<leader>sb', desc = '[S]earch Buffers' },
    { '<leader>s/', desc = '[S]earch in current buffer' },
    { '<leader>sn', desc = '[S]earch Neovim config' },

    -- Toggle group
    { '<leader>t', group = '[T]oggle' },
    { '<leader>th', desc = 'Toggle inlay hints' },

    -- Git Hunk group
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>hs', desc = '[H]unk Stage', mode = { 'n', 'v' } },
    { '<leader>hr', desc = '[H]unk Reset', mode = { 'n', 'v' } },
    { '<leader>hS', desc = 'Stage buffer' },
    { '<leader>hR', desc = 'Reset buffer' },
    { '<leader>hp', desc = 'Preview hunk' },
    { '<leader>hb', desc = 'Blame line' },
    { '<leader>hd', desc = 'Diff this' },
    { '<leader>hD', desc = 'Diff this ~' },
    { '<leader>hQ', desc = 'Quickfix all hunks' },
    { '<leader>hq', desc = 'Quickfix hunks' },

    -- Claude group
    { '<leader>c', group = '[C]laude' },
    { '<leader>cc', desc = 'Toggle Claude' },
    { '<leader>cf', desc = 'Focus Claude' },
    { '<leader>cr', desc = 'Resume Claude' },
    { '<leader>cC', desc = 'Continue Claude' },
    { '<leader>cm', desc = 'Select Claude model' },
    { '<leader>cb', desc = 'Add current buffer' },
    { '<leader>cs', desc = 'Send to Claude', mode = 'v' },
    { '<leader>cS', desc = 'Add file tree' },
    { '<leader>ca', desc = 'Accept diff' },
    { '<leader>cd', desc = 'Deny diff' },
  },
}
