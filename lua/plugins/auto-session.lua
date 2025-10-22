-- Plugin: rmagatti/auto-session
-- Installed via store.nvim

vim.pack.add { 'https://github.com/rmagatti/auto-session' }

require('auto-session').setup {
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  -- log_level = 'debug',
}

