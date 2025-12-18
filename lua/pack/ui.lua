vim.pack.add({
  'https://github.com/catppuccin/nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Noice - Better UI for messages, cmdline, and popupmenu
  'https://github.com/folke/noice.nvim',

  -- DEPENDENCY for noice: nui.nvim
  'https://github.com/MunifTanjim/nui.nvim',
}, {
  confirm = false,
})

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
    which_key = true,

    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
}

--vim.notify(vim.inspect(require('lualine').get_config()))
-- setup must be called before loading
vim.cmd.colorscheme 'catppuccin'

-- Configure Noice
require('noice').setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- Notification settings
  notify = {
    enabled = false,
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
  },
}
