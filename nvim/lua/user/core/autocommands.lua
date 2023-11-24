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

vim.api.nvim_create_user_command("SwitchNumber", function()
    if vim.o.number == true then
        vim.o.number = false
    else
        vim.o.number = true
    end
end, {})

-- 切换2个空格或者4个空格的缩进
vim.api.nvim_create_user_command("SwitchIndent", function()
    if vim.o.shiftwidth == 4 and vim.o.tabstop == 4 then
        vim.notify("Set indent to 2", vim.log.levels.INFO)
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
    else
        vim.notify("Set indent to 4", vim.log.levels.INFO)
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
    end
end, {})

-- 自动检测缩进
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = augroup("autoIndent"),
    callback = function()
        local lines_to_check = 30            -- 检查文件最后30行
        local total_lines = vim.fn.line("$") -- 获取文件总行数
        local single_indent_counts = {}
        local diff_indent_counts = {}
        local last_indent = nil

        for i = total_lines, math.max(total_lines - lines_to_check, 1), -1 do
            local line = vim.fn.getline(i)
            local spaces = line:match("^%s+")
            if spaces then
                local count = #spaces
                single_indent_counts[count] = (single_indent_counts[count] or 0) + 1

                if last_indent then
                    local indent_diff = math.abs(count - last_indent)
                    if indent_diff > 0 then
                        diff_indent_counts[indent_diff] = (diff_indent_counts[indent_diff] or 0) + 1
                    end
                end
                last_indent = count
            else
                last_indent = nil
            end
        end

        -- 获取出现次数最多的差异缩进
        local max_diff_indent = 0
        local max_diff_count = 0
        for indent, count in pairs(diff_indent_counts) do
            if count > max_diff_count then
                max_diff_indent = indent
                max_diff_count = count
            end
        end

        -- 如果没有差异缩进，获取出现次数最多的单层缩进
        local max_indent
        if max_diff_indent > 0 then
            max_indent = max_diff_indent
        else
            local max_single_indent = 0
            local max_single_count = 0
            for indent, count in pairs(single_indent_counts) do
                if count > max_single_count then
                    max_single_indent = indent
                    max_single_count = count
                end
            end
            max_indent = max_single_indent
        end

        max_indent = (max_indent == 2 or max_indent == 4) and max_indent or 4 -- 如果未检测到2或4的缩进，默认为4

        vim.opt.shiftwidth = max_indent
        vim.opt.tabstop = max_indent
    end
})
