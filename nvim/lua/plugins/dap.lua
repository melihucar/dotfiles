
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

            "mfussenegger/nvim-dap-python",
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

            dap.adapters.debugpy = {
                type = 'executable',
                command = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/debugpy/venv/bin/python',
                args = { '-m', 'debugpy.adapter' },
            }

            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            require("dap-python").resolve_python = function()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    return venv .. "/bin/python"
                end
                return "python3"
            end
            require("dap-python").test_runner = "pytest"

            -- C/C++/Objective-C debugging via codelldb
            dap.adapters.codelldb = {
                type = 'server',
                port = '${port}',
                executable = {
                    command = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
                    args = { '--port', '${port}' },
                },
            }

            local c_cpp_config = {
                {
                    name = 'Launch file',
                    type = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
                {
                    name = 'Attach to process',
                    type = 'codelldb',
                    request = 'attach',
                    pid = require('dap.utils').pick_process,
                    cwd = '${workspaceFolder}',
                },
            }

            dap.configurations.c = c_cpp_config
            dap.configurations.cpp = c_cpp_config
            dap.configurations.objc = c_cpp_config

            -- PHP debugging via php-debug-adapter
            dap.adapters.php = {
                type = 'executable',
                command = 'node',
                args = { os.getenv("HOME") .. '/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js' },
            }

            dap.configurations.php = {
                {
                    name = 'Listen for Xdebug',
                    type = 'php',
                    request = 'launch',
                    port = 9003,
                },
                {
                    name = 'Launch current script',
                    type = 'php',
                    request = 'launch',
                    program = '${file}',
                    cwd = '${workspaceFolder}',
                    port = 9003,
                    runtimeArgs = { '-dxdebug.start_with_request=yes' },
                    env = { XDEBUG_MODE = 'debug', XDEBUG_CONFIG = 'client_port=9003' },
                },
            }

            require("mason-nvim-dap").setup({
                automatic_installation = true,
                handlers = {},
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
