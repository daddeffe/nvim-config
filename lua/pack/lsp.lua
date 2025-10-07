vim.pack.add {
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
}

-- IMPORTANT: Initialize Mason BEFORE mason-lspconfig
require('mason').setup {}

-- Configure fidget
require('fidget').setup {}

-- Configure conform (formatting)
require('conform').setup {
  notify_on_error = false,
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
vim.keymap.set('', '<leader>=', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- Configure nvim-lint
local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

-- Create autocommand for linting
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify
    if vim.bo.modifiable then
      lint.try_lint()
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

    -- Find references for the word under your cursor
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- Jump to Declaration
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

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

-- Get LSP capabilities from blink.cmp (if available)
local capabilities = {}
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
  capabilities = blink.get_lsp_capabilities()
end

-- LSP servers configuration
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
}

-- Ensure tools are installed
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua', -- Used to format Lua code
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- Setup LSP servers with mason-lspconfig
require('mason-lspconfig').setup {
  ensure_installed = {}, -- explicitly set to empty (populated via mason-tool-installer)
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}

