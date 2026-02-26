return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
      'rcasia/neotest-java',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
          },
          require 'neotest-java' {
            ignore_wrapper = false,
          },
        },
      }
    end,
    keys = {
      { '<leader>tt', function() require('neotest').run.run() end, desc = 'Test: Run nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Test: Run file' },
      { '<leader>td', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Test: Debug nearest' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test: Toggle summary' },
      { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = 'Test: Show output' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Test: Toggle output panel' },
      { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Test: Stop' },
    },
  },
}
