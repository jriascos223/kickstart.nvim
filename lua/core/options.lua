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
-- Neovim seeds 'shell' from $SHELL but leaves 'shellcmdflag' at the cmd.exe
-- default, so launching from a POSIX prompt on Windows (devkitPro's
-- msys2_shell.bat, Git Bash) produces `bash /s /c ...` -- bash reads /s as a
-- path and every plugin that shells out breaks, e.g. :TSInstall dies with
-- "/s: Is a directory". Pin the native defaults; run POSIX tooling explicitly
-- through msys2 bash (see :DkpMake) rather than by inheriting it here.
if vim.fn.has 'win32' == 1 then
  vim.o.shell = 'cmd.exe'
  vim.o.shellcmdflag = '/s /c'
  vim.o.shellquote = ''
  vim.o.shellxquote = '"'
  vim.o.shellxescape = ''
  vim.o.shellredir = '>%s 2>&1'
  -- Not nvim's '2>&1| tee' default. tee itself is fine here, but a 'makeprg'
  -- that contains quotes -- which the devkitPro build needs, see
  -- core/devkitpro.lua -- gets mangled when cmd.exe re-quotes the whole command
  -- around the pipe: :make then writes no errorfile at all and quickfix comes
  -- back empty with E40. The plain redirect composes correctly either way.
  vim.o.shellpipe = '>%s 2>&1'
  vim.o.shellslash = false
end

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
vim.opt.jumpoptions:append 'view'
