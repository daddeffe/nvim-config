vim.cmd.packadd 'markview.nvim'
vim.cmd.packadd 'store.nvim'

local configured = false

local function ensure_setup()
  if configured then
    return true
  end

  local ok, store = pcall(require, 'store')
  if not ok then
    vim.notify('store.nvim not loaded', vim.log.levels.WARN)
    return false
  end

  local ok_setup, err = pcall(store.setup, { plugin_manager = 'vim.pack' })
  if not ok_setup then
    vim.notify('store.nvim setup failed: ' .. err, vim.log.levels.ERROR)
    return false
  end

  configured = true
  return true
end

local ok, store = pcall(require, 'store')
if not ok then
  vim.notify('store.nvim not loaded', vim.log.levels.WARN)
  return
end

local orig_open = store.open
store.open = function()
  if not ensure_setup() then
    return
  end

  local ok_open, err = pcall(orig_open)
  if not ok_open then
    vim.notify('store.nvim open failed: ' .. err, vim.log.levels.ERROR)
  end
end
