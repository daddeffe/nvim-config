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

  'https://github.com/catppuccin/nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}, {
  confirm = false,
  load = true,
})

-- Setup pack-manager
require('pack-manager').setup()

require('catppuccin').setup {
  opts = {
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
  },
  flavour = 'mocha', -- latte, frappe, macchiato, mocha
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
  },
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { 'italic' }, -- Change the style of comments
    conditionals = { 'italic' },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = '',
    },
    lsp_trouble = true,
    lsp_saga = true,
    mason = true,
    telescope = true,
    which_key = false,

    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
}

--vim.notify(vim.inspect(require('lualine').get_config()))
-- setup must be called before loading
vim.cmd.colorscheme 'catppuccin'
-- ========================================================================
-- MINI.NVIM CONFIGURATION
-- ========================================================================

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
require('mini.misc').setup()

-- mini.clue - Keymap helper (replaces which-key)
require('mini.clue').setup {
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- Brackets
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
  },

  clues = {
    -- Enhance with builtin clues
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),

    -- Custom group descriptions
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
    { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
    { mode = 'n', keys = '<Leader>h', desc = '+Hunk/Git' },
    { mode = 'x', keys = '<Leader>h', desc = '+Hunk/Git' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>n', desc = '+Notifications' },
    { mode = 'n', keys = '<Leader>z', desc = '+Zen' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code/Claude' },
  },

  window = {
    delay = 300,
    config = {
      width = 'auto',
    },
  },
}

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
--statusline.section_location = function()
--  return '%2l:%-2v'
--end

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
    which_key = false, -- disabled, using mini.clue
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
