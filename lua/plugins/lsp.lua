-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
      -- snacks.nvim must already be installed/loaded elsewhere in your setup
    },
    config = function()
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, fn, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- tiny helper
          local function chooser(snacks_name, lsp_fn)
            return function()
              local ok, picker = pcall(require, 'snacks.picker')
              if ok and picker and type(picker[snacks_name]) == 'function' then
                return picker[snacks_name]()
              end
              return lsp_fn()
            end
          end

          -- always-safe natives
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Snacks-first, LSP fallback
          map('grd', chooser('lsp_definitions', vim.lsp.buf.definition), '[G]oto [D]efinition')
          map(
            'grr',
            chooser('lsp_references', function()
              vim.lsp.buf.references { includeDeclaration = true }
            end),
            '[G]oto [R]eferences'
          )
          map('gri', chooser('lsp_implementations', vim.lsp.buf.implementation), '[G]oto [I]mplementation')
          map('grt', chooser('lsp_type_definitions', vim.lsp.buf.type_definition), '[G]oto [T]ype Definition')
          map('gO', chooser('lsp_document_symbols', vim.lsp.buf.document_symbol), 'Open Document Symbols')
          map('gW', function()
            local ok, picker = pcall(require, 'snacks.picker')
            if ok and picker and type(picker.lsp_workspace_symbols) == 'function' then
              return picker.lsp_workspace_symbols()
            end
            -- minimal interactive fallback when no Snacks:
            vim.ui.input({ prompt = 'Workspace symbols: ' }, function(q)
              if q and #q > 0 then
                vim.lsp.buf.workspace_symbol(q)
              end
            end)
          end, 'Open Workspace Symbols')
        end,
      })

      -- Diagnostics UI
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(d)
            local M = {
              [vim.diagnostic.severity.ERROR] = d.message,
              [vim.diagnostic.severity.WARN] = d.message,
              [vim.diagnostic.severity.INFO] = d.message,
              [vim.diagnostic.severity.HINT] = d.message,
            }
            return M[d.severity]
          end,
        },
      }

      -- Capabilities (blink.cmp)
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Mason tooling
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua', 'clangd', 'jdtls' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- handled by mason-tool-installer
        automatic_enable = false,
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
