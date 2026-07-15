local lint = require 'lint'

lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

local FORCE_DISABLE_FT = {
  'DiffviewFiles', 'Oil', 'Telescope', 'TelescopePrompt', 'Trouble',
  'alpha', 'checkhealth', 'dap-repl', 'dashboard', 'fugitive', 'git',
  'help', 'lazy', 'mason', 'md', 'nofile', 'oil', 'promt', 'qf',
}

local function in_list(ft, list)
  for _, v in ipairs(list) do
    if v == ft then return true end
  end
  return false
end

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({
  'BufEnter', 'BufWinEnter', 'BufWritePost', 'InsertLeave', 'TermEnter', 'TextChanged',
}, {
  group = lint_augroup,
  callback = function()
    if not vim.bo.modifiable or (in_list(vim.bo.buftype, FORCE_DISABLE_FT) or in_list(vim.bo.ft, FORCE_DISABLE_FT)) then
      vim.opt.colorcolumn = '0'
      vim.o.list = false
    else
      lint.try_lint()
      vim.opt.colorcolumn = '85'
      vim.o.list = true
    end
  end,
})
