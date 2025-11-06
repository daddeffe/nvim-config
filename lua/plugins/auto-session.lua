-- Plugin: rmagatti/auto-session
-- Installed via store.nvim

vim.pack.add { 'https://github.com/rmagatti/auto-session' }

require('auto-session').setup {
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  -- log_level = 'debug',
  bypass_save_filetypes = { 'alpha', 'dashboard', 'snacks_dashboard' }, -- or whatever dashboard you use
}

--vim.notify('Restored session: ' .. require('auto-session.lib').current_session_name(true))
