return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        keys = {
            {
                "<leader>e",
                function()
                    local ok, dir = pcall(require "user.utils".get_root)
                    if ok == true then
                        require("neo-tree.command").execute({
                            toggle = true,
                            dir = dir
                        })
                    else
                        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                    end
                end,
                desc = "Explorer(root dir)",
                remap = true
            },
            {
                "<leader>E",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                desc = "Explorer(cwd)",
                remap = true
            },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv()[1])
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                group_empty_dirs = true,
                scan_mode = "deep",
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },


    -- show color
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPost",
        config = function()
            require 'colorizer'.setup()
        end
    },

    -- LSP加载进度条
    {
        "j-hui/fidget.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            progress = {
                poll_rate = 0.5,
                ignore_done_already = true,
                suppress_on_insert = true,
                ignore_empty_message = true
            },
            display = {
                -- 只持续两秒
                done_ttl = 2
            }
        },
        enabled = function()
            if vim.g.neovide then
                return true
            else
                return false
            end
        end
    },
    -- git sign
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>",    desc = "Next Hunk" },
            { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",    desc = "Prev Hunk" },
            { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",   desc = "Blame" },
            { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
            { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",   desc = "Reset Hunk" },
            { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
            { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",   desc = "Stage Hunk" },
            {
                "<leader>gu",
                "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
                desc = "Undo Stage Hunk",
            },
            { "<leader>go", "<cmd>Telescope git_status<cr>",   desc = "Open changed file" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
            { "<leader>gc", "<cmd>Telescope git_commits<cr>",  desc = "Checkout commit" },
            {
                "<leader>gd",
                "<cmd>Gitsigns diffthis HEAD<cr>",
                desc = "Diff",
            },
        },
        opts = {
            signs = {
                add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
                change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
                delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "契",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn"
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "▎",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn"
                },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter_opts = {
                relative_time = false,
            },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000,
            preview_config = {
                -- Options passed to nvim_open_win
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            yadm = {
                enable = false,
            },
        }
    },
    {
        "akinsho/toggleterm.nvim",
        keys = {
            { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>",                   desc = "Lazygit" },
            { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>",                      desc = "Node" },
            { "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<cr>",                      desc = "NCDU" },
            { "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<cr>",                      desc = "Htop" },
            { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>",                    desc = "Python" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",              desc = "Float" },
            { [[<c-\>]],    "<cmd>ToggleTerm direction=float<cr>",              desc = "Float" },
            { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
            { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",   desc = "Vertical" },
            { '<esc>',      [[<C-\><C-n>]],                                     mode = 't',         noremap = true },
            { 'jk',         [[<C-\><C-n>]],                                     mode = 't',         noremap = true },
            { '<C-h>',      [[<C-\><C-n><C-W>h]],                               mode = 't',         noremap = true },
            { '<C-j>',      [[<C-\><C-n><C-W>j]],                               mode = 't',         noremap = true },
            { '<C-k>',      [[<C-\><C-n><C-W>k]],                               mode = 't',         noremap = true },
            { '<C-l>',      [[<C-\><C-n><C-W>l]],                               mode = 't',         noremap = true },
        },
        config = function()
            local toggleterm = require "toggleterm"

            toggleterm.setup({
                size = 20,
                open_mapping = [[<c-\>]],
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = "float",
                close_on_exit = true,
                shell = vim.o.shell,
                float_opts = {
                    border = "curved",
                    winblend = 0,
                    highlights = {
                        border = "Normal",
                        background = "Normal",
                    },
                },
            })

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

            function _LAZYGIT_TOGGLE()
                lazygit:toggle()
            end

            local node = Terminal:new({ cmd = "node", hidden = true })

            function _NODE_TOGGLE()
                node:toggle()
            end

            local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

            function _NCDU_TOGGLE()
                ncdu:toggle()
            end

            local htop = Terminal:new({ cmd = "htop", hidden = true })

            function _HTOP_TOGGLE()
                htop:toggle()
            end

            local python = Terminal:new({ cmd = "python", hidden = true })

            function _PYTHON_TOGGLE()
                python:toggle()
            end
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim'
        },
        keys = {
            { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
            { "<leader>sc", "<cmd>Telescope colorscheme<cr>",  desc = "Colorscheme" },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>",    desc = "Find Help" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>",    desc = "Man Pages" },
            { "<leader>sr", "<cmd>Telescope oldfiles<cr>",     desc = "Open Recent File" },
            { "<leader>sR", "<cmd>Telescope registers<cr>",    desc = "Registers" },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>",      desc = "Keymaps" },
            { "<leader>sC", "<cmd>Telescope commands<cr>",     desc = "Commands" },
            { "<leader>sn", "<cmd>Telescope notify<cr>",       desc = "Notify" },
            {
                "<leader>f",
                "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
                desc = "Find files",
            },
            { "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>",                           desc = "Find Text" },
            { "<leader>p", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
        },
        config = function()
            local telescope = require "telescope"
            local actions = require "telescope.actions"
            telescope.setup {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,

                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,

                            ["<C-c>"] = actions.close,

                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,

                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,

                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,

                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,

                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-l>"] = actions.complete_tag,
                            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                        },

                        n = {
                            ["<esc>"] = actions.close,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,

                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["H"] = actions.move_to_top,
                            ["M"] = actions.move_to_middle,
                            ["L"] = actions.move_to_bottom,

                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["gg"] = actions.move_to_top,
                            ["G"] = actions.move_to_bottom,

                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,

                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,

                            ["?"] = actions.which_key,
                        },
                    },
                },
                pickers = {
                    -- Default configuration for builtin pickers goes here:
                    -- picker_name = {
                    --   picker_config_key = value,
                    --   ...
                    -- }
                    -- Now the picker_config_key will be applied every time you call this
                    -- builtin picker
                },
                extensions = {
                    -- Your extension configuration goes here:
                    -- extension_name = {
                    --   extension_config_key = value,
                    -- }
                    -- please take a look at the readme of the extension you want to configure
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    }
                },
            }
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        dependencies = {
            "moll/vim-bbye"
        },
        config = function()
            local which_key = require "which-key"

            local setup = {
                plugins = {
                    marks = true,         -- shows a list of your marks on ' and `
                    registers = true,     -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                    spelling = {
                        enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                        suggestions = 20, -- how many suggestions should be shown in the list?
                    },
                    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                    -- No actual key bindings are created
                    presets = {
                        operators = false,   -- adds help for operators like d, y, ... and registers them for motion / text object completion
                        motions = false,     -- adds help for motions
                        text_objects = true, -- help for text objects triggered after entering an operator
                        windows = true,      -- default bindings on <c-w>
                        nav = false,         -- misc bindings to work with windows
                        z = true,            -- bindings for folds, spelling and others prefixed with z
                        g = true,            -- bindings for prefixed with g
                    },
                },
                -- add operators that will trigger motion and text object completion
                -- to enable all native operators, set the preset / operators plugin above
                -- operators = { gc = "Comments" },
                key_labels = {
                    -- override the label used to display some keys. It doesn't effect WK in any other way.
                    -- For example:
                    -- ["<space>"] = "SPC",
                    -- ["<cr>"] = "RET",
                    -- ["<tab>"] = "TAB",
                },
                icons = {
                    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                    separator = "➜", -- symbol used between a key and it's label
                    group = "+", -- symbol prepended to a group
                },
                popup_mappings = {
                    scroll_down = "<c-d>", -- binding to scroll down inside the popup
                    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
                },
                window = {
                    border = "rounded",       -- none, single, double, shadow
                    position = "bottom",      -- bottom, top
                    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
                    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
                    winblend = 0,
                },
                layout = {
                    height = { min = 4, max = 25 },                                           -- min and max height of the columns
                    width = { min = 20, max = 50 },                                           -- min and max width of the columns
                    spacing = 20,                                                             -- spacing between columns
                    align = "center",                                                         -- align columns left, center or right
                },
                ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
                hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
                show_help = false,                                                            -- show help message on the command line when the popup is visible
                show_key = false,
                triggers = "auto",                                                            -- automatically setup triggers
                -- triggers = {"<leader>"} -- or specify a list manually
                triggers_blacklist = {
                    -- list of mode / prefixes that should never be hooked by WhichKey
                    -- this is mostly relevant for key maps that start with a native binding
                    -- most people should not need to change this
                    i = { "j", "k" },
                    v = { "j", "k" },
                },
            }

            local opts = {
                mode = "n",     -- NORMAL mode
                prefix = "<leader>",
                buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
                silent = true,  -- use `silent` when creating keymaps
                noremap = true, -- use `noremap` when creating keymaps
                nowait = true,  -- use `nowait` when creating keymaps
            }

            local mappings = {
                ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
                ["b"] = {
                    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
                    "Buffers",
                },
                -- ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
                ["w"] = { "<cmd>w!<CR>", "Save" },
                ["q"] = { "<cmd>q!<CR>", "Quit" },
                ["Q"] = { "<cmd>qa!<CR>", "Quit All" },
                ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
                ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
                d = {
                    name = "+Debug",
                },
                g = {
                    name = "+Git",
                },
                j = {
                    name = "+Persistence",
                },
                l = {
                    name = "+LSP",
                },
                s = {
                    name = "+Search",
                },
                t = {
                    name = "+Terminal",
                },
                x = {
                    name = "+Diagnostics",
                },
                z = {
                    name = "+Immersive"
                },
                u = {
                    name = "+Utils",
                    r = { [[<cmd>lua ReloadConfig()<CR>]], "Reload Config" },
                    s = { "<cmd>SwitchIndent<CR>", "Switch Indent" },
                    c = { "<cmd>tabnew $MYVIMRC <CR>", "Config Nvim" },
                    w = { "<cmd>SwitchWrap<CR>", "Switch Wrap" },
                    n = { "<cmd>SwitchNumber<CR>", "Switch Number" },
                    i = { "<cmd>TSNodeUnderCursor<CR>", "Show TS Node" }
                }
            }

            which_key.setup(setup)
            which_key.register(mappings, opts)
        end
    },
    -- 增强quickfix
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        opts = {
            preview = {
                winblend = 0
            }
        }
    },
    -- todo优化
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to   the default settings
                -- refer to the configuration section below
            }
        end
    },
    {
        "ahmedkhalf/project.nvim",
        main = "project_nvim",
        event = "VeryLazy",
        config = function()
            require("project_nvim").setup {
            }
        end
    },
    {
        "andymass/vim-matchup",
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            -- may set any options here
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end

    },
    -- 只高亮有关内容
    {
        "folke/twilight.nvim",
        keys = {
            { "<leader>zd", "<cmd>Twilight<cr>", desc = "Toggle Twilight" }
        },
        cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
        opts = {}
    },
    -- 禅模式
    {
        "folke/zen-mode.nvim",
        keys = {
            { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" }
        },
        cmd = { "ZenMode" },
        opts = {}
    },
    -- 退出重进nvim恢复原来的状态
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        keys = {
            { "<leader>js", [[<cmd>lua require("persistence").load()<cr>]],                desc = "load state" },
            { "<leader>jl", [[<cmd>lua require("persistence").load({ last = true })<cr>]], desc = "load last state" },
            { "<leader>jd", [[<cmd>lua require("persistence").stop()<cr>]],                desc = "stop state persisit" }
        },
        opts = {
            -- add any custom options here
            dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
            options = { "buffers", "curdir", "tabpages", "winsize" },     -- sessionoptions used for saving
            pre_save = nil,                                               -- a function to call before saving the session
        },
        -- To configure it during initialization, because it needs to utilize the 'vimenter' event
        -- and can only listen to this event right at the beginning when the plugin is loaded.
        init = function(_, opts)
            local persistence = require("persistence")
            persistence.setup(opts)
            -- 配置打开vim自动还原上次的样子
            local persistenceGroup = vim.api.nvim_create_augroup("Persistence", { clear = true })
            local home = vim.fn.expand "~"
            local disabled_dirs = {
                home,
            }
            vim.api.nvim_create_autocmd({ "VimEnter" }, {
                group = persistenceGroup,
                callback = function()
                    local cwd = vim.fn.getcwd()
                    for _, path in pairs(disabled_dirs) do
                        if path == cwd then
                            persistence.stop()
                            return
                        end
                    end
                    -- 如果是`nvim`这样打开，而不是`nvim .`这样打开
                    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
                        vim.notify("load state", vim.log.levels.INFO)
                        persistence.load()
                    end
                end,
                nested = true,
            })
        end
    },
    -- 高亮相关的
    {
        'tzachar/local-highlight.nvim',
        event = { "BufReadPre", "BufNewFile" },
        opts = {}
    },
    -- 快速编写注释
    {
        "kkoomen/vim-doge",
        build = ":call doge#install()",
        keys = {
            {
                "<leader>k",
                "<Plug>(doge-generate)",
                silent = true,
                mode = { "n" },
                noremap = true,
                desc = "Generate comment"
            },
            {
                "<TAB>",
                "<Plug>(doge-comment-jump-forward)",
                mode = { "i", "n", "s" },
                silent = true,
                noremap = true,
                desc = "jump to next doge-comment"
            },
            {
                "<S-TAB>",
                "<Plug>(doge-comment-jump-backward)",
                mode = { "i", "n", "s" },
                silent = true,
                noremap = true,
                desc = "jump to backward doge-comment"
            },
        },
        -- must be false otherwise doge's ftplugin will not loaded, then came out g:xxx lost error
        lazy = false,
        init = function()
            vim.g.doge_enable_mappings  = 0
            vim.g.doge_filetype_aliases = {
                javascript = {
                    'javascript.jsx',
                    'javascriptreact',
                    'javascript.tsx',
                    'typescriptreact',
                    'typescript',
                    'typescript.tsx',
                },
                java = { 'groovy' },
            }
        end
    }
}
