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
require('pack-manager').setup {}

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
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}