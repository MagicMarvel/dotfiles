return {
    init_options = {
        typescript = {
            tsdk = vim.fn.expand("~/.config/yarn/global/node_modules/typescript/lib")
            -- Alternative location if installed as root:
            -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
        }
    }

}
