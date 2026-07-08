return {
  {
    'xTacobaco/cursor-agent.nvim',
    config = function()
      require('cursor-agent').setup({
        cmd = vim.fn.expand('~/.local/bin/cursor-agent'),
      })
      vim.keymap.set('n', '<leader>ca', ':CursorAgent<CR>', { desc = 'Cursor Agent: Toggle terminal' })
      vim.keymap.set('v', '<leader>ca', ':CursorAgentSelection<CR>', { desc = 'Cursor Agent: Send selection' })
      vim.keymap.set('n', '<leader>cA', ':CursorAgentBuffer<CR>', { desc = 'Cursor Agent: Send buffer' })
      vim.keymap.set('n', '<leader>cl', ':CursorAgentListConversations<CR>', { desc = 'Cursor Agent: List conversations' })
      vim.keymap.set('n', '<leader>cr', ':CursorAgentResumeConversation<CR>', { desc = 'Cursor Agent: Resume conversation' })
    end,
  },
}
