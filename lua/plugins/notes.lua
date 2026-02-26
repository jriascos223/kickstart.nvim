return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        { name = 'noom', path = '~/noomdev/obsidian' },
      },
      notes_subdir = 'notes',
      daily_notes = {
        folder = 'daily',
      },
      completion = {
        nvim_cmp = false,
      },
      ui = {
        enable = true,
        checkboxes = {
          [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          ['x'] = { char = '', hl_group = 'ObsidianDone' },
          ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
          ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        },
        external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
        reference_text = { hl_group = 'ObsidianRefText' },
        highlight_text = { hl_group = 'ObsidianHighlightText' },
        tags = { hl_group = 'ObsidianTag' },
      },
    },
    config = function(_, opts)
      require('obsidian').setup(opts)
      
      -- Set conceallevel for markdown files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
    keys = {
      { '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'Obsidian: New note' },
      { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = 'Obsidian: Search' },
      { '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Obsidian: Quick switch' },
      { '<leader>ot', '<cmd>ObsidianToday<cr>', desc = 'Obsidian: Today' },
    },
  },
}
