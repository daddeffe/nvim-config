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

-- ========================================================================
-- MINI.NVIM CONFIGURATION
-- ========================================================================

-- mini.icons - Icon support (used by other plugins)
require('mini.icons').setup()

-- mini.ai - Advanced text objects
require('mini.ai').setup {
  -- Number of lines to search for text objects
  n_lines = 500,
  -- Custom text objects can be added here
  custom_textobjects = nil,
}

-- mini.surround - Add/delete/replace surroundings (pairs)
require('mini.surround').setup {
  -- Add surrounding with 'sa' (e.g., 'saiw)' to surround word with parentheses)
  -- Delete surrounding with 'sd' (e.g., 'sd"' to delete surrounding quotes)
  -- Replace surrounding with 'sr' (e.g., 'sr)"' to replace () with "")
  mappings = {
    add = 'sa', -- Add surrounding in Normal and Visual modes
    delete = 'sd', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'sr', -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`
  },
}

-- mini.statusline - Minimal statusline
local statusline = require 'mini.statusline'
statusline.setup {
  use_icons = vim.g.have_nerd_font,
  -- Content configuration
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = MiniStatusline.section_diff { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local location = MiniStatusline.section_location { trunc_width = 75 }
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = mode_hl, strings = { search, location } },
        { hl = 'MiniStatuslineFileinfo', strings = { lsp, fileinfo } },
      }
    end,
    inactive = nil, -- Use default inactive content
  },
  set_vim_settings = true,
}

-- Custom statusline section for cursor location
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- mini.comment - Smart and powerful comment plugin
require('mini.comment').setup {
  -- Options which control module behavior
  options = {
    -- Function to compute custom comment string
    custom_commentstring = nil,
    -- Whether to ignore blank lines
    ignore_blank_line = false,
    -- Whether to recognize as comment only lines without indent
    start_of_line = false,
    -- Whether to force single space inner padding for comment parts
    pad_comment_parts = true,
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',
    -- Toggle comment on current line
    comment_line = 'gcc',
    -- Toggle comment on visual selection
    comment_visual = 'gc',
    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    textobject = 'gc',
  },
}

-- mini.pairs - Autopairs for brackets, quotes, etc.
require('mini.pairs').setup {
  -- Global mappings. Each right hand side should be a pair information, a
  -- table with at least these fields (see more in |MiniPairs.map|):
  -- - <action> - one of 'open', 'close', 'closeopen'.
  -- - <pair> - two character string for pair to be used.
  -- By default, pairs are: (), [], {}, '', "", ``
  modes = { insert = true, command = false, terminal = false },
  -- Skip autopair when next character is one of these
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  -- Skip autopair when the cursor is inside these treesitter nodes
  skip_ts = { 'string' },
  -- Skip autopair when next character is closing pair and there are more closing pairs than opening pairs
  skip_unbalanced = true,
  -- Better deal with markdown code blocks
  markdown = true,
}

-- mini.bracketed - Navigate with []/[] brackets (buffers, comments, diagnostics, etc.)
require('mini.bracketed').setup {
  -- Bracket types:
  -- b - buffer, c - comment, d - diagnostic, f - file, i - indent, j - jump,
  -- l - location, o - oldfile, q - quickfix, t - treesitter, u - undo, w - window, y - yank
  buffer = { suffix = 'b', options = {} },
  comment = { suffix = 'c', options = {} },
  conflict = { suffix = 'x', options = {} },
  diagnostic = { suffix = 'd', options = {} },
  file = { suffix = 'f', options = {} },
  indent = { suffix = 'i', options = {} },
  jump = { suffix = 'j', options = {} },
  location = { suffix = 'l', options = {} },
  oldfile = { suffix = 'o', options = {} },
  quickfix = { suffix = 'q', options = {} },
  treesitter = { suffix = 't', options = {} },
  undo = { suffix = 'u', options = {} },
  window = { suffix = 'w', options = {} },
  yank = { suffix = 'y', options = {} },
}

-- mini.hipatterns - Highlight patterns in text (colors, todos, etc)
require('mini.hipatterns').setup {
  highlighters = {
    -- Highlight hex colors
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    -- Add TODO/FIXME/NOTE highlighting
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
  },
}

-- mini.jump - Jump to next/previous single character
require('mini.jump').setup()

-- mini.jump2d - Jump to any visible location
require('mini.jump2d').setup {
  -- Function which returns label characters
  labels = 'abcdefghijklmnopqrstuvwxyz',
  -- mappings for jumping to a label
  mappings = {
    start_jumping = '<Leader><CR>',
  },
}

-- mini.trailspace - Highlight and remove trailing whitespace
require('mini.trailspace').setup()
-- Keymap to remove trailing whitespace (add to your keymaps file)
vim.keymap.set('n', '<leader>tw', MiniTrailspace.trim, { desc = 'Trim [T]railing [W]hitespace' })
vim.keymap.set('n', '<leader>tl', MiniTrailspace.trim_last_lines, { desc = 'Trim [T]railing [L]ines' })

-- mini.move - Move selected lines/blocks
require('mini.move').setup {
  -- Move selection in Visual mode. Defaults are Alt + hjkl
  mappings = {
    -- Move visual selection in Visual mode
    left = '<M-h>',
    right = '<M-l>',
    down = '<M-j>',
    up = '<M-k>',
    -- Move current line in Normal mode
    line_left = '<M-h>',
    line_right = '<M-l>',
    line_down = '<M-j>',
    line_up = '<M-k>',
  },
}

-- mini.operators - Text operators (evaluate, exchange, multiply, replace, sort)
require('mini.operators').setup {
  -- Evaluate text and replace with output
  evaluate = {
    prefix = 'g=',
  },
  -- Exchange text regions
  exchange = {
    prefix = 'gx',
  },
  -- Multiply (duplicate) text
  multiply = {
    prefix = 'gm',
  },
  -- Replace text with register
  replace = {
    prefix = 'gr',
  },
  -- Sort text
  sort = {
    prefix = 'gs',
  },
}

-- mini.align - Align text interactively
require('mini.align').setup {
  -- Main mappings
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },
}

-- mini.visits - Track and reuse file system visits
require('mini.visits').setup {
  -- How visits are tracked
  list = {
    -- Predefined filter for commonly visited files
    filter = nil,
    -- Sort function
    sort = nil,
  },
  -- Whether to disable showing non-error feedback
  silent = false,
  -- Store tracking data in this file
  store = {
    autowrite = true,
    --normalize = true,
    path = vim.fn.stdpath 'data' .. '/mini-visits-index',
  },
}

-- mini.misc - Miscellaneous useful functions
require('mini.misc').setup {
  -- Collect various useful functions
  make_global = {
    'put',
    'put_text',
    'stat_summary',
    'bench_time',
  },
}
-- Make mini.misc functions globally available
MiniMisc = require 'mini.misc'

-- ========================================================================
-- DISABLED MINI PLUGINS (available but not currently used)
-- ========================================================================
-- Uncomment if needed:

-- mini.notify - Notification manager (using snacks.notifier instead)
-- require('mini.notify').setup()

-- mini.git - Git integration (using dedicated git plugin)
-- require('mini.git').setup()

-- mini.diff - Visualize diff hunks (using dedicated git plugin)
-- require('mini.diff').setup()

-- mini.cursorword - Highlight word under cursor (using snacks.words instead)
-- require('mini.cursorword').setup()

-- mini.bufremove - Delete buffers (using snacks.bufdelete instead)
-- require('mini.bufremove').setup()

-- mini.indentscope - Visualize indent scope (using snacks.scope instead)
-- require('mini.indentscope').setup {
--   symbol = '│',
--   options = { try_as_border = true },
-- }

-- ========================================================================
-- SNACKS.NVIM CONFIGURATION
-- ========================================================================
-- Snacks is a collection of QoL plugins for Neovim

require('snacks').setup {
  -- Performance & Core
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  -- UI & Visual
  dashboard = { enabled = false },

  -- File & Navigation
  explorer = { enabled = true },
  picker = {
    enabled = true,
    -- Default picker to use (auto-detects available pickers)
    -- Can be 'telescope', 'fzf-lua', or 'mini.pick'
    picker = nil,
    -- Key mappings for the picker
    win = {
      input = {
        keys = {
          ['<C-j>'] = { 'list_down', mode = { 'i', 'n' } },
          ['<C-k>'] = { 'list_up', mode = { 'i', 'n' } },
        },
      },
    },
  },

  -- Editing & Code
  indent = {
    enabled = true,
    -- Disable animation to prevent visual artifacts when switching windows
    animate = {
      enabled = false,
    },
    -- Filter to show indent guides only in code buffers
    filter = function(buf, win)
      local buftype = vim.bo[buf].buftype
      local filetype = vim.bo[buf].filetype

      -- Exclude special buffer types
      if buftype ~= '' and buftype ~= 'acwrite' then
        return false
      end

      -- Exclude specific filetypes
      local excluded_filetypes = {
        'help',
        'man',
        'markdown',
        'text',
        'txt',
        'dashboard',
        'alpha',
        'starter',
        'NvimTree',
        'neo-tree',
        'oil',
        'Trouble',
        'qf',
        'help',
        'fugitive',
        'git',
      }

      for _, ft in ipairs(excluded_filetypes) do
        if filetype == ft then
          return false
        end
      end

      -- Show indent guides for actual code files
      return true
    end,
  },
  scope = {
    enabled = true,
    -- Enable tree-sitter scope detection
    treesitter = { enabled = true },
    -- Disable animation to prevent visual artifacts
    animate = {
      enabled = false,
    },
  },
  words = {
    enabled = true,
    -- Debounce time in ms for highlighting word references
    debounce = 200,
  },

  -- Git (disabled - using dedicated git plugin)
  git = { enabled = false },
  gitbrowse = { enabled = false },

  -- Utilities
  input = { enabled = true },
  notifier = {
    enabled = true,
    -- Timeout for notifications in ms
    timeout = 3000,
    -- Width of notification window
    width = { min = 40, max = 0.4 },
    -- Height of notification window
    height = { min = 1, max = 0.6 },
    -- Margin from edges
    margin = { top = 0, right = 1, bottom = 0 },
  },
  rename = { enabled = true },
  bufdelete = {
    enabled = true,
    -- Delete buffer without closing window
  },
  scratch = {
    enabled = true,
    -- Scratch buffer configuration
    name = 'Scratch',
    ft = 'markdown', -- default filetype
    icon = '󰠮',
    -- Auto-create scratch buffer at startup
    autowrite = false,
  },
  terminal = {
    enabled = true,
    -- Terminal configuration
    shell = vim.o.shell,
    win = {
      position = 'bottom',
      height = 0.4,
    },
  },
  toggle = {
    enabled = true,
    -- Built-in toggle mappings
    which_key = true, -- integrate with which-key
  },

  -- Visual enhancements
  image = { enabled = true },
  scroll = {
    enabled = false,
    -- Smooth scrolling animation
  },
  dim = {
    enabled = true,
    -- Dim inactive windows
    scope = {
      min_size = 5,
      max_size = 25,
      siblings = true,
    },
  },
  animate = {
    enabled = true,
  },
  zen = {
    enabled = true,
    -- Zen mode configuration
    toggles = {
      dim = true,
      git_signs = false,
      mini_diff = false,
      diagnostics = false,
    },
    zoom = {
      width = 120,
      height = 0.9,
    },
  },
  statuscolumn = { enabled = false }, -- Disabled, might conflict with custom settings

  -- Development
  debug = { enabled = true },
  profiler = { enabled = false }, -- Disabled by default, enable when needed
}

-- ========================================================================
-- SNACKS KEYMAPS
-- ========================================================================
-- Add useful keymaps for snacks features
vim.keymap.set('n', '<leader><Tab>', function()
  Snacks.explorer()
end, { desc = 'Explorer' })
vim.keymap.set('n', '<leader>bw', ':w<CR>', {
  desc = '[B]uffer [W]elete',
  silent = true,
})
vim.keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bs', function()
  Snacks.scratch()
end, { desc = '[B]uffer [S]cratch' })
vim.keymap.set('n', '<leader>bS', function()
  Snacks.scratch.select()
end, { desc = '[B]uffer [S]cratch Select' })

vim.keymap.set('n', '<leader>nt', function()
  Snacks.notifier.show_history()
end, { desc = '[N]otification His[t]ory' })

vim.keymap.set('n', '<leader>ze', function()
  Snacks.zen()
end, { desc = '[Z]en Mode' })
vim.keymap.set('n', '<leader>Z', function()
  Snacks.zen.zoom()
end, { desc = '[Z]oom Window' })

vim.keymap.set({ 'n', 't' }, '<C-\\>', function()
  Snacks.terminal()
end, { desc = 'Toggle Terminal' })

vim.keymap.set('n', '<leader>dim', function()
  Snacks.toggle.dim():toggle()
end, { desc = 'Toggle [Dim] Inactive Windows' })
vim.keymap.set('n', '<leader>br', function()
  Snacks.rename.rename_file()
end, { desc = '[B]uffer [R]ename File' })

-- ========================================================================
-- WHICH-KEY CONFIGURATION
-- ========================================================================
-- Which-key is a popup that displays available keybindings

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
    { '<leader>zf', desc = 'Toggle LSP folding' },
    { '<leader>p', desc = 'Paste without overwrite yank', mode = 'x' },
    { '<leader>S', desc = 'Plugin Store' },
    { '<leader>a', desc = 'Add File to Harpoon' },
    { '<leader>?', desc = 'Vim Coach' },

    -- Buffer group
    { '<leader>b', group = '[B]uffer' },
    { '<leader>bd', desc = '[B]uffer [D]elete' },
    { '<leader>bs', desc = '[B]uffer [S]cratch' },
    { '<leader>bS', desc = '[B]uffer [S]cratch Select' },

    -- Notification group
    { '<leader>n', group = '[N]otifications' },
    { '<leader>nt', desc = '[N]otification His[t]ory' },

    -- Zen/Zoom group
    { '<leader>z', desc = '[Z]en Mode' },
    { '<leader>Z', desc = '[Z]oom Window' },

    -- Buffer rename
    { '<leader>br', desc = '[B]uffer [R]ename File' },

    -- Trailing whitespace
    { '<leader>tw', desc = 'Trim [T]railing [W]hitespace' },
    { '<leader>tl', desc = 'Trim [T]railing [L]ines' },

    -- Dim toggle
    { '<leader>dim', desc = 'Toggle [Dim] Inactive Windows' },

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

--[[
✅ Plugin Git Disabilitati

  - mini.git - disabilitato e commentato
  - mini.diff - disabilitato e commentato
  - snacks.git - impostato enabled = false
  - snacks.gitbrowse - impostato enabled = false
  - Sezione Git Status nel dashboard - commentata

  🔄 Sovrapposizioni Risolte

  Mantenuti in Snacks (disabilitati i duplicati in Mini):
  - snacks.notifier al posto di mini.notify
  - snacks.bufdelete al posto di mini.bufremove
  - snacks.words al posto di mini.cursorword
  - snacks.indent + scope al posto di mini.indentscope

  ⚙️ Configurazioni Base Aggiunte

  Mini.nvim:
  - mini.ai - text objects avanzati con n_lines
  configurabile
  - mini.surround - mappings documentati
  (sa/sd/sr/sf/sF/sh)
  - mini.statusline - con sezione location personalizzata
  - mini.comment - opzioni dettagliate per commenti
  - mini.pairs - autopairs con skip intelligente
  - mini.bracketed - tutti i suffix documentati
  (b/c/d/f/i/j/l/o/q/t/u/w/y)
  - mini.hipatterns - hex colors + TODO/FIXME/NOTE/HACK
  highlighting
  - mini.jump2d - labels e mappings configurati
  - mini.trailspace - con keymaps per trim
  - mini.move - mappings Alt+hjkl documentati
  - mini.operators - prefissi chiari (g=/gx/gm/gr/gs)
  - mini.align - mappings ga/gA
  - mini.visits - store configurato
  - mini.misc - funzioni globali abilitate

  Snacks.nvim:
  - picker - navigazione con Ctrl+j/k
  - indent - animazioni configurate (20ms)
  - scope - tree-sitter abilitato
  - words - debounce 200ms
  - notifier - timeout, dimensioni e margini
  - bufdelete - documentato
  - scratch - markdown default, autowrite off
  - terminal - posizione bottom, height 0.4
  - toggle - integrazione which-key
  - scroll - animazione 100ms linear
  - dim - scope siblings configurato
  - animate - 20ms, 60 FPS
  - zen - toggles e zoom configurati

  🎹 Keymaps Aggiunti

  - <leader>bd - Buffer Delete
  - <leader>bs - Buffer Scratch
  - <leader>bS - Buffer Scratch Select
  - <leader>br - Buffer Rename File
  - <leader>nt - Notification History
  - <leader>z - Zen Mode
  - <leader>Z - Zoom Window
  - <C-\> - Toggle Terminal (normal e terminal mode)
  - <leader>dim - Toggle Dim
  - <leader>tw - Trim Trailing Whitespace
  - <leader>tl - Trim Trailing Lines

  📝 Organizzazione File

  - Sezioni chiaramente separate con headers ASCII
  - Commenti esplicativi per ogni plugin
  - Plugin disabilitati raccolti in una sezione dedicata
  - Which-key con tutte le descrizioni aggiornate

-]]
