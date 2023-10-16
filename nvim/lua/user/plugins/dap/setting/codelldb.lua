local dap = require('dap')
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            local currentDir = vim.api.nvim_call_function("getcwd", {})
            local success, errorMsg, errorCode = os.execute([[!clang++-13 % -g -o ]] .. currentDir .. [[/build/%:t:r ]])
            if not success then
                -- 处理编译错误
                vim.notify("编译错误: " .. errorCode .. errorMsg, vim.log.levels.ERROR)
            end
            -- vim.cmd([[!clang++-13 % -g -o ]] .. currentDir .. [[/build/%:t:r ]])
            return "${workspaceFolder}/build/${fileBasenameNoExtension}"
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
    {
        type = "codelldb",
        request = "attach",
        name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
    },
}
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        -- CHANGE THIS to your path!
        command = 'codelldb',
        args = { "--port", "${port}" },

        -- On windows you may have to uncomment this:
        -- detached = false,
    }
}
dap.configurations.c = dap.configurations.cpp
