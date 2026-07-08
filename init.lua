-- Leader must be set before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Faster Lua module loading (Neovim 0.9+)
pcall(function()
  vim.loader.enable()
end)

-- Core config
require 'core.options'
require 'core.keymaps'
require 'core.autocmds'

-- Plugins (lazy.nvim bootstrap + specs)
require 'plugins'

-- Optional per-machine overrides (won't error if missing)
pcall(require, 'local')
