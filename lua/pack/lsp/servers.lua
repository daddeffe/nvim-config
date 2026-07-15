local servers = {
  ast_grep = {
    filetypes = { 'lua', 'python', 'javascript', 'typescript' },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
      },
    },
  },
  ruff = {
    init_options = {
      settings = {
        configuration = {
          format = { preview = true },
          lint = { preview = true },
        },
        logLevel = 'error',
      },
    },
  },
  intelephense = {
    filetypes = { 'php' },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'basic',
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = 'clippy' },
      },
    },
  },
  helm_ls = {
    filetypes = { 'helm', 'yaml.helm-values' },
    root_markers = { 'Chart.yaml', 'Chart.yml' },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enable = true,
          url = 'https://www.schemastore.org/api/json/catalog.json',
        },
        schemas = { kubernetes = '/*.yaml' },
        format = { enable = true },
        validate = true,
        completion = true,
        hover = true,
      },
    },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.configuration = true
capabilities.workspace.didChangeConfiguration = { dynamicRegistration = true }
capabilities.workspace.workspaceFolders = true

for server_name, server in pairs(servers) do
  server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
  vim.lsp.config(server_name, server)
end

require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}
