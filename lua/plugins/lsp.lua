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

      -- Optional: Java 21-for-jdtls-only prelude (paths via stdpath)
      local home = os.getenv 'HOME'
      local data = vim.fn.stdpath 'data'
      local jdtls_path = data .. '/mason/packages/jdtls'
      local jdtls_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
      local jdtls_cfg = jdtls_path .. '/config_mac'
      local jdtls_ws = home .. '/.cache/jdtls/' .. vim.fn.fnamemodify(vim.loop.cwd(), ':p:h:t')
      local JDK17 = home .. '/.jenv/versions/17'
      local JDK21 = home .. '/.jenv/versions/21'

      local servers = {
        clangd = {},
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
        jdtls = {
          cmd = {
            'java',
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-Xms1g',
            '--add-modules=ALL-SYSTEM',
            '--add-opens',
            'java.base/java.util=ALL-UNNAMED',
            '--add-opens',
            'java.base/java.lang=ALL-UNNAMED',
            '-jar',
            jdtls_jar,
            '-configuration',
            jdtls_cfg,
            '-data',
            jdtls_ws,
          },
          cmd_env = { JAVA_HOME = JDK21, PATH = JDK21 .. '/bin:' .. vim.env.PATH },
          settings = {
            java = {
              configuration = {
                runtimes = {
                  { name = 'JavaSE-17', path = JDK17 },
                  { name = 'JavaSE-21', path = JDK21, default = true },
                },
              },
            },
          },
        },
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
