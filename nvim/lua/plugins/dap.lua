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

      local phpDebugPath = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
      local netcoreDebugPath = require("mason-registry").get_package("netcoredbg"):get_install_path()

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { phpDebugPath .. "/extension/out/phpDebug.js" },
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

      dap.adapters.coreclr = {
        type = "executable",
        command = netcoreDebugPath .. "/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Dotnet Launch (console)",
          request = "launch",
          preLaunchTask = "build",
          program = function ()
            -- Get current project name from working directory
            local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            local path = vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. project .. ".dll"

            -- Check if the DLL exists
            if vim.fn.filereadable(path) == 1 then
              vim.notify("Using Path: " .. path)
              return path
            end

            -- Notify current directory if DLL not found
            vim.notify("Current directory: " .. vim.fn.getcwd())

            -- Search for a .csproj file in the working directory
            local files = vim.fn.glob(vim.fn.getcwd() .. "/*.csproj", false, true)
            if #files == 0 then
              vim.notify("No .csproj file found in directory.")
              return nil
            end

            -- Use the first .csproj file found and extract its name
            local file = files[1]
            project = vim.fn.fnamemodify(file, ":t:r")
            path = vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. project .. ".dll"

            vim.notify("Generated Path: " .. path)
            return path
          end,
          args = {},
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          console = "internalConsole",
        },
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

      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg='#524f67' }) -- Line highlight
      vim.api.nvim_set_hl(0, "DapStoppedSymbol", { fg='#eb6f92' })  -- Symbol highlight

      vim.fn.sign_define('DapBreakpoint', { text = '◆', texthl = 'DapBreakpoint', fg = '#9ccfd8' })

      -- Define DapStopped sign with the custom symbol and highlights
      vim.fn.sign_define('DapStopped', {
        text = '▸',  -- Use a different icon if needed
        texthl = 'DapStoppedSymbol',
        linehl = 'DapStoppedLine',
        numhl = 'DapStoppedLine',
      })

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  }
}
