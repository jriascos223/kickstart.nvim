return {
  {
    'folke/snacks.nvim',
    priority = 1000, lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true, replace_netrw = true, show_hidden = true,
        filters = { hidden = true, dotfiles = true, gitignored = true } },
      indent = { enabled = true }, input = { enabled = true }, picker = { enabled = true },
      notifier = { enabled = true }, quickfile = { enabled = true }, scope = { enabled = true },
      scroll = { enabled = true }, statuscolumn = { enabled = true }, words = { enabled = true },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
      local picker = require('snacks.picker')
      vim.keymap.set('n', '<leader>sf', function() picker.files() end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg', function() picker.grep() end,  { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sw', function() picker.grep_word() end, { desc = '[S]earch [W]ord' })
      vim.keymap.set('n', '<leader>sb', function() picker.lines() end, { desc = '[S]earch [B]uffer' })
      vim.keymap.set('n', '<leader>sr', function() picker.recent() end, { desc = '[S]earch [R]ecent' })
      vim.keymap.set('n', '<leader>sh', function() picker.help() end,  { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', function() picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
      vim.api.nvim_create_user_command('Ex', function(args)
        require('snacks').explorer { path = args.args ~= '' and args.args or '.' }
      end, { nargs = '?' })
      vim.api.nvim_create_user_command('Sex', function() require('snacks').explorer { direction = 'horizontal' } end, {})
      vim.api.nvim_create_user_command('Vex', function() require('snacks').explorer { direction = 'vertical' } end, {})
      vim.api.nvim_create_user_command('Tex', function() require('snacks').explorer { direction = 'tab' } end, {})
    end,
  },
  {
    'folke/which-key.nvim', event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font, keys = vim.g.have_nerd_font and {} or {
        Up='<Up> ',Down='<Down> ',Left='<Left> ',Right='<Right> ',C='<C-…> ',M='<M-…> ',D='<D-…> ',
        S='<S-…> ',CR='<CR> ',Esc='<Esc> ',Space='<Space> ',Tab='<Tab> ',
      }},
      spec = { { '<leader>s', group='[S]earch' }, { '<leader>t', group='[T]oggle' }, { '<leader>h', group='Git [H]unk', mode={'n','v'} } },
    },
  },
  { -- colorscheme
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup({ styles = { comments = { italic = false } } })
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },
  { -- mini.nvim statusline + core bits you used
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
}
