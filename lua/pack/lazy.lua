local M = {}

local loaded = {}

function M.mark(plugin)
  loaded[plugin] = true
end

function M.is_loaded(plugin)
  return loaded[plugin] == true
end

function M.load(plugin, loader)
  if loaded[plugin] then
    return
  end
  loaded[plugin] = true
  vim.cmd.packadd(plugin)
  if loader then
    loader()
  end
end

function M.by_key(plugin, mode, keys, loader, run, opts)
  opts = opts or {}
  vim.keymap.set(mode, keys, function()
    M.load(plugin, loader)
    if run then
      run()
    end
  end, { desc = opts.desc })
end

function M.by_cmd(plugin, name, loader, cmd)
  vim.api.nvim_create_user_command(name, function(args)
    M.load(plugin, loader)
    local c = (cmd or name)
    local fargs = args.fargs
    if #fargs > 0 then
      vim.cmd(c .. ' ' .. table.concat(fargs, ' '))
    else
      vim.cmd(c)
    end
  end, { nargs = '*', complete = 'file' })
end

function M.by_filetype(plugin, fts, loader)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = fts,
    callback = function()
      M.load(plugin, loader)
    end,
  })
end

return M