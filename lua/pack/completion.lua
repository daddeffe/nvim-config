vim.pack.add {
  -- Modern autocompletion
  'https://github.com/saghen/blink.cmp',

  -- Snippet engine and snippets
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',

  -- Neovim API completion
  'https://github.com/folke/lazydev.nvim',

  -- Command line completion
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-cmdline',
}

-- Configure lazydev for Lua LSP
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- Configure LuaSnip
local luasnip_ok, luasnip = pcall(require, 'luasnip')
if luasnip_ok then
  require('luasnip.loaders.from_vscode').lazy_load()
end

-- Configure blink.cmp
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
  blink.setup {
    keymap = {
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      preset = 'default',
    },

    appearance = {
      nerd_font_variant = 'normal',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    -- By default, we use the Lua implementation instead
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- Configure nvim-cmp for command line
vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdLineEnter' }, {
  callback = function()
    local cmp_ok, cmp = pcall(require, 'cmp')
    if cmp_ok then
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end
  end,
  once = true,
})