return {
  {
    'allaman/emoji.nvim',
    version = '1.0.0', -- optionally pin to a tag
    ft = 'markdown', -- adjust to your needs
    dependencies = {
      -- util for handling paths
      'nvim-lua/plenary.nvim',
      -- optional for nvim-cmp integration
      'hrsh7th/nvim-cmp',
      -- optional for telescope integration
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      -- default is false, also needed for blink.cmp integration!
      -- I disabled cmp integration, if you want to add it, remove the comment in init.lua under cmp sources
      enable_cmp_integration = true,
    },
    config = function(_, opts)
      require('emoji').setup(opts)
      -- optional for telescope integration
      local ts = require('telescope').load_extension 'emoji'
      vim.keymap.set('n', '<leader>se', ts.emoji, { desc = '[S]earch [E]moji' })
    end,
  },
}
