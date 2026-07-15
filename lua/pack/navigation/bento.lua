require('bento').setup {
  main_keymap = ';',
  lock_char = '🔒',
  buffer_deletion_metric = 'frecency_access',
  buffer_notify_on_delete = true,
  ordering_metric = 'access',
  default_action = 'open',
  ui = {
    mode = 'floating',
    floating = {
      position = 'middle-right', offset_x = 0, offset_y = 0,
      dash_char = '─', label_padding = 1, minimal_menu = 'dashed',
      max_rendered_buffers = nil,
    },
    tabline = {
      left_page_symbol = '❮', right_page_symbol = '❯', separator_symbol = '│',
    },
  },
  highlights = {
    current = 'Bold', active = 'Normal', inactive = 'Comment',
    modified = 'DiagnosticWarn', inactive_dash = 'Comment', previous = 'Search',
    label_open = 'DiagnosticVirtualTextHint', label_vsplit = 'DiagnosticVirtualTextInfo',
    label_split = 'DiagnosticVirtualTextInfo', label_lock = 'DiagnosticVirtualTextWarn',
    label_minimal = 'Visual', window_bg = 'BentoNormal',
    page_indicator = 'Comment', separator = 'Normal',
  },
  actions = {},
}
