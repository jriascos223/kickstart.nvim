-- ~/.config/nvim/lua/core/options.lua
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Kotlin/ktlint-compatible indentation (4 spaces)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line length indicator (ktlint: 120)
vim.opt.textwidth = 120
vim.opt.colorcolumn = '120'

-- Final newline (ktlint: insert_final_newline = true)
vim.opt.fixendofline = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.g.have_nerd_font = false

vim.api.nvim_create_user_command('CopyPath', function(opts)
  local path = vim.fn.expand '%:p'
  if opts.bang then
    -- :CopyPath! includes line number
    path = path .. ':' .. vim.fn.line '.'
  end
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end, { bang = true })
