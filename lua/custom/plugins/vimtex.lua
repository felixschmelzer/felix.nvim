return {
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      vim.g.vimtex_view_general_viewer = 'zathura'

      vim.g.vimtex_syntax_conceal_disable = 1

      vim.g.vimtex_syntax_conceal = {
        item = 1, -- \item → bullet (•)
        macros = 1, -- \textbf, \emph → styled text
        accents = 1, -- \alpha → α, etc.  (optional)
      }

      -- Make sure 'conceallevel' is set *per* TeX buffer
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'tex', 'plaintex' },
        callback = function()
          vim.wo.conceallevel = 1 -- show replacement chars
          vim.wo.concealcursor = '' -- only hide when cursor not in the line
        end,
      })
    end,
  },
}
