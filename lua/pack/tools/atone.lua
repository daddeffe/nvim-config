require('atone').setup {
  layout = { direction = 'left', width = 0.35 },
  diff_cur_node = { enabled = true, split_percent = 0.3 },
  auto_attach = { enabled = true, excluded_ft = { 'oil' } },
  keymaps = {
    tree = {
      quit = { '<C-c>', 'q' },
      next_node = 'j',
      pre_node = 'k',
      undo_to = '<CR>',
      help = { '?', 'g?' },
    },
    auto_diff = {
      quit = { '<C-c>', 'q' },
      help = { '?', 'g?' },
    },
    help = {
      quit_help = { '<C-c>', 'q' },
    },
  },
  ui = { border = 'single' },
}

vim.keymap.set('n', '<leader>u', ':Atone toggle<CR>', { desc = '[U]ndo tree (Atone)' })
