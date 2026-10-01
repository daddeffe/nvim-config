local ok, modicator = pcall(require, 'modicator')
if not ok then
  return
end

modicator.setup {
  show_warnings = false,
  highlights = {
    defaults = { bold = true, italic = false },
    use_cursorline_background = false,
  },
  integration = {
    lualine = { enabled = false },
  },
}

local mini_mode = {
  Normal = 'MiniStatuslineModeNormal',
  Insert = 'MiniStatuslineModeInsert',
  Visual = 'MiniStatuslineModeVisual',
  Replace = 'MiniStatuslineModeReplace',
  Command = 'MiniStatuslineModeCommand',
  Select = 'MiniStatuslineModeVisual',
  Terminal = 'MiniStatuslineModeOther',
  TerminalNormal = 'MiniStatuslineModeNormal',
}

local function sync_mode_highlights()
  for mode, source in pairs(mini_mode) do
    local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
    if not vim.tbl_isempty(hl) then
      vim.api.nvim_set_hl(0, mode .. 'Mode', hl)
    end
  end
  modicator.set_cursor_line_highlight(modicator.hl_name_from_mode(vim.api.nvim_get_mode().mode))
end

sync_mode_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('modicator_mini_sync', { clear = true }),
  callback = function()
    vim.schedule(sync_mode_highlights)
  end,
})
