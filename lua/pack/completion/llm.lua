local ok, local_cfg = pcall(require, 'pack.completion.llm-local')

require('cmp-llm').setup({
  api_key = (ok and local_cfg and local_cfg.api_key) or vim.env.LLM_API_KEY,
  base_url = (ok and local_cfg and local_cfg.base_url) or 'http://localhost:4000/v1/chat/completions',
  model = (ok and local_cfg and local_cfg.model) or 'storm-coder',
  debug = {
    enabled = true,
    log_api_requests = true,
    log_api_responses = true,
    log_prompts = true,
    log_completions = true,
    output_to_file = true,
    debug_file = '/tmp/cmp-llm-debug.log',
  },
})
