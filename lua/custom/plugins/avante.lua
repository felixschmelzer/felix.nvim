return {
  {
    'yetone/avante.nvim',
    build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
    event = 'VeryLazy',
    version = false,

    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'openai',
      providers = {
        openai = {
          endpoint = 'https://api.openai.com/v1',
          model = 'gpt-4o-mini', -- or "gpt-4.1-mini"
          timeout = 30000,

          extra_request_body = {
            temperature = 0.3,
            max_tokens = 2048, -- try 1024–4096; lower = fewer TPM spikes
          },

          -- ✅ Avante supports cmd:... for api_key_name
          api_key_name = 'cmd:security find-generic-password -a "$USER" -s OPENAI_API_KEY -w 2>/dev/null',
        },
      },
    },

    -- ✅ Ctrl+g shortcuts (+ which-key descriptions)
    keys = {
      { '<C-g>', desc = '+avante' },

      { '<C-g>a', '<cmd>AvanteAsk<cr>', desc = 'Ask' },
      { '<C-g>c', '<cmd>AvanteChat<cr>', desc = 'Chat' },
      { '<C-g>n', '<cmd>AvanteChatNew<cr>', desc = 'New chat' },
      { '<C-g>t', '<cmd>AvanteToggle<cr>', desc = 'Toggle UI' },
      { '<C-g>r', '<cmd>AvanteRefresh<cr>', desc = 'Refresh' },

      -- handy with visual selections
      { '<C-g>e', '<cmd>AvanteEdit<cr>', desc = 'Edit selection', mode = { 'n', 'v' } },
    },

    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-mini/mini.pick',
      'nvim-telescope/telescope.nvim',
      'hrsh7th/nvim-cmp',
      'ibhagwan/fzf-lua',
      'stevearc/dressing.nvim',
      'folke/snacks.nvim',
      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = { file_types = { 'markdown', 'Avante' } },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
