return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<leader>dB",
                function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                desc =
                "Breakpoint Condition"
            },
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc =
                "Toggle Breakpoint"
            },
            {
                "<leader>dc",
                function() require("dap").continue() end,
                desc =
                "Continue"
            },
            {
                "<leader>dC",
                function() require("dap").run_to_cursor() end,
                desc =
                "Run to Cursor"
            },
            {
                "<leader>dg",
                function() require("dap").goto_() end,
                desc =
                "Go to line (no execute)"
            },
            {
                "<leader>di",
                function() require("dap").step_into() end,
                desc =
                "Step Into"
            },
            {
                "<leader>dj",
                function() require("dap").down() end,
                desc =
                "Down"
            },
            {
                "<leader>dk",
                function() require("dap").up() end,
                desc =
                "Up"
            },
            {
                "<leader>dl",
                function() require("dap").run_last() end,
                desc =
                "Run Last"
            },
            {
                "<leader>do",
                function() require("dap").step_out() end,
                desc =
                "Step Out"
            },
            {
                "<leader>dO",
                function() require("dap").step_over() end,
                desc =
                "Step Over"
            },
            {
                "<leader>dp",
                function() require("dap").pause() end,
                desc =
                "Pause"
            },
            {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                desc =
                "Toggle REPL"
            },
            {
                "<leader>ds",
                function() require("dap").session() end,
                desc =
                "Session"
            },
            {
                "<leader>dt",
                function() require("dap").terminate() end,
                desc =
                "Terminate"
            },
            {
                "<leader>dw",
                function() require("dap.ui.widgets").hover() end,
                desc =
                "Widgets"
            },
            {
                "<F10>",
                [[:lua require("dap").step_over()<cr>]],
                desc =
                "step over"
            },
            {
                "<F9>",
                [[:lua require("dap").toggle_breakpoint()<cr>]],
                desc =
                "toggle breakpoint"
            },
            {
                "<F11>",
                [[:lua require("dap").step_into()<cr>]],
                desc =
                "step into"
            },
        },
        config = function()
            require("user.plugins.dap.setting.codelldb")
            require("user.plugins.dap.setting.delve")
        end
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        ---@diagnostic disable: unused-local, undefined-field, undefined-doc-name, undefined-doc-param
        opts = {
            enabled = true,                     -- enable this plugin (the default)
            enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
            highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
            show_stop_reason = true,            -- show stop reason when stopped for exceptions
            commented = false,                  -- prefix virtual text with comment string
            only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
            all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
            --- A callback that determines how a variable is displayed or whether it should be omitted
            --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
            --- @param buf number
            --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
            --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
            --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
            display_callback = function(variable, _buf, _stackframe, _node)
                return variable.name .. ' = ' .. variable.value
            end,

            -- experimental features:
            virt_text_pos = 'eol',  -- position of virtual text, see `:h nvim_buf_set_extmark()`
            all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
            virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
        }
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text", "nvim-neo-tree/neo-tree.nvim" },
        keys = {
            { "<leader>dt", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle UI" },
            { "<leader>dt", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle UI" },
            { "<M-l>",      [[:lua require("dapui").eval()<cr>]],   "eval value" },
            { "<F5>", function()
                require("dapui").open()
                require("dap").continue()
            end, "debug continue"
            },
        },
        opts = {
            icons = {
                collapsed = "",
                current_frame = "",
                expanded = ""
            },
            mappings = {
                -- Use a table to apply multiple mappings
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
            -- Use this to override mappings for specific elements
            element_mappings = {
                -- Example:
                -- stacks = {
                --   open = "<CR>",
                --   expand = "o",
                -- }
            },
            -- Expand lines larger than the window
            -- Requires >= 0.7
            expand_lines = vim.fn.has("nvim-0.7") == 1,
            -- Layouts define sections of the screen to place windows.
            -- The position can be "left", "right", "top" or "bottom".
            -- The size specifies the height/width depending on position. It can be an Int
            -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
            -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
            -- Elements are the elements shown in the layout (in order).
            -- Layouts are opened in order so that earlier layouts take priority in window sizing.
            layouts = {
                {
                    elements = {
                        -- Elements can be strings or table with id and size keys.
                        { id = "scopes", size = 0.25 },
                        -- "breakpoints",
                        "stacks",
                        "watches",
                    },
                    size = 40, -- 40 columns
                    position = "left",
                },
                {
                    elements = {
                        "repl",
                        "console",
                    },
                    size = 0.25, -- 25% of total lines
                    position = "bottom",
                },
            },
            controls = {
                -- Requires Neovim nightly (or 0.8 when released)
                enabled = true,
                -- Display controls in this element
                -- element = "repl",
            },
            floating = {
                max_height = nil,  -- These can be integers or a float between 0 and 1.
                max_width = nil,   -- Floats will be treated as percentage of your screen.
                border = "single", -- Border style. Can be "single", "double" or "rounded"
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            windows = { indent = 1 },
            render = {
                max_type_length = nil, -- Can be integer or nil.
                max_value_lines = 100, -- Can be integer or nil.
            }
        },
        config = function(_, opts)
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dapui.setup(opts)
            vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
        end
    },
}
