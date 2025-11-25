return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- (your LspAttach, diagnostics config, capabilities, etc.)

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        clangd = {},
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
        kotlin_lsp = {},
      }

      local ensure = vim.tbl_keys(servers)
      vim.list_extend(ensure, { 'stylua', 'clangd' })
      require('mason-tool-installer').setup { ensure_installed = ensure }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
