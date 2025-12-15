vim.pack.add({
  -- Snippet engine and snippets
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',

  -- Neovim API completion
  'https://github.com/folke/lazydev.nvim',

  -- Command line completion
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-cmdline',
  'https://github.com/saadparwaiz1/cmp_luasnip',

  -- AI completion via Ollama
  'https://github.com/tzachar/cmp-ai',
}, {
  confirm = false,
})

-- Setup cmp-ai with Ollama
-- Prompt ottimizzato con formato INFILL per code completion:
-- - System prompt: istruzioni minime
-- - User prompt: formato <PRE> {prefix} <SUF>{suffix} <MID>
--   (standard per Code Llama, CodeGemma, DeepSeek-Coder, ecc.)
-- - max_lines ridotto a 30 (15+15) per response rapide
-- - Token overhead minimale (~10 token vs ~100+ con formato custom)
-- Ref: https://ollama.com/blog/how-to-prompt-code-llama
local cmp_ai = require 'cmp_ai.config'

cmp_ai:setup {
  max_lines = 30, -- Ridotto da 50 a 30 per velocità (15 before + 15 after)
  provider = 'Ollama',
  provider_options = {
    model = 'qwen2.5-coder:0.5b',
    --model = 'deepseek-coder:1.3b',
    --model = 'codellama:7b-code',

    -- System prompt: istruzioni minime per code completion
    system = 'You are a code completion model. You must output ONLY the code that replaces <MID>. Do NOT repeat <PRE> or <SUF>. Do NOT add imports, comments, helper functions, or explanations. Use only variables already defined in <PRE> and <SUF>. Preserve correct indentation.',
    -- User prompt: formato infill ottimizzato per Code Llama
    -- Formato: <PRE> {prefix} <SUF>{suffix} <MID>
    prompt = function(lines_before, lines_after)
      local prefix = lines_before or ''
      local suffix = lines_after or ''

      -- Formato infill standard per modelli di code completion
      -- Questo formato è ottimizzato per Code Llama, CodeGemma, DeepSeek-Coder, ecc.
      return string.format('<PRE> %s <SUF>%s <MID>', prefix, suffix)
    end,
  },
  notify = true,
  notify_callback = function(msg)
    vim.notify(msg)
  end,
  run_on_every_keystroke = true, -- Abilita completion automatiche
  ignored_file_types = {
    -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  },
}

-- Configure lazydev for Lua LSP
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- Configure LuaSnip
local luasnip_ok, luasnip = pcall(require, 'luasnip')
if luasnip_ok then
  require('luasnip.loaders.from_vscode').lazy_load()
  -- Enable friendly-snippets
  require('luasnip.loaders.from_vscode').lazy_load { paths = vim.fn.stdpath 'data' .. '/site/pack/*/start/friendly-snippets' }
end

-- Configure cmp
local cmp = require 'cmp'

-- Icons for completion kinds
local kind_icons = {
  Text = '󰉿',
  Method = '󰆧',
  Function = '󰊕',
  Field = '󰜢',
  Variable = '󰀫',
  Class = '󰠱',
  Property = '󰜢',
  Unit = '󰑭',
  Value = '󰎠',
  Keyword = '󰌋',
  Color = '󰏘',
  File = '󰈙',
  Reference = '󰈇',
  Folder = '󰉋',
  Constant = '󰏿',
  Struct = '󰙅',
  Operator = '󰆕',
  AI = '🤖', -- Ollama AI completions
}

cmp.setup {
  -- Enable/disable completion
  enabled = function()
    -- Disable in comments
    local context = require 'cmp.config.context'
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture 'comment' and not context.in_syntax_group 'Comment'
    end
  end,

  -- Snippet configuration
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
      -- Also support native snippets for Neovim 0.10+
      -- vim.snippet.expand(args.body)
    end,
  },

  -- Completion behavior
  completion = {
    keyword_length = 1, -- Avvia completion dopo 1 carattere (LSP/buffer/snippets)
    completeopt = 'menu,menuone,noselect',
    autocomplete = {
      require('cmp.types').cmp.TriggerEvent.TextChanged, -- Trigger automatico su modifica testo
    },
  },

  -- Confirmation behavior
  confirmation = {
    default_behavior = cmp.ConfirmBehavior.Insert,
  },

  -- Don't preselect first item
  preselect = cmp.PreselectMode.None,

  -- Window configuration
  window = {
    completion = cmp.config.window.bordered {
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      scrollbar = true,
    },
    documentation = cmp.config.window.bordered {
      border = 'rounded',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      max_width = 80,
      max_height = 20,
    },
  },

  -- View configuration
  view = {
    entries = {
      name = 'custom',
      selection_order = 'near_cursor',
    },
    docs = {
      auto_open = true,
    },
  },

  -- Formatting
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    expandable_indicator = true,
    format = function(entry, vim_item)
      -- Special handling for cmp-ai (Ollama)
      if entry.source.name == 'cmp_ai' then
        vim_item.kind = string.format('%s %s', kind_icons.AI or '🤖', 'AI')
      else
        -- Add icons for other sources
        if kind_icons[vim_item.kind] then
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
        end
      end

      -- Truncate long items
      local max_width = 50
      if #vim_item.abbr > max_width then
        vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, max_width - 1) .. '…'
      end

      -- Add source name
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        cmp_ai = '[Ollama]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
        lazydev = '[Lazy]',
      })[entry.source.name]

      return vim_item
    end,
  },

  -- Mapping
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- CR: confirm selected item or insert newline
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm { select = false }
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Space: confirm and insert space
    ['<Space>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm { select = true }
        vim.api.nvim_feedkeys(' ', 'n', false)
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Tab: navigate completion menu
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip_ok and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip_ok and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-l>'] = cmp.mapping(function()
      if luasnip_ok and luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function()
      if luasnip_ok and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
  },

  -- Sources configuration
  sources = cmp.config.sources({
    {
      name = 'lazydev',
      group_index = 0,
    },
    {
      name = 'cmp_ai', -- Ollama AI completions (priorità massima)
      priority = 1500,
      max_item_count = 5,
      keyword_length = 2, -- Ridotto da 3 a 2 per completion più reattive
    },
    {
      name = 'nvim_lsp',
      priority = 1000,
      max_item_count = 50,
      entry_filter = function(entry, ctx)
        -- Filter out Text kind from LSP
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        if kind == 'Text' then
          return false
        end
        return true
      end,
    },
    {
      name = 'luasnip',
      priority = 750,
      max_item_count = 10,
      keyword_length = 2,
    },
    {
      name = 'path',
      priority = 500,
      max_item_count = 20,
      keyword_length = 3,
    },
  }, {
    {
      name = 'buffer',
      priority = 250,
      max_item_count = 10,
      keyword_length = 3,
      option = {
        get_bufnrs = function()
          -- Complete from all visible buffers
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  }),

  -- Matching configuration
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
    disallow_symbol_nonprefix_matching = false,
  },

  -- Sorting
  sorting = {
    priority_weight = 2,
    comparators = {
      -- AI completions vengono prima in base alla priority
      function(entry1, entry2)
        local kind1 = entry1:get_kind()
        local kind2 = entry2:get_kind()
        if kind1 ~= kind2 then
          if entry1.source.name == 'cmp_ai' then
            return true
          end
          if entry2.source.name == 'cmp_ai' then
            return false
          end
        end
      end,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  -- Performance
  performance = {
    debounce = 60,
    throttle = 30,
    fetching_timeout = 1000,
    confirm_resolve_timeout = 80,
    async_budget = 1,
    max_view_entries = 200,
  },

  -- Experimental features
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
  },
}
-- Common cmdline mappings (shared between search and command mode)
local cmdline_mapping = cmp.mapping.preset.cmdline {
  ['<CR>'] = cmp.mapping.confirm { select = true },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { 'c' }),
}

-- Search mode completion
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmdline_mapping,
  sources = {
    {
      name = 'buffer',
      option = {
        keyword_pattern = [[\k\+]],
      },
    },
  },
})

-- Command mode completion
cmp.setup.cmdline(':', {
  mapping = cmdline_mapping,
  sources = cmp.config.sources({
    {
      name = 'path',
      option = { trailing_slash = true },
    },
  }, { { name = 'cmdline' } }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

-- Setup LSP capabilities and export them
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Additional capabilities for better LSP support
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

-- Dynamically assign capabilities to all LSP servers
-- This function updates all configured LSP servers with cmp capabilities
local function update_lsp_capabilities()
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    return
  end

  -- Get all available LSP configurations
  local util = require 'lspconfig.util'
  local configs = require 'lspconfig.configs'

  -- Iterate through all configured servers and update their capabilities
  for server_name, config in pairs(configs) do
    if config and config.manager then
      -- Server is already configured, update its default config
      local default_config = config.manager.config
      if default_config then
        default_config.capabilities = vim.tbl_deep_extend('force', default_config.capabilities or {}, capabilities)
      end
    end
  end

  -- Also update any active LSP clients
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.config and client.config.capabilities then
      client.config.capabilities = vim.tbl_deep_extend('force', client.config.capabilities, capabilities)
    end
  end

  vim.notify('LSP capabilities updated with nvim-cmp support', vim.log.levels.INFO)
end

-- Update capabilities when this module loads (after lsp.lua)
vim.schedule(function()
  update_lsp_capabilities()
end)
