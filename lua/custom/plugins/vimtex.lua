return {
  {
    'lervag/vimtex',
    lazy = false,

    init = function()
      -- Viewer: simpler & mac-safe
      vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 0 -- no focus on jump

      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = { out_dir = 'output' }

      -- Nvr need to be installed: brew install neovim-remote
      vim.g.vimtex_compiler_progname = 'nvr'

      -- Optional: open the PDF after a successful compile
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VimtexEventCompileSuccess',
        callback = function()
          vim.cmd 'VimtexView'
        end,
      })

      -- Keep Skim in sync when you stop moving the cursor for a short moment
      vim.o.updatetime = 700 -- milliseconds; tweak to taste

      local group = vim.api.nvim_create_augroup('VimtexSkimAutoSync', { clear = true })
      local last_view_line = -1

      vim.api.nvim_create_autocmd({ 'CursorHold', 'BufEnter' }, {
        group = group,
        pattern = '*.tex',
        callback = function()
          if not vim.b.vimtex then
            return
          end -- only in VimTeX buffers
          local line = vim.api.nvim_win_get_cursor(0)[1]
          if line == last_view_line then
            return
          end -- skip duplicate positions
          last_view_line = line
          vim.cmd 'silent! VimtexView' -- jump Skim to here (no refocus)
        end,
      })
    end,
  },
}
