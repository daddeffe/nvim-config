local cmp_types = require('blink.cmp.types')

local kind_icons = {
  Text = '󰉿', Method = '󰆧', Function = '󰊕', Field = '󰜢',
  Variable = '󰀫', Class = '󰠱', Property = '󰜢', Unit = '󰑭',
  Value = '󰎠', Keyword = '󰌋', Color = '󰏘', File = '󰈙',
  Reference = '󰈇', Folder = '󰉋', Constant = '󰏿', Struct = '󰙅',
  Operator = '󰆕',
}

local function in_comment()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  for _, id in ipairs(vim.fn.synstack(row - 1, col)) do
    if vim.fn.synIDattr(id, 'name') == 'Comment' then return true end
  end
  return false
end

require('blink.cmp').setup {
  enabled = function()
    if vim.api.nvim_get_mode().mode == 'c' then return true end
    return vim.b.completion ~= false
      and vim.bo.buftype ~= 'prompt'
      and not in_comment()
  end,

  snippets = { preset = 'luasnip' },

  keymap = {
    preset = 'default',
    ['<A-y>'] = require('minuet').make_blink_map(),
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-Space>'] = {
      function(cmp)
        return cmp.show {
          providers = { 'lazydev', 'lsp', 'snippets', 'path', 'buffer', 'minuet' },
        }
      end,
      'show_documentation',
      'hide_documentation',
    },
    ['<C-e>'] = { 'hide', 'fallback' },

    ['<CR>'] = { 'accept', 'fallback' },

    ['<Space>'] = {
      function(cmp)
        if not cmp.is_menu_visible() then return false end
        local keys = vim.api.nvim_replace_termcodes('<Space>', true, false, true)
        return cmp.accept { callback = function() vim.api.nvim_feedkeys(keys, 'n', false) end }
      end,
      'fallback',
    },

    ['<Tab>'] = {
      function(cmp)
        if cmp.is_menu_visible() then return cmp.select_next() end
        local ls = require 'luasnip'
        if ls and ls.expand_or_jumpable() then
          ls.expand_or_jump()
          return true
        end
        return false
      end,
      'fallback',
    },

    ['<S-Tab>'] = {
      function(cmp)
        if cmp.is_menu_visible() then return cmp.select_prev() end
        local ls = require 'luasnip'
        if ls and ls.jumpable(-1) then
          ls.jump(-1)
          return true
        end
        return false
      end,
      'fallback',
    },

    ['<C-l>'] = {
      function()
        local ls = require 'luasnip'
        if ls and ls.expand_or_locally_jumpable() then ls.expand_or_jump() end
      end,
    },

    ['<C-h>'] = {
      function()
        local ls = require 'luasnip'
        if ls and ls.jumpable(-1) then ls.jump(-1) end
      end,
    },
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    keyword = { range = 'prefix' },
    trigger = { prefetch_on_insert = false },
    list = { selection = { preselect = false, auto_insert = true } },
    menu = {
      auto_show = true,
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      draw = {
        columns = {
          { 'kind_icon', 'kind', 'label', 'label_description', gap = 1 },
          { 'source_name' },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = kind_icons[ctx.kind] or ''
              return icon ~= '' and (icon .. ' ') or icon
            end,
          },
          label = { width = { max_width = 50, fill = false } },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = {
        border = 'rounded',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
        max_width = 80, max_height = 20,
      },
    },
    ghost_text = { enabled = true },
  },

  sources = {
    default = { 'lsp', 'snippets', 'path', 'buffer', 'minuet' },
    providers = {
      lazydev = {
        name = '[Lazy]',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      lsp = {
        name = '[LSP]',
        max_items = 50,
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= cmp_types.CompletionItemKind.Text
          end, items)
        end,
      },
      snippets = {
        name = '[Snippet]',
        module = 'pack.completion.blink_snippets',
      },
      path = { name = '[Path]', max_items = 20 },
      buffer = { name = '[Buffer]', max_items = 10 },
      minuet = {
        name = '[LLM]',
        module = 'minuet.blink',
        async = true,
        timeout_ms = 3000,
        score_offset = 50,
      },
    },
  },

  cmdline = {
    keymap = {
      ['<CR>'] = { 'fallback' },
    },
  },
}
