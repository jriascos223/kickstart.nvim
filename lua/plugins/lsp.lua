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
      'b0o/schemastore.nvim',
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
        ts_ls = {},
        bashls = {},
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = true,
                url = 'https://www.schemastore.org/api/json/catalog.json',
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
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
          -- Like grr, but hides any reference whose file NAME contains "Test".
          map('grR', function()
            local ok, picker = pcall(require, 'snacks.picker')
            if ok and picker and type(picker.lsp_references) == 'function' then
              return picker.lsp_references {
                -- transform runs once per result item; return false to drop it.
                transform = function(item)
                  local name = item.file and vim.fn.fnamemodify(item.file, ':t') or ''
                  if name:find('Test', 1, true) then
                    return false
                  end
                  return item
                end,
              }
            end
            -- Fallback when Snacks isn't available: filter into the quickfix list.
            vim.lsp.buf.references({ includeDeclaration = true }, {
              on_list = function(res)
                local items = vim.tbl_filter(function(it)
                  local name = vim.fn.fnamemodify(it.filename or '', ':t')
                  return not name:find('Test', 1, true)
                end, res.items)
                vim.fn.setqflist({}, ' ', { title = res.title, items = items, context = res.context })
                vim.cmd 'botright copen'
              end,
            })
          end, '[G]oto [R]eferences (no Test files)')
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

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
      end

      -- Mason tooling
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'kotlin-lsp', 'shellcheck' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- handled by mason-tool-installer
        automatic_enable = {
          exclude = {
            'jdtls',
            -- handled by kotlin lsp below
            'kotlin_lsp',
          },
        },
        automatic_installation = false,
      }

      -- SourceKit-LSP (Swift) is not a Mason server -- it ships with the Swift
      -- toolchain. Its config lives in lsp/sourcekit.lua; just enable it here.
      vim.lsp.enable 'sourcekit'
    end,
  },
  {
    'AlexandrosAlexiou/kotlin.nvim',
    ft = { 'kotlin' },
    dependencies = {
      'mason.nvim',
      'mason-lspconfig.nvim',
      {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        opts = {},
      },
    },
    config = function()
      require('kotlin').setup {
        root_markers = {
          'gradlew',
          '.git',
          'mvnw',
          'settings.gradle',
        },

        jdk_for_symbol_resolution = nil, -- Auto-detect from project

        -- Uses bundled JRE from Mason (zero-dependency)
        jre_path = nil,

        jvm_args = {
          '-Xmx4g',
        },

        -- All inlay hints enabled by default
        inlay_hints = {
          enabled = true,
          parameters = true,
          parameters_compiled = true,
          parameters_excluded = false,
          types_property = true,
          types_variable = true,
          function_return = true,
          function_parameter = true,
          lambda_return = true,
          lambda_receivers_parameters = true,
          value_ranges = true,
          kotlin_time = true,
        },
      }

      -- Kotlin-only keymaps. References/rename/code-actions/symbols are intentionally
      -- NOT bound here: those go through the generic LspAttach maps (grr, grn, gra, gO,
      -- gW, grd, gri, grt) which give the Snacks picker + preview for kotlin_lsp too,
      -- since :KotlinReferences etc. are just wrappers around the standard vim.lsp.buf.*.
      vim.keymap.set('n', '<leader>lkq', ':KotlinQuickFix<CR>', { desc = 'Kotlin quick fix' })
      vim.keymap.set('n', '<leader>lko', ':KotlinOrganizeImports<CR>', { desc = 'Organize Kotlin imports' })
      vim.keymap.set('n', '<leader>lkf', ':KotlinFormat<CR>', { desc = 'Format Kotlin buffer (LSP)' })
      vim.keymap.set('n', '<leader>lkh', ':KotlinInlayHintsToggle<CR>', { desc = 'Toggle Kotlin inlay hints' })
      vim.keymap.set('n', '<leader>lkc', ':KotlinCleanWorkspace<CR>', { desc = 'Clean Kotlin workspace' })
    end,
  },
}
