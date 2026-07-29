local ok, local_cfg = pcall(require, 'pack.completion.llm-local')

local base = {
  api_key = function()
    local cfg = ok and local_cfg
    return (cfg and cfg.api_key) or vim.env.LLM_API_KEY or ''
  end,
  end_point = (ok and local_cfg and local_cfg.base_url) or 'http://localhost:4000/v1/chat/completions',
  optional = {
    reasoning_effort = 'none',
  },
}

require('minuet').setup {
  provider = 'openai_compatible',
  notify = 'debug',
  provider_options = {
    openai_compatible = vim.tbl_extend('force', base, {
      model = (ok and local_cfg and local_cfg.model) or 'storm-coder',
      name = 'storm-coder',
    }),
  },
  presets = {
    storm = { model = 'storm-coder' },
    alt = { model = 'Qwen3.6-27B-INT4' },
  },
}
