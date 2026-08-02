return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      -- Surface missing/failing formatters instead of silently no-op'ing
      -- (ktlint in particular is not installed via Mason).
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable = { kotlin = true, c = true, cpp = true, swift = true, json = true, yaml = true, typescriptreact = true, typescript = true }
        if disable[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = { lua = { 'stylua' }, kotlin = { 'ktlint' } },
    },
  },
}
