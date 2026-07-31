vim.pack.add({
  'https://github.com/yetone/avante.nvim',

  -- Deps
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',

  -- Optional deps
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/HakonHarnes/img-clip.nvim',
}, { confirm = false, load = true })

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('avante_build', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'avante.nvim' then
      return
    end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then
      return
    end
    vim.system({ 'make' }, { cwd = ev.data.path }):wait()
  end,
})

local rm_ok, rm = pcall(require, 'render-markdown')
if rm_ok then
  rm.setup {
    file_types = { 'markdown', 'Avante' },
  }
end

require('avante').setup {
  provider = 'opencode',
  providers = {
    ['opencode-zen'] = {
      __inherited_from = 'openai',
      endpoint = 'https://opencode.ai/zen/v1',
      model = 'deepseek-v4-flash',
      api_key_name = 'OPENCODE_ZEN_API_KEY',
    },
  },
  acp_providers = {
    ['opencode'] = {
      command = 'opencode',
      model = 'deepseek-v4-flash',
      args = { 'acp' },
    },
  },
  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true,
    enable_token_counting = true,
    auto_add_current_file = true,
    auto_approve_tool_permissions = true,
    confirmation_ui_style = 'inline_buttons',
    acp_follow_agent_locations = true,
  },
}

vim.keymap.set({ 'n', 'x' }, '<leader>na', '<cmd>AvanteAsk<CR>', { desc = 'Avante ask' })
vim.keymap.set({ 'n', 'x' }, '<leader>nc', '<cmd>AvanteChat<CR>', { desc = 'Avante chat' })
vim.keymap.set('n', '<leader>ne', '<cmd>AvanteEdit<CR>', { desc = 'Avante edit' })
vim.keymap.set('n', '<leader>nt', '<cmd>AvanteToggle<CR>', { desc = 'Avante toggle' })
vim.keymap.set('n', '<leader>ns', '<cmd>AvanteStop<CR>', { desc = 'Avante stop' })
vim.keymap.set('n', '<leader>nn', '<cmd>AvanteClear<CR>', { desc = 'Avante new chat' })
