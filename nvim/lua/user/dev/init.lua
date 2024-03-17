return {
    {
        "MagicMarvel/smart-im-select.nvim",
        dev = true,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "rcarriga/nvim-notify" },
        config = function()
            require("im_select").setup({})
        end,
    },
    { 'rafcamlet/nvim-luapad' }
}
