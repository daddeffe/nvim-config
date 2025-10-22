-- Plugin: afonsofrancof/worktrees.nvim
-- Installed via store.nvim

vim.pack.add { 'https://github.com/afonsofrancof/worktrees.nvim' }

require('worktrees').setup {
  -- Specify where to create worktrees relative to git common dir
  -- The common dir is the .git dir in a normal repo or the root dir of a bare repo
  base_path = '../.tree', -- Parent directory of common dir
  -- Template for worktree folder names
  -- This is only used if you don't specify the folder name when creating the worktree
  path_template = '{branch}', -- Default: use branch name
  -- Command names (optional)
  commands = {
    create = 'WorktreeCreate',
    delete = 'WorktreeDelete',
    switch = 'WorktreeSwitch',
  },
  -- Key mappings for interactive UI (optional)
  mappings = {
    create = '<leader>hwc',
    delete = '<leader>hwd',
    switch = '<leader>hws',
  },
}
