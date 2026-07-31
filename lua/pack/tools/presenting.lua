vim.g.presenting_separator = '---'

require('presenting').setup {
  options = {
    width = 80,
  },
  separator = {
    markdown ='^#+ ',
    org = '^*+ ',
    adoc = '^==+ ',
    asciidoctor = '^==+ ',
  },
  keep_separator = true,
}
