local Snacks = require 'snacks'

local project_priority = {
  '^readme',
  '^agents',
  '^main%.',
  '^index%.',
  '^init%.',
  '^app%.',
  '^server%.',
}

local function project_rank(name)
  name = name:lower()
  for i, pat in ipairs(project_priority) do
    if name:find(pat) then
      return i
    end
  end
end

Snacks.dashboard.sections.project = function(opts)
  opts = opts or {}
  local limit = opts.limit or 6
  return function()
    local items = {}
    local cwd = vim.fn.getcwd()
    local ok, names = pcall(vim.fn.readdir, cwd)
    if not ok then
      return items
    end
    local ranked = {}
    for _, name in ipairs(names) do
      if not vim.startswith(name, '.') then
        local rank = project_rank(name)
        local full = cwd .. '/' .. name
        if rank and vim.fn.isdirectory(full) == 0 then
          ranked[#ranked + 1] = { name = name, full = full, rank = rank }
        end
      end
    end
    table.sort(ranked, function(a, b)
      if a.rank ~= b.rank then
        return a.rank < b.rank
      end
      return a.name < b.name
    end)
    for i, f in ipairs(ranked) do
      if i > limit then
        break
      end
      items[#items + 1] = {
        file = f.name,
        icon = 'file',
        action = ':e ' .. vim.fn.fnameescape(f.full),
        autokey = true,
      }
    end
    return items
  end
end

Snacks.setup {
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
          icon = '󰈙 ',
          title = 'Progetto',
          section = 'project',
          indent = 2,
          padding = 1,
        },
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
          enabled = function()
            return in_git
          end,
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
          enabled = function()
            return in_git
          end,
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
