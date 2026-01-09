-- util: read OpenAI key from macOS Keychain
local function get_openai_api_key()
  local handle = io.popen 'security find-generic-password -s openai-api-key -w 2>/dev/null'
  if not handle then
    return nil
  end
  local result = handle:read '*a'
  handle:close()
  return result and result:gsub('%s+', '') or nil
end

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
          model = 'gpt-4.1',
          timeout = 30000,

          -- ✅ Avante supports cmd:... for api_key_name
          api_key_name = 'cmd:security find-generic-password -s openai-api-key -w 2>/dev/null',

          extra_request_body = {
            temperature = 0.75,
            max_tokens = 16384,
          },
        },
      },
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
