package.loaded['lazy.stats'] = {
  stats = function()
    local elapsed = vim.g._startup_time and vim.fn.reltimefloat(vim.fn.reltime(vim.g._startup_time)) or 0
    return { startuptime = elapsed, loaded = 0, count = 0 }
  end,
}

require('snacks').setup {
  dashboard = {
    sections = {
      {
        section = 'terminal',
        cmd = 'cat ' .. vim.fn.stdpath 'config' .. '/dash.ansi',
        height = 17,
        padding = 0,
      },
      { section = 'keys', gap = 1, padding = 0 },
      {
        icon = ' ',
        title = 'Recent Files',
        section = 'recent_files',
        indent = 2,
        padding = 1,
      },
      {
        icon = ' ',
        title = 'Projects',
        section = 'projects',
        indent = 2,
        padding = 1,
      },
      {
        icon = ' ',
        title = 'Git Status',
        section = 'terminal',
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = 'git status --short --branch --renames',
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
      { section = 'startup', padding = 1, indent = 3 },
    },
  },
}
