return {
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                numbers = "none",                    -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
                close_command = "Bdelete! %d",       -- can be a string | function, see "Mouse actions"
                right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
                middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
                -- NOTE: this plugin is designed with this icon in mind,
                -- and so changing this is NOT recommended, this is intended
                -- as an escape hatch for people who cannot bear it for whatever reason
                indicator_icon = nil,
                indicator = { style = "icon", icon = "▎" },
                -- buffer_close_icon = "",
                buffer_close_icon = '',
                modified_icon = "●",
                close_icon = "",
                -- close_icon = '',
                left_trunc_marker = "",
                right_trunc_marker = "",
                --- name_formatter can be used to change the buffer's label in the bufferline.
                --- Please note some names can/will break the
                --- bufferline so use this at your discretion knowing that it has
                --- some limitations that will *NOT* be fixed.
                name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
                    -- remove extension from markdown files for example
                    if buf.name:match('%.md') then
                        return vim.fn.fnamemodify(buf.name, ':t:r')
                    end
                end,
                max_name_length = 30,
                max_prefix_length = 30,   -- prefix used when a buffer is de-duplicated
                tab_size = 21,
                diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
                diagnostics_update_in_insert = false,
                -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
                --   return "("..count..")"
                -- end,
                -- NOTE: this will be called a lot so don't do any heavy processing here
                -- custom_filter = function(buf_number)
                --   -- filter out filetypes you don't want to see
                --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                --     return true
                --   end
                --   -- filter out by buffer name
                --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                --     return true
                --   end
                --   -- filter out based on arbitrary rules
                --   -- e.g. filter out vim wiki buffer from tabline in your work repo
                --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                --     return true
                --   end
                -- end,

                offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                show_tab_indicators = true,
                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                -- can also be a table containing 2 custom separators
                -- [focused and unfocused]. eg: { '|', '|' }
                separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
                enforce_regular_tabs = true,
                always_show_bufferline = true,
                -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
                --   -- add custom logic
                --   return buffer_a.modified > buffer_b.modified
                -- end
            },
        }
    },
    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },
    -- ui components
    { "MunifTanjim/nui.nvim",        lazy = true },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[ __  __                   _          __  __                                 _ ]],
                [[|  \/  |   __ _    __ _  (_)   ___  |  \/  |   __ _   _ __  __   __   ___  | |]],
                [[| |\/| |  / _` |  / _` | | |  / __| | |\/| |  / _` | | '__| \ \ / /  / _ \ | |]],
                [[| |  | | | (_| | | (_| | | | | (__  | |  | | | (_| | | |     \ V /  |  __/ | |]],
                [[|_|  |_|  \__,_|  \__, | |_|  \___| |_|  |_|  \__,_| |_|      \_/    \___| |_|]],
                [[                  |___/                                                      ]]
            }
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
                dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
                dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
            }

            local function footer()
                -- NOTE: requires the fortune-mod package to work
                -- local handle = io.popen("fortune")
                -- local fortune = handle:read("*a")
                -- handle:close()
                -- return fortune
                return "https://www.github.com/MagicMarvel"
            end

            dashboard.section.footer.val = footer()

            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Keyword"

            dashboard.opts.opts.noautocmd = true
            -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
            require("alpha").setup(dashboard.opts)
        end
    },
    -- command line UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        enable = function()
            if vim.g.neovide then
                return false
            else
                return true
            end
        end,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "echo",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        }
    },
    {
        "rcarriga/nvim-notify",
        dependencies = {
            "nvim-telescope/telescope.nvim"
        },
        keys = {
            {
                "<leader>n",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss Notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.5)
            end,
            background_colour = "#1e2030",
            render = "wrapped-compact",
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
            require("telescope").load_extension("notify")
        end
    },
    -- 缩进线
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        enabled = false,
        config = function()
            vim.opt.termguicolors = true
            vim.opt.list = true
            vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_first_indent_level = false,
                show_current_context = true,
                show_current_context_start = true,
                char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                    "IndentBlanklineIndent3",
                    "IndentBlanklineIndent4",
                    "IndentBlanklineIndent5",
                    "IndentBlanklineIndent6",
                },
            }
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "folke/lazy.nvim"
        },
        event = "VeryLazy",
        opts = function()
            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            local diagnostics = {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn" },
                symbols = { error = " ", warn = " " },
                colored = false,
                update_in_insert = false,
                always_visible = true,
            }

            local diff = {
                "diff",
                colored = false,
                symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
                cond = hide_in_width
            }

            local mode = {
                "mode",
                fmt = function(str)
                    return "-- " .. str .. " --"
                end,
            }

            local filetype = {
                "filetype",
                icons_enabled = false,
                icon = nil,
            }

            local branch = {
                "branch",
                icons_enabled = true,
                icon = "",
            }

            local location = {
                "location",
                padding = 0,
            }

            local spaces = function()
                return "spaces: " .. vim.opt.tabstop:get()
            end
            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },

                    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = { branch, diagnostics },
                    lualine_b = { mode },
                    lualine_c = {
                        {
                            ---@diagnostic disable-next-line: undefined-field
                            require("noice").api.status.mode.get,
                            ---@diagnostic disable-next-line: undefined-field
                            cond = require("noice").api.status.mode.has,
                            color = { fg = "#ff9e64" },
                        }
                    },
                    lualine_x = { {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = { fg = "#ff9e64" },
                    }, {
                        "filename", path = 1
                    } },
                    lualine_y = { diff },
                    lualine_z = {
                        -- location,
                        spaces, "encoding", "fileformat", filetype },
                },
                tabline = {},
                extensions = {},
            }
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy   = true,
        init   = function()
            vim.cmd [[colorscheme tokyonight]]
        end,
        opts   = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            style = "moon",         -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            light_style = "day",    -- The theme is used when the background is set to light
            transparent = false,    -- Enable this to disable setting the background color
            terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                comments = { italic = false },
                keywords = { italic = true },
                functions = {},
                variables = {},
                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "dark",           -- style for sidebars, see below
                floats = "dark",             -- style for floating windows
            },
            sidebars = { "qf", "help" },     -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            day_brightness = 0.3,            -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
            hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = true,             -- dims inactive windows
            lualine_bold = true,             -- When `true`, section headers in the lualine theme will be bold

            --- You can override specific color groups to use other groups or a hex color
            --- function will be called with a ColorScheme table
            -- @param colors ColorScheme
            on_colors = function(colors) end,

            --- You can override specific highlights to use other groups or a hex color
            --- function will be called with a Highlights and ColorScheme table
            -- @param highlights Highlights
            -- @param colors ColorScheme
            on_highlights = function(highlights, colors) end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
        end
    },
    {
        "lunarvim/darkplus.nvim",
        lazy = true,
        -- init = function()
        --     vim.cmd [[colorscheme darkplus]]
        -- end
    },
    {
        "tomasiser/vim-code-dark",
        lazy = true,
    },
    {
        -- Automatically creates missing LSP diagnostics highlight groups for color schemes
        -- that don't yet support the Neovim 0.5 builtin lsp client.
        'folke/lsp-colors.nvim',
    },
    {
        "jacoborus/tender.vim",
        lazy = true,
        -- init = function()
        --     vim.cmd [[colorscheme tender]]
        -- end
    }
}
