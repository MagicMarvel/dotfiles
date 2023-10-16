local function augroup(name)
    return vim.api.nvim_create_augroup("_" .. name, { clear = true })
end

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        local current_line = vim.fn.line(".")
        -- set cursor to last exit state only when current cursor was in line 1
        -- because telescoop jump into file will at some specifical line you don't want to
        -- jump to the last position
        if mark[1] > 0 and mark[1] <= lcount and current_line == 1 then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    command = "checktime",
})


-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        -- vim.opt_local.spell = true
    end,
})
-- 切换2个空格或者4个空格的缩进
vim.api.nvim_create_user_command("SwitchSpace", function()
    if vim.o.shiftwidth == 4 and vim.o.tabstop == 4 then
        vim.notify("Set space to 2", vim.log.levels.INFO)
        vim.o.shiftwidth = 2
        vim.o.tabstop = 2
    else
        vim.notify("Set space to 4", vim.log.levels.INFO)
        vim.o.shiftwidth = 4
        vim.o.tabstop = 4
    end
end, {})

-- 切换是否是wrap
vim.api.nvim_create_user_command("SwitchWrap", function()
    if vim.o.wrap == true then
        vim.notify("Set nowrap", vim.log.levels.INFO)
        vim.o.wrap = false
    else
        vim.notify("Set wrap", vim.log.levels.INFO)
        vim.o.wrap = true
    end
end, {})
