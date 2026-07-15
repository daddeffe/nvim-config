local cmp = require 'cmp'
local luasnip = _G.luasnip

local kind_icons = {
  Text = '󰉿', Method = '󰆧', Function = '󰊕', Field = '󰜢',
  Variable = '󰀫', Class = '󰠱', Property = '󰜢', Unit = '󰑭',
  Value = '󰎠', Keyword = '󰌋', Color = '󰏘', File = '󰈙',
  Reference = '󰈇', Folder = '󰉋', Constant = '󰏿', Struct = '󰙅',
  Operator = '󰆕',
}

cmp.setup {
  enabled = function()
    if vim.api.nvim_get_mode().mode == 'c' then return true end
    local context = require 'cmp.config.context'
    return not context.in_syntax_group 'Comment'
  end,
  snippet = {
    expand = function(args)
      if luasnip then luasnip.lsp_expand(args.body) end
    end,
  },
  completion = {
    keyword_length = 1,
    completeopt = 'menu,menuone,noselect',
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  confirmation = { default_behavior = cmp.ConfirmBehavior.Insert },
  preselect = cmp.PreselectMode.None,
  window = {
    completion = cmp.config.window.bordered {
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      scrollbar = true,
    },
    documentation = cmp.config.window.bordered {
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      max_width = 80, max_height = 20,
    },
  },
  view = {
    entries = { name = 'custom', selection_order = 'near_cursor' },
    docs = { auto_open = true },
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    expandable_indicator = true,
    format = function(entry, vim_item)
      if kind_icons[vim_item.kind] then
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      end
      local max_width = 50
      if #vim_item.abbr > max_width then
        vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, max_width - 1) .. '…'
      end
      vim_item.menu = ({
        nvim_lsp = '[LSP]', luasnip = '[Snippet]',
        buffer = '[Buffer]', path = '[Path]', lazydev = '[Lazy]',
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then cmp.confirm { select = false }
      else fallback() end
    end, { 'i', 's' }),
    ['<Space>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm { select = true }
        vim.api.nvim_feedkeys(' ', 'n', false)
      else fallback() end
    end, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip and luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip and luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { 'i', 's' }),
    ['<C-l>'] = cmp.mapping(function()
      if luasnip and luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function()
      if luasnip and luasnip.jumpable(-1) then luasnip.jump(-1) end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'lazydev', group_index = 0 },
    { name = 'nvim_lsp', priority = 1000, max_item_count = 50,
      entry_filter = function(entry, ctx)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        return kind ~= 'Text'
      end,
    },
    { name = 'luasnip', priority = 750, max_item_count = 10, keyword_length = 2 },
    { name = 'path', priority = 500, max_item_count = 20, keyword_length = 3 },
  }, {
    { name = 'buffer', priority = 250, max_item_count = 10, keyword_length = 3,
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  }),
  matching = {
    disallow_fuzzy_matching = false, disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = false, disallow_partial_matching = false,
    disallow_prefix_unmatching = false, disallow_symbol_nonprefix_matching = false,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset, cmp.config.compare.exact,
      cmp.config.compare.score, cmp.config.compare.recently_used,
      cmp.config.compare.locality, cmp.config.compare.kind,
      cmp.config.compare.length, cmp.config.compare.order,
    },
  },
  performance = {
    debounce = 60, throttle = 30, fetching_timeout = 1000,
    confirm_resolve_timeout = 80, async_budget = 1, max_view_entries = 200,
  },
  experimental = { ghost_text = { hl_group = 'CmpGhostText' } },
}

local cmdline_mapping = cmp.mapping.preset.cmdline {
  ['<CR>'] = cmp.mapping.confirm { select = true },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then cmp.select_next_item() else fallback() end
  end, { 'c' }),
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmdline_mapping,
  sources = { { name = 'buffer', option = { keyword_pattern = [[\k\+]] } } },
})

cmp.setup.cmdline(':', {
  mapping = cmdline_mapping,
  sources = cmp.config.sources(
    { { name = 'path', option = { trailing_slash = true } } },
    { { name = 'cmdline' } }
  ),
  matching = { disallow_symbol_nonprefix_matching = false },
})
