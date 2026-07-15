vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/madmaxieee/unclash.nvim',
}, { confirm = false, load = true })

vim.cmd.packadd 'gitsigns.nvim'

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end)
    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end)
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[H]unk [S]tage' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = '[H]unk [S]tage (visual)' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = '[H]unk [R]eset (visual)' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[H]unk [S]tage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[H]unk [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
    map('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, { desc = '[H]unk [B]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = '[H]unk [D]iff' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '~'
    end, { desc = '[H]unk [D]iff ~' })
    map('n', '<leader>hQ', function()
      gitsigns.setqflist 'all'
    end, { desc = '[H]unk [Q]uickfix list (all)' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = '[H]unk [Q]uickfix list' })
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = '[I]nner [H]unk' })
  end,
  signs_staged_enable = true,
  signcolumn = false,
  numhl = true,
  linehl = true,
  word_diff = true,
  watch_gitdir = { follow_files = true },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true,
  current_line_blame_opts = { virt_text = true, virt_text_pos = 'eol', delay = 300, ignore_whitespace = false, virt_text_priority = 100, use_focus = true },
  current_line_blame_formatter = ' -- <author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
}

local unclash = require 'unclash'
vim.keymap.set('n', '<leader>hco', unclash.open_merge_editor, { desc = '[C]onflict merge editor' })
vim.keymap.set('n', '<leader>hcc', unclash.accept_current, { desc = '[C]onflict accept [C]urrent' })
vim.keymap.set('n', '<leader>hci', unclash.accept_incoming, { desc = '[C]onflict accept [I]ncoming' })
vim.keymap.set('n', '<leader>hcb', unclash.accept_both, { desc = '[C]onflict accept [B]oth' })

vim.keymap.set('n', '<leader>hg', '<cmd>Git<CR>', { desc = '[H]it [G]it Status' })
vim.keymap.set('n', '<leader>hG', '<cmd>Gdiffsplit!<CR>', { desc = '[H]it [G]diffsplit' })
vim.keymap.set('n', '<leader>hi', '<cmd>Git commit<CR>', { desc = '[H]it comm[I]t' })
vim.keymap.set('n', '<leader>hu', '<cmd>Git push<CR>', { desc = '[H]it p[U]sh' })
vim.keymap.set('n', '<leader>hU', '<cmd>Git pull<CR>', { desc = '[H]it p[U]ll' })

require('telescope').load_extension 'lazygit'
vim.keymap.set('n', '<leader>hl', '<cmd>LazyGit<CR>', { desc = '[H]it [L]azyGit' })
