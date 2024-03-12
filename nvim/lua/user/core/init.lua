require("user.core.options")
require("user.core.autocommands")
require("user.core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        spec = {
            {
                import =
                "user.plugins"
            },
            { import = "user.dev" } -- only be used in MagicMarvel dev plugin, can be delete if you don't need it.
        },
        install = {
            -- install missing plugins on startup. This doesn't increase startup time.
            missing = true,
            -- try to load one of these colorschemes when starting an installation during startup
            colorscheme = { "habamax" },
        },
        defaults = {
            lazy = false, -- should plugins be lazy-loaded?
        },
        ui = {
            icons = {
                cmd = "⌘",
                config = "🛠",
                event = "📅",
                ft = "📂",
                init = "⚙",
                keys = "🗝",
                plugin = "🔌",
                runtime = "💻",
                source = "📄",
                start = "🚀",
                task = "📌",
                lazy = "💤 ",
            },
        },
        checker = {
            -- 检查是否有更新
            enabled = false
        },
        dev = {
            path = "~/allProject/lua-project/"
        }
    }
)
