local navic_ok, navic = pcall(require, 'nvim-navic')

if navic_ok then
  navic.setup {
    icons = { enabled = false },
    highlight = false,
    separator = ' > ',
    depth_limit = 0,
    depth_limit_indicator = '..',
    safe_output = true,
    lsp = { auto_attach = true },
  }
end

local statusline = require 'mini.statusline'
statusline.setup {
  use_icons = vim.g.have_nerd_font,
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = MiniStatusline.section_diff { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local location = MiniStatusline.section_location { trunc_width = 75 }
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }
      local navic_location = navic_ok and navic.is_available() and navic.get_location() or ''

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { navic_location } },
        '%=',
        { hl = mode_hl, strings = { search, location } },
        { hl = 'MiniStatuslineFileinfo', strings = { lsp, fileinfo } },
      }
    end,
  },
  set_vim_settings = true,
}

vim.o.winbar = '%{%v:lua.MiniStatusline.active()%}'
