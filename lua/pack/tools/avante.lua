vim.pack.add({
  'https://github.com/yetone/avante.nvim',

  -- Deps
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',

  -- Optional deps
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/HakonHarnes/img-clip.nvim',
}, { confirm = false, load = false })

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

local lazy = require 'pack.lazy'

local function load_avante()
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
      auto_set_keymaps = false,
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
end

local a_cmd = function(cmd)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<cmd>' .. cmd .. '<CR>', true, false, true), 'n', false)
  end
end

lazy.by_key('avante.nvim', { 'n', 'x' }, '<leader>na', load_avante, a_cmd 'AvanteAsk', { desc = 'Avante ask' })
lazy.by_key('avante.nvim', { 'n', 'x' }, '<leader>nc', load_avante, a_cmd 'AvanteChat', { desc = 'Avante chat' })
lazy.by_key('avante.nvim', 'n', '<leader>ne', load_avante, a_cmd 'AvanteEdit', { desc = 'Avante edit' })
lazy.by_key('avante.nvim', 'n', '<leader>nt', load_avante, a_cmd 'AvanteToggle', { desc = 'Avante toggle' })
lazy.by_key('avante.nvim', 'n', '<leader>ns', load_avante, a_cmd 'AvanteStop', { desc = 'Avante stop' })
lazy.by_key('avante.nvim', 'n', '<leader>nn', load_avante, a_cmd 'AvanteClear', { desc = 'Avante new chat' })
