local function static_init_snippets()
  local luasnip_ok, luasnip = pcall(require, 'luasnip')
  if not luasnip_ok then
    return
  end
  for _, ft in ipairs(luasnip.get_snippet_filetypes()) do
    local snippets = luasnip.get_snippets(ft, { type = 'snippets' })
    for _, snippet in ipairs(snippets) do
      if snippet.nodes then
        for _, node in ipairs(snippet.nodes) do
          if node.static_init then
            pcall(node.static_init, node)
          end
        end
      end
    end
  end
end

return {
  new = function(opts)
    local source = require('blink.cmp.sources.snippets').new(opts)

    local original_get_completions = source.get_completions
    function source:get_completions(ctx, callback)
      static_init_snippets()
      local ok, result = pcall(original_get_completions, self, ctx, callback)
      if not ok then
        vim.schedule(function()
          vim.notify('blink snippets source failed: ' .. tostring(result), vim.log.levels.WARN)
        end)
        callback { is_incomplete_forward = false, is_incomplete_backward = false, items = {} }
      end
    end

    return source
  end,
}
