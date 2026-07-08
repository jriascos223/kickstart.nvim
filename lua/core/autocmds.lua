-- ~/.config/nvim/lua/core/autocmds.lua
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('core-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
