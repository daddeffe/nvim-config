vim.cmd.packadd 'nvim-origami'

local origami_ok, origami = pcall(require, 'origami')
if origami_ok then
  origami.setup {}
end
