vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
}, { confirm = false, load = false })

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('fzf_build', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'telescope-fzf-native.nvim' then
      return
    end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then
      return
    end
    vim.system({ 'make' }, { cwd = ev.data.path }):wait()
  end,
})

local lazy = require 'pack.lazy'

local function load_telescope()
  vim.cmd.packadd 'telescope-fzf-native.nvim'
  vim.cmd.packadd 'telescope-ui-select.nvim'
  pcall(require, 'telescope').setup {
    defaults = { mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine' } } },
    extensions = { ['ui-select'] = require('telescope.themes').get_dropdown() },
  }
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'lazygit')
end

local t = function(name)
  return function()
    require('telescope.builtin')[name]()
  end
end

local targs = function(name, opts)
  return function()
    require('telescope.builtin')[name](opts)
  end
end

lazy.by_key('telescope.nvim', 'n', '<leader>sh', load_telescope, t 'help_tags', { desc = '[S]earch [H]elp' })
lazy.by_key('telescope.nvim', 'n', '<leader>sk', load_telescope, t 'keymaps', { desc = '[S]earch [K]eymaps' })
lazy.by_key('telescope.nvim', 'n', '<leader>sf', load_telescope, t 'find_files', { desc = '[S]earch [F]iles' })
lazy.by_key('telescope.nvim', 'n', '<leader>ss', load_telescope, t 'builtin', { desc = '[S]earch [S]elect Telescope' })
lazy.by_key('telescope.nvim', 'n', '<leader>sw', load_telescope, t 'grep_string', { desc = '[S]earch current [W]ord' })
lazy.by_key('telescope.nvim', 'n', '<leader>sg', load_telescope, t 'live_grep', { desc = '[S]earch by [G]rep' })
lazy.by_key('telescope.nvim', 'n', '<leader>sd', load_telescope, t 'diagnostics', { desc = '[S]earch [D]iagnostics' })
lazy.by_key('telescope.nvim', 'n', '<leader>sr', load_telescope, t 'resume', { desc = '[S]earch [R]esume' })
lazy.by_key('telescope.nvim', 'n', '<leader>s.', load_telescope, t 'oldfiles', { desc = '[S]earch Recent Files ("." for repeat)' })
lazy.by_key('telescope.nvim', 'n', '<leader>sb', load_telescope, t 'buffers', { desc = '[ ] Find existing buffers' })
lazy.by_key('telescope.nvim', 'n', '<leader>/', load_telescope, targs 'current_buffer_fuzzy_find', { desc = '[/] Fuzzily search in current buffer' })
lazy.by_key('telescope.nvim', 'n', '<leader>s/', load_telescope, targs 'live_grep', { desc = '[S]earch [/] in Open Files' })
lazy.by_key('telescope.nvim', 'n', '<leader>sn', load_telescope, function()
  require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })