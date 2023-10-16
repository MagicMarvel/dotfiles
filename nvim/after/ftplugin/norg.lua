local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "i" }, "<f4>", "<cmd>:Neorg toggle-concealer<cr>", opts)
