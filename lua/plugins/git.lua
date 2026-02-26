return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git: Open diffview' },
      { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = 'Git: Close diffview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git: File history' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git: Branch history' },
    },
    opts = {},
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    opts = {
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Git: Neogit' },
      { '<leader>gC', '<cmd>Neogit commit<cr>', desc = 'Git: Commit' },
    },
  },
}
