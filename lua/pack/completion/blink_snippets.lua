return {
  new = function(opts)
    local source = require('blink.cmp.sources.snippets').new(opts)

    local original_get_completions = source.get_completions
    function source:get_completions(ctx, callback)
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
