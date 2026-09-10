local lazy = require 'pack.lazy'

local function load_neo_tree()
  require('neo-tree').setup {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    default_component_configs = {
      indent = { padding = 1, with_expanders = true },
      git_status = { symbols = { added = '󰘓', modified = '󰘓', deleted = '󰘓', renamed = '󰘓' } },
    },
    sources = {
      'filesystem',
      'buffers',
      'git_status',
      'document_symbols',
    },
    source_selector = {
      winbar = true,
      content_layout = 'center',
      sources = {
        { source = 'filesystem', display_name = ' 󰉓 Files ' },
        { source = 'buffers', display_name = ' 󰈙 Buffers ' },
        { source = 'git_status', display_name = ' 󰊢 Git ' },
        { source = 'document_symbols', display_name = ' 󰌨 Symbols ' },
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show_by_pattern = { '.git' },
      },
      window = {
        mappings = {
          ['\\'] = 'toggle_hidden',
        },
      },
    },
  }
end

lazy.by_cmd('neo-tree.nvim', 'Neotree', load_neo_tree, 'Neotree')
lazy.by_key('neo-tree.nvim', 'n', '<leader>E', load_neo_tree, function() vim.cmd 'Neotree' end, { desc = 'Neo-tree filesystem' })
lazy.by_key('neo-tree.nvim', 'n', '<leader>lD', load_neo_tree, function() vim.cmd 'Neotree document_symbols' end, { desc = 'Neo-tree document symbols' })