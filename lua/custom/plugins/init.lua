-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    config = function()
      -- overcome floating window when pressing 'e'
      -- this referenced in ~/.config/lazygit/config.yml
      function EditLineFromLazygit(file_path, line)
        local path = vim.fn.expand '%:p'
        if path == file_path then
          vim.cmd(tostring(line))
        else
          vim.cmd('e ' .. file_path)
          vim.cmd(tostring(line))
        end
      end

      function EditFromLazygit(file_path)
        local path = vim.fn.expand '%:p'
        if path == file_path then
          return
        else
          vim.cmd('e ' .. file_path)
        end
      end
    end,
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '<leader>oc', '<CMD>Oil<CR>', { desc = 'Oil: open current dir' })
      vim.keymap.set('n', '<leader>or', function()
        local root = vim.fn.finddir('.git', vim.fn.expand '%:p' .. ';')
        if root == '' then
          root = vim.fn.expand '%:p:h'
        else
          root = vim.fn.fnamemodify(root, ':h')
        end
        require('oil').open(root)
      end, { desc = 'Open Oil.nvim at project root' })
    end,
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    config = function()
      vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions'
      require('auto-session').setup {
        auto_restore = true,
        auto_save = true,
        -- log_level = 'debug',
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      }
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  -- TODO: remove once happy with terminal.lua
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<c-t>]],
        direction = 'float',
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
        persist_size = true,
        start_in_insert = true,
        insert_mappings = true,
        close_on_exit = true,
      }
    end,
  },
}
