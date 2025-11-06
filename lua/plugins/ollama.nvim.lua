-- Plugin: nomnivore/ollama.nvim
-- Installed via store.nvim

vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/nomnivore/ollama.nvim' }

require('ollama').setup {
  model = 'mistral:8b',
  url = 'http://127.0.0.1:11434',
  serve = {
    on_start = false,
    command = 'ollama',
    args = { 'serve' },
    stop_command = 'pkill',
    stop_args = { '-SIGTERM', 'ollama' },
  },
  -- View the actual default prompts in ./lua/ollama/prompts.lua
  prompts = {
    Sample_Prompt = {
      prompt = 'This is a sample prompt that receives $input and $sel(ection), among others.',
      input_label = '> ',
      model = 'mistral',
      action = 'display',
    },
    -- Create 2 o 3 promts, for varius activity, like spell check and fix
  },
}

