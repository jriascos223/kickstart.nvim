-- ~/.config/nvim/lua/core/keymaps.lua
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', '<leader>ds', function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = 'Show diagnostics in floating window' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })
map('n', '<leader>cp', ':CopyPath<cr>', { desc = 'Copy file path' })
map('n', '<leader>cL', ':CopyPath!<cr>', { desc = 'Copy file path with line number' })

-- Proto symbol jump
map('n', '<leader>ps', function()
  local proto_root = vim.fn.expand '$HOME/noomdev/noom-contracts/noom_contracts'
  local cword = vim.fn.expand '<cword>'
  local default = cword:sub(1, 1):upper() .. cword:sub(2)
  vim.ui.input({ prompt = 'Proto symbol: ', default = default }, function(symbol)
    if not symbol or symbol == '' then
      return
    end
    local pattern = '\\b(message|service|enum)\\s+' .. symbol .. '\\b'
    local result = vim.fn.system {
      'rg', '-n', '-m', '1', '-H', '-P', '--no-heading', '--color=never',
      pattern, proto_root,
    }
    result = vim.trim(result)
    if result == '' then
      vim.notify('Proto symbol not found: ' .. symbol, vim.log.levels.WARN)
      return
    end
    local file, line = result:match('^([^:]+):(%d+):')
    if not file or not line then
      vim.notify('Could not parse rg output: ' .. result, vim.log.levels.ERROR)
      return
    end
    vim.cmd('edit +' .. line .. ' ' .. vim.fn.fnameescape(file))
  end)
end, { desc = 'Jump to Proto [S]ymbol' })
