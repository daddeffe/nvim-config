local oil_ok, oil = pcall(require, 'oil')
if oil_ok then
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  oil.setup {
    default_file_explorer = true,
    columns = { 'permissions', 'size', 'mtime' },
    buf_options = { buflisted = false, bufhidden = 'hide' },
    win_options = {
      wrap = false,
      signcolumn = 'yes:1',
      foldcolumn = '0',
      spell = false,
      list = false,
      concealcursor = 'nvic',
    },
    delete_to_trash = false,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 1000,
    lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
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
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['~'] = { 'actions.cd', mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    use_default_keymaps = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        return name:match '^%.' ~= nil
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
      natural_order = 'fast',
      case_insensitive = false,
      sort = { { 'type', 'asc' }, { 'name', 'asc' } },
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
      win_options = { winblend = 0 },
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
  }
end

require('oil-git-status').setup()
