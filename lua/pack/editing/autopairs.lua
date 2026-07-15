vim.cmd.packadd 'nvim-autopairs'

local autopairs_ok, autopairs = pcall(require, 'nvim-autopairs')
if autopairs_ok then
  autopairs.setup {}
end
