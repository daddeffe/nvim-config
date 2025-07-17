-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdLineEnter' },
    dependencies = {
      'hrsh7th/cmp-cmdline',
    },
    opts = function(_, opts)
      local cmp = require 'cmp'
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
    end,
  },
  {
    'tjdevries/present.nvim',
  },
  {
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      dependencies = {
        { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
        { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
      },
      build = 'make tiktoken', -- Only on MacOS or Linux
      opts = {
        -- See Configuration section for options
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },
  {
    'theprimeagen/harpoon',
    keys = {
      { '<leader>a', "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = 'Add File to Harpoon' },
      { '<C-e>', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = 'Harpoon UI' },
      { ']]', "<cmd>lua require('harpoon.ui').nav_next()<cr>", mode = { 'n', 'x' } },
      { '[[', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", mode = { 'n', 'x' } },
    },
    lazy = true,
  },
}
