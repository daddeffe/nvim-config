vim.g.presenting_separator = '---'

local lazy = require 'pack.lazy'

local function load_presenting()
  require('presenting').setup {
    options = {
      width = 80,
    },
    separator = {
      markdown = '^#+ ',
      org = '^*+ ',
      adoc = '^==+ ',
      asciidoctor = '^==+ ',
    },
    keep_separator = true,
  }
end

lazy.by_cmd('presenting.nvim', 'Present', load_presenting, 'Present')
