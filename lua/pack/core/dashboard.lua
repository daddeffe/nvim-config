require('snacks').setup {
  dashboard = {
    sections = function()
      local in_git = Snacks.git.get_root() ~= nil
      local git_h = 8
      if in_git then
        local ok, lines = pcall(vim.fn.systemlist, 'git dw 2>/dev/null')
        git_h = math.min((ok and #lines or 0) + 1, 15)
      end

      return {
        {
          pane = 1,
          icon = ' ',
          title = 'Recent Files',
          section = 'recent_files',
          indent = 2,
          padding = 1,
        },
        {
          pane = 1,
          icon = ' ',
          title = 'Projects',
          section = 'projects',
          indent = 2,
          padding = 1,
        },
        {
          pane = 1,
          icon = ' ',
          title = 'Keys',
          section = 'keys',
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          section = 'terminal',
          cmd = 'cat ' .. vim.fn.stdpath 'config' .. '/dash.ansi',
          height = 17,
          padding = 1,
        },
        {
          pane = in_git and 2 or 3,
          section = 'terminal',
          cmd = 'fastfetch --logo none --structure os:kernel:uptime:cpu:memory:swap:disk::process',
          height = 8,
          padding = 1,
          ttl = 60,
        },
        {
          pane = 3,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function() return in_git end,
          cmd = 'git dw',
          height = git_h,
          width = 55,
          padding = 1,
          ttl = 60,
          indent = 2,
        },
        {
          pane = 3,
          icon = ' ',
          title = 'Recent Commits',
          section = 'terminal',
          enabled = function() return in_git end,
          cmd = 'git log --color --graph --pretty=format:"%C(auto)%h %C(auto)%d" --all -10',
          height = 15,
          width = 55,
          padding = 1,
          ttl = 60,
          indent = 2,
        },
      }
    end,
  },
}
