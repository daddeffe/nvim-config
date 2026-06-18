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

  -- Which-key
  'https://github.com/folke/which-key.nvim',
}, {
  confirm = false,
  load = true,
})

-- Setup pack-manager
require('pack-manager').setup()


-- ========================================================================
-- MINI.NVIM CONFIGURATION
-- ========================================================================
if true then
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
  vim.keymap.set('n', '<leader>tW', MiniTrailspace.trim, { desc = 'Trim [T]railing [W]hitespace' })
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
end

-- add Which-key plugin with no hard configs
require('which-key').setup()
-- ========================================================================
-- SNACKS.NVIM CONFIGURATION
-- ========================================================================
-- Snacks is a collection of QoL plugins for Neovim

require('snacks').setup {
  -- Performance & Core
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  -- UI: notifier abilitato, input disabilitato (usa dressing.nvim)
  dashboard = { enabled = false },
  notifier = {
    enabled = true,
    timeout = 3000,
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    margin = { top = 0, right = 1, bottom = 0 },
  },
  input = { enabled = false }, -- delegato a dressing.nvim
  rename = { enabled = true },
  bufdelete = { enabled = true },
  scratch = {
    enabled = true,
    name = 'Scratch',
    ft = 'markdown',
    icon = '󰠮',
    autowrite = false,
  },

  -- Disabilitati per conflitto con plugin esistenti
  explorer = { enabled = true }, -- usiamo oil.nvim
  picker = { enabled = false }, -- usiamo telescope
  indent = { enabled = true }, -- usiamo indent-blankline
  scope = { enabled = false }, -- richiederebbe treesitter
  statuscolumn = { enabled = false },
  git = { enabled = true },
  gitbrowse = { enabled = false },

  -- Word highlighting / terminale / toggles
  words = {
    enabled = true,
    modes = { 'n', 'i', 'c' }, -- modes to show references
    filter = function(buf) -- what buffers to enable `snacks.words`
      return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
  },
  terminal = {
    enabled = true,
    shell = vim.o.shell,
    win = { position = 'bottom', height = 0.4 },
  },

  -- Effetti visivi
  image = { enabled = true },
  scroll = { enabled = true },
  dim = {
    enabled = true,
    scope = { min_size = 5, max_size = 15, siblings = true },
  },
  animate = { enabled = true },
  zen = {
    enabled = true,
    toggles = { dim = true, git_signs = false, mini_diff = false, diagnostics = false },
    zoom = { width = 120, height = 0.9 },
  },
  toggle = { enabled = true, which_key = true },

  -- Dev tools
  debug = { enabled = true },
  profiler = { enabled = false },
}

-- ========================================================================
-- SNACKS KEYMAPS
-- ========================================================================
-- Add useful keymaps for snacks features
