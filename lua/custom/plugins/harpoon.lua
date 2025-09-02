return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'VeryLazy', -- load after startup
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- comment out if you don’t use Telescope
    },
    config = function()
      ------------------------------------------------------------------
      -- core setup -----------------------------------------------------
      ------------------------------------------------------------------
      local harpoon = require 'harpoon'

      harpoon:setup {
        settings = {
          save_on_toggle = true, -- write list whenever you show / hide the UI
          sync_on_index = true, -- keep cursor position in sync
        },
      }

      ----------------------------------------------------------------
      -- basic key-maps -------------------------------------------------
      ------------------------------------------------------------------
      local add_desc = 'Harpoon: add file'
      local menu_desc = 'Harpoon: quick-menu'
      local jump_desc = function(n)
        return ('Harpoon: to file %d'):format(n)
      end
      local nav_desc = function(dir)
        return ('Harpoon: %s file'):format(dir)
      end

      -- add current file
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = add_desc })

      -- quick menu
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = menu_desc })

      -- direct jumps (slots 1-4) – change to <C-h/t/n/s> if you don’t need the window-nav keys
      vim.keymap.set('n', '<leader>1', function()
        harpoon:list():select(1)
      end, { desc = jump_desc(1) })
      vim.keymap.set('n', '<leader>2', function()
        harpoon:list():select(2)
      end, { desc = jump_desc(2) })
      vim.keymap.set('n', '<leader>3', function()
        harpoon:list():select(3)
      end, { desc = jump_desc(3) })
      vim.keymap.set('n', '<leader>4', function()
        harpoon:list():select(4)
      end, { desc = jump_desc(4) })
      vim.keymap.set('n', '<leader>5', function()
        harpoon:list():select(5)
      end, { desc = jump_desc(5) })

      -- previous / next
      vim.keymap.set('n', '<leader>p', function()
        harpoon:list():prev()
      end, { desc = nav_desc 'prev' })
      vim.keymap.set('n', '<leader>n', function()
        harpoon:list():next()
      end, { desc = nav_desc 'next' })

      ------------------------------------------------------------------
      -- Telescope picker ----------------------------------------------
      ------------------------------------------------------------------
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(paths, item.value)
        end
        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table { results = paths },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>e', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Harpoon: Telescope picker' })
    end,
  },
}
