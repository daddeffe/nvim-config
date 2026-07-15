require('mini.misc').setup()
require('mini.icons').setup()
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup {
  mappings = {
    add = 'sa', delete = 'sd', find = 'sf', find_left = 'sF',
    highlight = 'sh', replace = 'sr', update_n_lines = 'sn',
  },
}
require('mini.comment').setup {
  options = {
    custom_commentstring = nil, ignore_blank_line = false,
    start_of_line = false, pad_comment_parts = true,
  },
  mappings = {
    comment = 'gc', comment_line = 'gcc',
    comment_visual = 'gc', textobject = 'gc',
  },
}
require('mini.pairs').setup {
  modes = { insert = true, command = false, terminal = false },
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  skip_unbalanced = true,
  markdown = true,
}
require('mini.bracketed').setup {
  buffer = { suffix = 'b' }, comment = { suffix = 'c' },
  conflict = { suffix = 'x' }, diagnostic = { suffix = 'd' },
  file = { suffix = 'f' }, indent = { suffix = 'i' },
  jump = { suffix = 'j' }, location = { suffix = 'l' },
  oldfile = { suffix = 'o' }, quickfix = { suffix = 'q' },
  undo = { suffix = 'u' }, window = { suffix = 'w' },
  yank = { suffix = 'y' },
}
require('mini.hipatterns').setup {
  highlighters = {
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
  },
}
require('mini.jump').setup()
require('mini.jump2d').setup { labels = 'abcdefghijklmnopqrstuvwxyz', mappings = { start_jumping = '<Leader><CR>' } }
require('mini.trailspace').setup()
vim.keymap.set('n', '<leader>tW', MiniTrailspace.trim, { desc = 'Trim [T]railing [W]hitespace' })
vim.keymap.set('n', '<leader>tl', MiniTrailspace.trim_last_lines, { desc = 'Trim [T]railing [L]ines' })
require('mini.move').setup {
  mappings = {
    left = '<M-h>', right = '<M-l>', down = '<M-j>', up = '<M-k>',
    line_left = '<M-h>', line_right = '<M-l>', line_down = '<M-j>', line_up = '<M-k>',
  },
}
require('mini.operators').setup {
  evaluate = { prefix = 'g=' }, exchange = { prefix = 'gx' },
  multiply = { prefix = 'gm' }, replace = { prefix = 'gr' }, sort = { prefix = 'gs' },
}
require('mini.align').setup { mappings = { start = 'ga', start_with_preview = 'gA' } }
require('mini.visits').setup {
  silent = false,
  store = { autowrite = true, path = vim.fn.stdpath 'data' .. '/mini-visits-index' },
}
require('mini.indentscope').setup { symbol = '│', options = { try_as_border = true } }
