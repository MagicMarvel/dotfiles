return {
    {
        "MagicMarvel/smart-im-select.nvim",
        enabled = false,
        dev = true,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "rcarriga/nvim-notify" },
        config = function()
            require("im_select").setup({})
        end,
    },
    {
        "keaising/im-select.nvim",
        enabled = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        dev = true,
        config = function()
            require("im_select").setup({
                smart_switch = true
            })
        end,
    },
    { 'rafcamlet/nvim-luapad' }
}
