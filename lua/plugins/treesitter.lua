return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      require('nvim-treesitter').install {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'kotlin',
        'java',
        'python',
        'typescript',
        'tsx',
        'sql',
        'proto',
        'graphql',
        'terraform',
        'yaml',
        'json',
        'dockerfile',
      }

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nvim-treesitter-highlight', { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
