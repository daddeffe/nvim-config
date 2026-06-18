-- Plugin: samharju/yeet.nvim
-- Installed via store.nvim

vim.pack.add { 'https://github.com/stevearc/dressing.nvim' }
vim.pack.add { 'https://github.com/samharju/yeet.nvim' }

require('yeet').setup {
  -- Send <CR> to channel after command for immediate execution.
  yeet_and_run = true,
  -- Send C-c before execution
  interrupt_before_yeet = false,
  -- Send 'clear<CR>' to channel before command for clean output.
  clear_before_yeet = true,

  -- Yeets pop a vim.notify by default if you have one of these available
  -- and configured to override `vim.notify`:
  --   noice.nvim, nvim-notify, fidget.nvim
  -- Force success notifications on or off by setting true/false:

  --notify_on_success = false,

  -- Print warning if pane list could not be fetched, e.g. tmux not running.
  warn_tmux_not_running = false,
  -- Command used by tmux to create a new pane. Must output the pane id with -PF '#D'.
  tmux_split_pane_command = "tmux split-window -dhPF  '#D'",
  -- Retries the last used target if the target is unavailable (e.g., tmux pane closed).
  -- Useful for maintaining workflow without re-selecting the target manually.
  -- Works with: term buffers, tmux panes, tmux windows
  retry_last_target_on_failure = false,
  -- Hide neovim term buffers in `yeet.select_target`
  hide_term_buffers = false,
  -- Resolver for cache file

  -- Open cache file instead of in memory prompt.
  use_cache_file = true,

  -- Window options for cache float
  cache_window_opts = function()
    -- returns a default config for vim.api.nvim_open_win with width
    -- of max 120 columns and height of 15 lines. See yeet/conf.lua.
  end,

  -- Callback used before command is sent to target.
  -- You can use your own placeholders and replace them as you wish in the callback.
  custom_eval = nil,
}

