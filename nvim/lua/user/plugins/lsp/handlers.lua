local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.on_attach = function(client, bufnr)
    -- 关闭部分语言服务器的格式化能力，改为其他源提供
    if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
    end

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



    --  开启更好的参数提示，函数对应的参数编写的时候会高亮 BUG: 有bug，与Noice冲突暂时关闭
    -- local status_signature, signature = pcall(require, "lsp_signature")
    -- if not status_signature then
    --     return
    -- end
    -- signature.on_attach({
    --     bind = true, -- This is mandatory, otherwise border config won't get registered.
    --     handler_opts = {
    --         border = "rounded"
    --     }
    -- }, bufnr)
end
return M
