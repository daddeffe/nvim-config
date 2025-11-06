vim.pack.add({
  -- LSP Configuration
  'https://github.com/neovim/nvim-lspconfig',

  -- LSP progress indicator
  'https://github.com/j-hui/fidget.nvim',

  -- Formatting and linting
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',

  -- Mason - LSP/DAP/Linter/Formatter installer
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}, {
  confirm = false,
})

-- IMPORTANT: Initialize Mason BEFORE mason-lspconfig
require('mason').setup {}

-- Configure fidget
require('fidget').setup {}

-- Configure conform (formatting)
require('conform').setup {
  notify_on_error = true,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    svelte = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    graphql = { 'prettier' },
    lua = { 'stylua' },
    python = { 'isort', 'black' },
  },
}

-- Format keymap
vim.keymap.set('n', '<leader>=', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- Configure nvim-lint
local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

local FORCE_DISABLE_FT = {
  'DiffviewFiles',
  'Oil',
  'Telescope',
  'TelescopePrompt',
  'Trouble',
  'alpha',
  'checkhealth',
  'dap-repl',
  'dashboard',
  'fugitive',
  'git',
  'help',
  'lazy',
  'mason',
  'md',
  'nofile',
  'oil',
  'promt',
  'qf',
}

local function in_list(ft, list)
  for _, v in ipairs(list) do
    if v == ft then
      return true
    end
  end
  return false
end

-- -- Create autocommand for linting
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({
  'BufEnter',
  'BufWinEnter',
  'BufWritePost',
  'InsertLeave',
  'TermEnter',
  'TextChanged',
}, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify
    --vim.notify(vim.inspect {
    --  mod = vim.bo.modifiable,
    --  buft = in_list(vim.bo.buftype, FORCE_DISABLE_FT),
    --  ft = in_list(vim.bo.ft, FORCE_DISABLE_FT),
    --})
    if not vim.bo.modifiable or (in_list(vim.bo.buftype, FORCE_DISABLE_FT) or in_list(vim.bo.ft, FORCE_DISABLE_FT)) then
      vim.opt.colorcolumn = '0'
      --vim.notify 'Disabled lint'
      vim.o.list = false
    else
      lint.try_lint()
      vim.notify 'Linted'
      vim.opt.colorcolumn = '85'
      vim.o.list = true
    end
  end,
})

-- Configure LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Jump to Declaration
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Find references for the word under your cursor
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- Document symbols
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

    -- Workspace symbols
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    -- Type definition
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

    -- Helper function for client support checking
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    -- Document highlight
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay hints toggle
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostic Config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

-- Ensure tools are installed
local ensure_installed = vim.tbl_keys {}
vim.list_extend(ensure_installed, {
  'duster',
  'lua_ls',
  'markdownlint',
  'pint',
  'prettier',
  'stylua',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- Setup LSP servers with mason-lspconfig
require('mason-lspconfig').setup {
  automatic_installation = true,
  --handlers = {
  --  function(server_name)
  --    local server = servers[server_name] or {}
  --    -- This handles overriding only values explicitly passed
  --    -- by the server configuration above

  --    -- Get LSP capabilities from blink.cmp (if available)
  --    local capabilities = {}
  --    local blink_ok, blink = pcall(require, 'blink.cmp')
  --    if blink_ok then
  --      capabilities = blink.get_lsp_capabilities()
  --    end

  --    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  --    require('lspconfig')[server_name].setup(server)
  --  end,
  --},
  --
}
local grp = vim.api.nvim_create_augroup('TermMarkdown', { clear = true })

local function mark_highlight(ev)
  if vim.bo[ev.buf].buftype == 'terminal' then
    -- Prova Treesitter, fallback a :syntax
    pcall(vim.treesitter.start, ev.buf, 'markdown')
    vim.bo[ev.buf].filetype = 'markdown'
    vim.cmd 'syntax enable'
  end
end

vim.api.nvim_create_autocmd('ModeChanged', {
  group = grp,
  pattern = '*:t', -- entrando in terminal-mode
  callback = mark_highlight,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = grp,
  pattern = 't:*', -- uscendo da terminal-mode
  callback = mark_highlight,
})
