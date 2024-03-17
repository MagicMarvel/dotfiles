-- 如果想增加新的LSP的支持，只需要把语言服务器的名字写在这里即可,理论上Mason会自动安装
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local servers = {
    "lua_ls",
    "cssls",
    "html",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
    "emmet_language_server",
    "yamlls",
    "tailwindcss",
    "clangd",
    "gopls",
    "marksman",
    -- support XML
    "lemminx",
    "dockerls",
    "volar",
    "rust_analyzer",
    "astro"
}

return {
    -- Mason install language server automatically
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ui = {
                border = "none",
                icons = {
                    package_installed = "◍",
                    package_pending = "◍",
                    package_uninstalled = "◍",
                },
            },
            log_level = vim.log.levels.ERROR,
            max_concurrent_installers = 4,
        }
    },
    -- simple to config mason
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = function()
            -- table.insert(servers, "emmet_language_server")
            return {
                -- 在这里填写的语言服务器都会被自动安装
                ensure_installed = servers,
                -- 这里的意思是lspconfig配置了的语言服务器都会被自动安装
                automatic_installation = true,
            }
        end
    },
    {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        -- here show all language server config example
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim", "williamboman/mason-lspconfig.nvim", "williamboman/mason.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",      desc = "Code Action" },
            {
                "<leader>ld",
                "<cmd>Telescope diagnostics bufnr=0<cr>",
                desc = "Document Diagnostics",
            },
            {
                "<leader>lw",
                "<cmd>Telescope diagnostics<cr>",
                desc = "Workspace Diagnostics",
            },
            { "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format" },
            { "<leader>li", "<cmd>LspInfo<cr>",                            desc = "Info" },
            { "<leader>lI", "<cmd>LspInstallInfo<cr>",                     desc = "Installer Info" },
            {
                "<leader>lj",
                "<cmd>lua vim.diagnostic.goto_next()<CR>",
                desc = "Next Diagnostic",
            },
            {
                "<leader>lk",
                "<cmd>lua vim.diagnostic.goto_prev()<cr>",
                desc = "Prev Diagnostic",
            },
            { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>",      desc = "CodeLens Action" },
            { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
            { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",        desc = "Rename" },
            { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
            {
                "<leader>lS",
                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                desc = "Workspace Symbols",
            },
            { "gD",   "<cmd>lua vim.lsp.buf.declaration()<CR>", },
            { "gd",   "<cmd>lua vim.lsp.buf.definition()<CR>", },
            { "K",    "<cmd>lua vim.lsp.buf.hover()<CR>", },
            { "gI",   "<cmd>lua vim.lsp.buf.implementation()<CR>", },
            { "gr",   "<cmd>lua vim.lsp.buf.references()<CR>", },
            { "gl",   "<cmd>lua vim.diagnostic.open_float()<CR>", },
            { '<F2>', "<cmd>lua vim.lsp.buf.rename()<CR>", },
        },
        config = function()
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            local lspconfig    = require "lspconfig"
            local configs      = require "lspconfig.configs"

            local on_attach    = require("user.plugins.lsp.handlers").on_attach
            local capabilities = require("user.plugins.lsp.handlers").capabilities

            for _, server in pairs(servers) do
                -- 这里的handle负责配置例如LSP连接成功了以后，配置keymap，配置VIM的出错图标等等，还可以让语言服务器的格式化能力失效
                -- 转为null-ls提供格式化，如ts-server prettier
                local opts = {
                    on_attach = on_attach,
                    capabilities = capabilities
                }

                server = vim.split(server, "@")[1]

                -- 这里是个性化配置LSP的地方，如果你不需要个性化配置的话，这里这一步可以不搞
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
                -- https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D#settings
                local require_ok, conf_opts = pcall(require, "user.plugins.lsp.settings." .. server)
                if require_ok then
                    opts = vim.tbl_deep_extend("force", conf_opts, opts)
                end

                -- lspconfig负责利用我们的配置拉起语言服务器并配置语言服务器与VIM
                lspconfig[server].setup(opts)

                -- -- Because the Emmet LSP from mason-configure wasn't configured (due to an issue from Mason)
                -- -- I manually set up Emmet here
                -- -- NOTE: This was just a temporary fix; the actual solution is pending my code submission to mason-config
                -- if not configs.emmet_language_server then
                --     configs.emmet_language_server = {
                --         default_config = {
                --             filetypes = {
                --                 "html",
                --                 "css",
                --                 "scss",
                --                 "javascript",
                --                 "javascriptreact",
                --                 "typescriptreact",
                --                 "svelte",
                --                 "vue",
                --             },
                --             cmd = { "emmet-language-server", "--stdio" },
                --             root_dir = lspconfig.util.root_pattern ".git",
                --             single_file_support = true,
                --             init_options = {
                --                 --- @type table<string, any> https://docs.emmet.io/customization/preferences/
                --                 preferences = {},
                --                 --- @type "always" | "never" defaults to `"always"`
                --                 showexpandedabbreviation = "always",
                --                 --- @type boolean defaults to `true`
                --                 showabbreviationsuggestions = true,
                --                 --- @type boolean defaults to `false`
                --                 showsuggestionsassnippets = false,
                --                 --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
                --                 syntaxprofiles = {},
                --                 --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
                --                 variables = {},
                --                 --- @type string[]
                --                 excludelanguages = {},
                --             },
                --         },
                --     }
                -- end
                --
                -- lspconfig.emmet_language_server.setup {
                --     on_attach = on_attach,
                --     capabilities = capabilities,
                -- }
            end
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
            local null_ls_status_ok, null_ls = pcall(require, "null-ls")
            if not null_ls_status_ok then
                return
            end

            -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
            local formatting = null_ls.builtins.formatting
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
            -- local diagnostics = null_ls.builtins.diagnostics
            return {
                debug = false,
                -- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                -- filetypes = { "markdown", "text" },
                sources = {
                    formatting.prettier.with({
                        filetypes = { "html", "javascript", "javascriptreact",
                            "typescript", "typescriptreact", "xml",
                            "css" },
                        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote",
                            "--tab-width=2" },
                    }),
                    formatting.yamlfmt,
                    formatting.black
                },
                on_attach = function(client, bufnr)
                    -- 连接上语言服务器后，开启保存就自动格式化的配置
                    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end
            }
        end
    },
    {
        "mfussenegger/nvim-jdtls",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim" },
        build = ":MasonInstall jdtls"
    },
    {
        "ray-x/lsp_signature.nvim",
        event = { "BufReadPre", "BufNewFile" },
        enabled = function()
            if vim.g.neovide then
                return true
            else
                return false
            end
        end
    },
    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = false,
            },
            panel = { enabled = false },
        }
    },
    {
        "zbirenbaum/copilot-cmp",
        enabled = false,
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        config = function()
            require("copilot_cmp").setup()
        end
    }

}
