-- ~/.config/nvim/lua/plugins/init.lua
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins.ui' },
  { import = 'plugins.editing' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.cmp' },
  { import = 'plugins.lsp' },
  { import = 'plugins.formatting' },
  { import = 'plugins.debug' },
  { import = 'plugins.java' },
  { import = 'plugins.agent' },
  { import = 'plugins.database' },
  { import = 'plugins.rest' },
  { import = 'plugins.navigation' },
  { import = 'plugins.git' },
  { import = 'plugins.testing' },
  { import = 'plugins.notes' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
