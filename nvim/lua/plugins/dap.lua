return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    -- stylua: ignore
    keys = function(_, keys)
      local dap = require 'dap'
      local dapui = require 'dapui'
      return {
        -- Basic debugging keymaps, feel free to change to your liking!
        { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
        { '<C-F5>' , dap.stop, desc = 'Debug: Stop' },
        { '<leader>ds' , dap.stop, desc = 'Debug: Stop' },
        { '<F10>', dap.step_over, desc = 'Debug: Step Over' },
        { '<F11>', dap.step_into, desc = 'Debug: Step Into' },
        { '<F12>', dap.step_out, desc = 'Debug: Step Out' },
        { '<F9>', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
        { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
        {
          '<leader>B',
          function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end,
          desc = 'Debug: Set Breakpoint',
        },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
        unpack(keys),
      }
    end,

    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { path .. "/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for XDebug",
          port = 9003,
          stopOnEntry = true,
          ignore = {"**/vendor/**/*.php"},
        },
        {
          type = "php",
          request = "launch",
          name = "Launch currently open script",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          port = 9003,
          stopOnEntry = true,
          ignore = {"**/vendor/**/*.php"},
        },
        {
          type = "php",
          request = "launch",
          name = "Launch Built-in web server",
          program = "${workspaceFolder}/index.php",
          cwd = "${workspaceFolder}",
          port = 9003,
          runtimeExecutable = "php",
          runtimeArgs = {
            "-S",
            "localhost:8080"
          },
          env = {
            XDEBUG_CONFIG = "idekey=neovim"
          },
          stopOnEntry = false,
          ignore = {"**/vendor/**/*.php"},
        }
      }

      require("mason-nvim-dap").setup({
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
          'php',
          'python',
          'node',
          'dotnet',
        },
      })

      dapui.setup {
        icons = {
          expanded = "▾",
          collapsed = "▸",
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  }
}
