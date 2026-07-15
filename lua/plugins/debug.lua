-- debug.lua

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {},
    }

    -- Python adapter
    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        cb {
          type = 'server',
          port = assert(port, '`connect.port` is required for a python `attach` configuration'),
          host = host,
          options = {
            source_filetype = 'python',
          },
        }
      else
        cb {
          type = 'executable',
          command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
          args = { '-m', 'debugpy.adapter' },
          options = {
            source_filetype = 'python',
          },
        }
      end
    end

    -- Python configurations
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          return '/usr/bin/python3'
        end,
      },
    }

    dap.adapters.kotlin = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/kotlin-debug-adapter/adapter/bin/kotlin-debug-adapter',
    }

    -- Kotlin configurations
    dap.configurations.kotlin = {
      {
        type = 'kotlin',
        name = 'Attach to healthcare-dev',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 51532,
        projectRoot = '${workspaceFolder}',
        timeout = 30000,
      },
      {
        type = 'kotlin',
        name = 'Attach to healthcare-events',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 28100,
        projectRoot = '${workspaceFolder}',
        timeout = 30000,
      },
      {
        type = 'kotlin',
        name = 'Attach to external-measurements-events',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 33715,
        projectRoot = '${workspaceFolder}',
        timeout = 30000,
      },
      {
        type = 'kotlin',
        name = 'Attach to external-measurements-app',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 17908,
        projectRoot = '${workspaceFolder}',
        timeout = 30000,
      },
      {
        type = 'kotlin',
        name = 'Attach to backend app',
        request = 'attach',
        hostName = '127.0.0.1',
        port = 5007,
        projectRoot = '${workspaceFolder}',
        timeout = 30000,
      },
      {
        type = 'kotlin',
        name = 'Attach to JVM (prompt for port)',
        request = 'attach',
        hostName = '127.0.0.1',
        port = function()
          return tonumber(vim.fn.input('Debug Port: ', '51532'))
        end,
        projectRoot = '${workspaceFolder}',
        timeout = 30000,
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
