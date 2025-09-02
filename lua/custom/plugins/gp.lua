return {
  {
    'robitx/gp.nvim',
    dependencies = { 'folke/which-key.nvim' },
    config = function()
      local conf = {
        -- get API key from macOS Keychain
        openai_api_key = { 'security', 'find-generic-password', '-a', os.getenv 'USER', '-s', 'OPENAI_API_KEY', '-w' },
      }
      require('gp').setup(conf)

      local wk = require 'which-key'
      wk.add({
        -- group label for the prefix
        { '<C-g>', group = '🤖GPT' },

        -- Chat
        { '<C-g>c', '<cmd>GpChatNew<CR>', desc = 'New chat', mode = { 'n', 'i' } },
        { '<C-g>t', '<cmd>GpChatToggle popup<CR>', desc = 'Toggle chat (popup)', mode = { 'n', 'i' } },
        { '<C-g>f', '<cmd>GpChatFinder<CR>', desc = 'Chat finder', mode = { 'n', 'i' } },
        { '<C-g>c', ":'<,'>GpChatNew<CR>", desc = 'Chat with selection', mode = 'v' },
        { '<C-g>p', ":'<,'>GpChatPaste<CR>", desc = 'Paste selection to chat', mode = 'v' },

        -- Edit-in-place
        { '<C-g>r', '<cmd>GpRewrite<CR>', desc = 'Rewrite (prompt)', mode = { 'n', 'i' } },
        { '<C-g>a', '<cmd>GpAppend<CR>', desc = 'Append after', mode = { 'n', 'i' } },
        { '<C-g>b', '<cmd>GpPrepend<CR>', desc = 'Prepend before', mode = { 'n', 'i' } },
        { '<C-g>r', ":'<,'>GpRewrite<CR>", desc = 'Rewrite selection', mode = 'v' },
        { '<C-g>a', ":'<,'>GpAppend<CR>", desc = 'Append selection', mode = 'v' },
        { '<C-g>b', ":'<,'>GpPrepend<CR>", desc = 'Prepend selection', mode = 'v' },
        { '<C-g>i', ":'<,'>GpImplement<CR>", desc = 'Implement from comments', mode = 'v' },

        -- Layout variants
        { '<C-g><C-x>', '<cmd>GpChatNew split<CR>', desc = 'New chat (split)', mode = { 'n', 'i' } },
        { '<C-g><C-v>', '<cmd>GpChatNew vsplit<CR>', desc = 'New chat (vsplit)', mode = { 'n', 'i' } },
        { '<C-g><C-t>', '<cmd>GpChatNew tabnew<CR>', desc = 'New chat (tab)', mode = { 'n', 'i' } },

        -- Agents & control
        { '<C-g>n', '<cmd>GpNextAgent<CR>', desc = 'Next agent', mode = { 'n', 'i' } },
        { '<C-g>l', '<cmd>GpSelectAgent<CR>', desc = 'Select agent', mode = { 'n', 'i' } },
        { '<C-g>s', '<cmd>GpStop<CR>', desc = 'Stop generation', mode = { 'n', 'i' } },
      }, { noremap = true, silent = true, nowait = true })
    end,
  },
}
