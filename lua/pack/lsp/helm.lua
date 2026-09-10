vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    tmpl = 'gotmpl',
  },
  pattern = {
    ['.*/templates/.*%.ya?ml$'] = 'helm',
    ['.*/templates/.*%.tpl$'] = 'helm',
    ['.*/templates/NOTES%.txt$'] = 'helm',
    ['helmfile.*%.ya?ml$'] = 'helm',
  },
})

local gotmpl_syn = [[
syn case match

syn match       goEscapeOctal       display contained "\\[0-7]\{3}"
syn match       goEscapeC           display contained +\\[abfnrtv\\'"]+
syn match       goEscapeX           display contained "\\x\x\{2}"
syn match       goEscapeU           display contained "\\u\x\{4}"
syn match       goEscapeBigU        display contained "\\U\x\{8}"
syn match       goEscapeError       display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link     goEscapeOctal       goSpecialString
hi def link     goEscapeC           goSpecialString
hi def link     goEscapeX           goSpecialString
hi def link     goEscapeU           goSpecialString
hi def link     goEscapeBigU        goSpecialString
hi def link     goSpecialString     Special
hi def link     goEscapeError       Error

syn cluster     goStringGroup       contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU,goEscapeError
syn region      goString            contained start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@goStringGroup
syn region      goRawString         contained start=+`+ end=+`+

hi def link     goString            String
hi def link     goRawString         String

syn cluster     goCharacterGroup    contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU
syn region      goCharacter         start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=@goCharacterGroup

hi def link     goCharacter         Character

syn match       goDecimalInt        contained "\<\d\+\([Ee]\d\+\)\?\>"
syn match       goHexadecimalInt    contained "\<0x\x\+\>"
syn match       goOctalInt          contained "\<0\o\+\>"
syn match       goOctalError        contained "\<0\o*[89]\d*\>"
syn cluster     goInt               contains=goDecimalInt,goHexadecimalInt,goOctalInt
syn match       goFloat             contained "\<\d\+\.\d*\([Ee][-+]\d\+\)\?\>"
syn match       goFloat             contained "\<\.\d\+\([Ee][-+]\d\+\)\?\>"
syn match       goFloat             contained "\<\d\+[Ee][-+]\d\+\>"
syn match       goImaginary         contained "\<\d\+i\>"
syn match       goImaginary         contained "\<\d\+\.\d*\([Ee][-+]\d\+\)\?i\>"
syn match       goImaginary         contained "\<\.\d\+\([Ee][-+]\d\+\)\?i\>"
syn match       goImaginary         contained "\<\d\+[Ee][-+]\d\+i\>"

hi def link     goInt        Number
hi def link     goFloat      Number
hi def link     goImaginary  Number

syn cluster     gotplLiteral     contains=goString,goRawString,goCharacter,@goInt,goFloat,goImaginary
syn keyword     gotplControl     contained   if else end range with template
syn keyword     gotplFunctions   contained   and html index js len not or print printf println urlquery eq ne lt le gt ge
syn match       gotplVariable    contained   /\$[^ ]*\>/
syn match       goTplIdentifier  contained   /\.[^ ]*\>/

hi def link     gotplControl        Keyword
hi def link     gotplFunctions      Function
hi def link     goTplVariable       Special

syn region gotplAction start="{{" end="}}" contains=@gotplLiteral,gotplControl,gotplFunctions,gotplVariable,goTplIdentifier display
syn region gotplAction start="\[\[" end="\]\]" contains=@gotplLiteral,gotplControl,gotplFunctions,gotplVariable display
syn region goTplComment start="{{/\*" end="\*/}}" display
syn region goTplComment start="\[\[/\*" end="\*/\]\]" display

hi def link gotplAction PreProc
hi def link goTplComment Comment
]]

local function parser_installed(lang)
  return vim.fn.glob(vim.fn.stdpath 'data' .. '/site/parser/' .. lang .. '.so') ~= ''
end

local function setup_ts_highlight()
  vim.treesitter.start()
end

local function setup_gotmpl_vimsyn()
  if vim.b.helm_vimsyn then
    return
  end
  vim.b.helm_vimsyn = true
  vim.cmd 'syntax on'
  vim.cmd(gotmpl_syn)
  vim.b.current_syntax = 'gotmpl'
end

local function setup_helm_vimsyn()
  if vim.b.helm_vimsyn then
    return
  end
  vim.b.helm_vimsyn = true
  vim.cmd 'syntax on'
  vim.cmd.runtime('syntax/yaml.vim')
  vim.cmd(gotmpl_syn)
  vim.cmd([[
    syn cluster gotmpl contains=@gotplLiteral,gotplControl,gotplFunctions,gotplVariable,goTplIdentifier,gotplAction,goTplComment
    syn region gotmpl start="{{" end="}}" contains=@gotmpl containedin=ALL
    syn region gotmpl start="{%" end="%}" contains=@gotmpl containedin=ALL
  ]])
  vim.b.current_syntax = 'helm'
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'helm', 'gotmpl', 'yaml.helm-values' },
  callback = function()
    local ft = vim.bo.filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if parser_installed(lang) then
      setup_ts_highlight()
    elseif ft == 'helm' then
      setup_helm_vimsyn()
    elseif ft == 'gotmpl' then
      setup_gotmpl_vimsyn()
    end
  end,
})