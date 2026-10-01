vim.pack.add {
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/sudo-tee/opencode.nvim', version = 'v2' },
}

require('render-markdown').setup {
  completions = { blink = { enabled = true } },
  anti_conceal = { enabled = false },
  file_types = { 'markdown', 'opencode_output' },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'opencode_output',
  callback = function(args)
    vim.treesitter.language.register('markdown', 'opencode_output')
    pcall(vim.treesitter.start, args.buf, 'markdown')
  end,
})

local work_root = vim.fn.expand '~/Projects/Work'
local cwd = vim.fn.getcwd()
local in_work = cwd == work_root or cwd:sub(1, #work_root + 1) == work_root .. '/'

print(in_work and 'stormcode' or 'opencode')

require('opencode').setup {
  preferred_picker = 'snacks',
  lock_session_to_directory = true,
  default_mode = 'build',
  context = {
    cursor_data = { enabled = true, context_lines = 10 },
    git_diff = { enabled = true },
    buffer = { enabled = true },
    selection = { enabled = true },
  },
  hooks = {
    on_file_edited = function(file)
      local buf = vim.fn.bufnr(file)
      if buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_call(buf, function()
          pcall(require('conform').format, { async = true })
        end)
      end
    end,
  },
  ui = {
    enable_treesitter_markdown = true,
    window_width = 0.40,
    persist_state = false,
    output = {
      compact_assistant_headers = true,
      always_scroll_to_bottom = false,
      rendering = {
        -- markdown_on_idle = false,
        -- markdown_debounce_ms = 150,
      },
      tools = {
        use_folds = true,
        folding_threshold = 15,
        show_reasoning_output = true,
      },
    },
    input = {
      auto_hide = true,
      win_options = {
        conceallevel = 2,
        cursorline = true,
      },
    },
  },
  opencode_executable = in_work and 'stormcode' or 'opencode',
}
