vim.pack.add({
  -- VSCode like winbar
  'https://github.com/utilyre/barbecue.nvim',
  'https://github.com/SmiteshP/nvim-navic',

  -- File navigation
  'https://github.com/theprimeagen/harpoon',
  'https://github.com/stevearc/oil.nvim',

  -- Macro management
  'https://github.com/sahilsehwag/macrobank.nvim',
}, {
  confirm = false,
})

-- Configure barbecue
require('barbecue').setup {
  -- Configuration options can be added here
}

-- Configure macrobank
require('macrobank').setup()

-- Oil keymap (set before checking if Oil is loaded)
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Configure Oil with error handling
local oil_ok, oil = pcall(require, 'oil')
if oil_ok then
  oil.setup {
    default_file_explorer = true,
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },
    delete_to_trash = false,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = true,
    },
    constrain_cursor = 'editable',
    watch_for_changes = true,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      --['-'] = { 'actions.parent ', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    use_default_keymaps = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        local m = name:match '^%.'
        return m ~= nil
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
      natural_order = 'fast',
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
      highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        return nil
      end,
    },
    extra_scp_args = {},
    git = {
      add = function(path)
        return false
      end,
      mv = function(src_path, dest_path)
        return false
      end,
      rm = function(path)
        return false
      end,
    },
    float = {
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      -- preview_split: Split direction: "auto", "left", "right", "above", "below".
      preview_split = 'left',
      override = function(conf)
        return conf
      end,
    },
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = 'fast_scratch',
      disable_preview = function(filename)
        return false
      end,
      win_options = {},
    },
    confirmation = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      minimized_border = 'none',
      win_options = {
        winblend = 0,
      },
    },
    ssh = {
      border = 'rounded',
    },
    keymaps_help = {
      border = 'rounded',
    },
  }
else
  vim.notify('Oil plugin not loaded', vim.log.levels.WARN)
end

-- Harpoon keymaps
require('harpoon').setup()

vim.keymap.set('n', '<leader>a', "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = 'Add File to Harpoon' })
vim.keymap.set('n', '<C-e>', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Harpoon UI' })
vim.keymap.set({ 'n', 'x' }, ']]', "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = 'Harpoon Next' })
vim.keymap.set({ 'n', 'x' }, '[[', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = 'Harpoon Previous' })
