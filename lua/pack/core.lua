-- Core dependencies used by multiple plugins
vim.pack.add({
  -- Core library used by many plugins
  'https://github.com/nvim-lua/plenary.nvim',

  -- Icon support
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Mini.nvim & Snacks - Collection of minimal, independent plugins
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/folke/snacks.nvim',

  -- Package manager UI
  'https://github.com/mplusp/pack-manager.nvim',

  -- Keymap helper
  'https://github.com/folke/which-key.nvim',
}, {
  confirm = false,
})

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

-- mini.comment - Comment lines
require('mini.comment').setup()

-- mini.pairs - Autopairs (can replace nvim-autopairs)
require('mini.pairs').setup()

-- mini.bracketed - Navigate with brackets []
require('mini.bracketed').setup()

-- mini.bufremove - Delete buffers without closing windows
require('mini.bufremove').setup()

-- mini.cursorword - Highlight word under cursor
require('mini.cursorword').setup()

-- mini.hipatterns - Highlight patterns in text (colors, todos, etc)
require('mini.hipatterns').setup {
  highlighters = {
    -- Highlight hex colors
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
}

-- mini.indentscope - Visualize indent scope
require('mini.indentscope').setup {
  symbol = '│',
  options = { try_as_border = true },
}

-- mini.jump - Jump to next/previous single character
require('mini.jump').setup()

-- mini.jump2d - Jump to any visible location
require('mini.jump2d').setup()

-- mini.trailspace - Highlight and remove trailing whitespace
require('mini.trailspace').setup()

-- mini.notify - Notification manager
require('mini.notify').setup()

-- mini.git - Git integration
require('mini.git').setup()

-- mini.diff - Visualize diff hunks
require('mini.diff').setup()

-- mini.move - Move selected lines/blocks
require('mini.move').setup()

-- mini.operators - Text operators (evaluate, exchange, multiply, replace, sort)
require('mini.operators').setup()

-- mini.align - Align text interactively
require('mini.align').setup()

-- mini.visits - Track and reuse file system visits
require('mini.visits').setup()

-- mini.misc - Miscellaneous useful functions
require('mini.misc').setup()
-- Make mini.misc functions globally available
MiniMisc = require 'mini.misc'

--configure snacks
require('snacks').setup {
  -- Performance & Core
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  -- UI & Visual
  dashboard = {
    enabled = true,

    width = 60,
    row = nil, -- dashboard position. nil for center
    col = nil, -- dashboard position. nil for center
    pane_gap = 4, -- empty columns between vertical panes
    autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
    -- These settings are used by some built-in sections
    preset = {
      -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
      ---@type fun(cmd:string, opts:table)|nil
      pick = nil,
      -- Used by the `keys` section to show keymaps.
      -- Set your custom keymaps here.
      -- When using a function, the `items` argument are the default keymaps.
      ---@type snacks.dashboard.Item[]
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
        { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
      -- Used by the `header` section
      header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    },
    -- item field formatters
    formats = {
      icon = function(item)
        if item.file and item.icon == 'file' or item.icon == 'directory' then
          return Snacks.dashboard.icon(item.file, item.icon)
        end
        return { item.icon, width = 2, hl = 'icon' }
      end,
      footer = { '%s', align = 'center' },
      header = { '%s', align = 'center' },
      file = function(item, ctx)
        local fname = vim.fn.fnamemodify(item.file, ':~')
        fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
        if #fname > ctx.width then
          local dir = vim.fn.fnamemodify(fname, ':h')
          local file = vim.fn.fnamemodify(fname, ':t')
          if dir and file then
            file = file:sub(-(ctx.width - #dir - 2))
            fname = dir .. '/…' .. file
          end
        end
        local dir, file = fname:match '^(.*)/(.+)$'
        return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
      end,
    },
    sections = {
      { section = 'header' },
      {
        --pane = 2,

        icon = ' ',
        title = 'Git Status',
        section = 'terminal',
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = 'git status --short --branch --renames',
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
      { section = 'keys', gap = 1, padding = 1 },
      --{ section = 'startup' },
    },
  },

  -- File & Navigation
  explorer = { enabled = true },
  picker = { enabled = true },

  -- Editing & Code
  indent = { enabled = true },
  scope = { enabled = true },
  words = { enabled = true },

  -- Git
  git = { enabled = true },
  gitbrowse = { enabled = true },

  -- Utilities
  input = { enabled = true },
  notifier = { enabled = true },
  rename = { enabled = true },
  bufdelete = { enabled = true },
  scratch = { enabled = true },
  terminal = { enabled = true },
  toggle = { enabled = true },

  -- Visual enhancements
  image = { enabled = true },
  scroll = { enabled = true },
  dim = { enabled = true },
  animate = { enabled = true }, -- Disabled by default for performance
  zen = { enabled = true },
  statuscolumn = { enabled = false }, -- Disabled, might conflict with custom settings

  -- Development
  debug = { enabled = true },
  profiler = { enabled = false }, -- Disabled by default, enable when needed
}

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
