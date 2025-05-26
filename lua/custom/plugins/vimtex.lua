return {
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      vim.g.vimtex_view_general_viewer = 'zathura'

      -- vim.g.vimtex_syntax_conceal_disable = 1

      vim.g.vimtex_syntax_conceal = {
        item = 1, -- \item → bullet (•)
        macros = 1, -- \textbf, \emph → styled text
        accents = 1, -- \alpha → α, etc.  (optional)
        spacing = 0,
      }

      vim.g.vimtex_compiler_method = 'latexmk'

      -- Auto-start the compiler on first open
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'VimtexEventInitPost',
      --   once = true,
      --   command = 'VimtexCompile', -- equivalent to hitting `\ll`
      -- })
    end,
  },
}
